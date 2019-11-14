codeunit 14135117 "lvngSalesFileImportManagement"
{
    procedure CreateSalesLines(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; lvngDocumentType: enum lvngDocumentType; lvngDocumentNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        DimensionManagement: Codeunit DimensionManagement;
        LineNo: Integer;
    begin
        if lvngDocumentType = lvngDocumentType::lvngCreditMemo then begin
            SalesHeader.Get(SalesHeader."Document Type"::"Credit Memo", lvngDocumentNo);
        end else begin
            SalesHeader.Get(SalesHeader."Document Type"::Invoice, lvngDocumentNo);
        end;
        SalesLine.reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast() then begin
            LineNo := SalesLine."Line No." + 100;
        end else begin
            LineNo := 100;
        end;
        lvngGenJnlImportBuffer.reset;
        lvngGenJnlImportBuffer.FindSet();
        repeat
            Clear(SalesLine);
            SalesLine.init;
            SalesLine.validate("Document Type", SalesHeader."Document Type");
            SalesLine.Validate("Document No.", SalesHeader."No.");
            SalesLine."Line No." := LineNo;
            SalesLine.Insert(true);
            SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
            SalesLine.Validate("No.", lvngGenJnlImportBuffer.lvngAccountNo);
            if lvngGenJnlImportBuffer.lvngDescription <> '' then begin
                SalesLine.Description := lvngGenJnlImportBuffer.lvngDescription;
            end;
            SalesLine.Validate(Quantity, 1);
            SalesLine.Validate("Unit Price", lvngGenJnlImportBuffer.lvngAmount);
            if lvngGenJnlImportBuffer.lvngReasonCode <> '' then begin
                SalesLine.Validate(lvngReasonCode, lvngGenJnlImportBuffer.lvngReasonCode);
            end;
            SalesLine.lvngLoanNo := lvngGenJnlImportBuffer.lvngLoanNo;
            if lvngGenJnlImportBuffer.lvngShortcutDimension4Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(4, lvngGenJnlImportBuffer.lvngShortcutDimension4Code, SalesLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngShortcutDimension3Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(3, lvngGenJnlImportBuffer.lvngShortcutDimension3Code, SalesLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngGlobalDimension2Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(2, lvngGenJnlImportBuffer.lvngGlobalDimension2Code, SalesLine."Dimension Set ID");
            SalesLine."Shortcut Dimension 2 Code" := lvngGenJnlImportBuffer.lvngGlobalDimension2Code;
            if lvngGenJnlImportBuffer.lvngGlobalDimension1Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(1, lvngGenJnlImportBuffer.lvngGlobalDimension1Code, SalesLine."Dimension Set ID");
            SalesLine."Shortcut Dimension 1 Code" := lvngGenJnlImportBuffer.lvngGlobalDimension1Code;
            if lvngGenJnlImportBuffer.lvngShortcutDimension5Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(5, lvngGenJnlImportBuffer.lvngShortcutDimension5Code, SalesLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngShortcutDimension6Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(6, lvngGenJnlImportBuffer.lvngShortcutDimension6Code, SalesLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngShortcutDimension7Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(7, lvngGenJnlImportBuffer.lvngShortcutDimension7Code, SalesLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngShortcutDimension8Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(8, lvngGenJnlImportBuffer.lvngShortcutDimension8Code, SalesLine."Dimension Set ID");
            SalesLine.Modify();
            LineNo := LineNo + 100;
        until lvngGenJnlImportBuffer.Next() = 0;
    end;

    procedure ManualFileImport(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; var lvngImportBufferError: Record lvngImportBufferError): Boolean
    begin
        lvngFileImportSchema.reset;
        lvngFileImportSchema.SetRange("File Import Type", lvngFileImportSchema."File Import Type"::lvngSalesLine);
        if page.RunModal(0, lvngFileImportSchema) = Action::LookupOK then begin
            lvngGenJnlImportBuffer.reset;
            lvngGenJnlImportBuffer.DeleteAll();
            lvngFileImportSchema.Get(lvngFileImportSchema.Code);
            lvngFileImportJnlLine.Reset();
            lvngFileImportJnlLine.SetRange(Code, lvngFileImportSchema.Code);
            lvngFileImportJnlLine.FindSet();
            repeat
                Clear(lvngFileImportJnlLineTemp);
                lvngFileImportJnlLineTemp := lvngFileImportJnlLine;
                lvngFileImportJnlLineTemp.Insert();
            until lvngFileImportJnlLine.Next() = 0;
            ReadCSVStream();
            ProcessImportCSVBuffer(lvngGenJnlImportBuffer);
            ValidateEntries(lvngGenJnlImportBuffer, lvngImportBufferError);
            exit(true);
        end;
        exit(false);
    end;

    local procedure ReadCSVStream()
    var
        TabChar: Char;
    begin
        TabChar := 9;
        if lvngFileImportSchema."Field Separator" = '<TAB>' then
            lvngFileImportSchema."Field Separator" := Format(TabChar);
        lvngImportToStream := UploadIntoStream(lvngOpenFileLabel, '', '', lvngFileName, lvngImportStream);
        if lvngImportToStream then begin
            CSVBufferTemp.LoadDataFromStream(lvngImportStream, lvngFileImportSchema."Field Separator");
            CSVBufferTemp.ResetFilters();
            CSVBufferTemp.SetRange("Line No.", 0, lvngFileImportSchema."Skip Rows");
            CSVBufferTemp.DeleteAll();
        end else begin
            Error(lvngErrorReadingToStreamLabel);
        end;
    end;

    local procedure ProcessImportCSVBuffer(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngStartLine: Integer;
        lvngEndLine: Integer;
        lvngValue: Text;
        lvngValue2: Text;
        Pos: Integer;
    begin
        lvngGenJnlImportBuffer.Reset();
        lvngGenJnlImportBuffer.DeleteAll();
        CSVBufferTemp.ResetFilters();
        CSVBufferTemp.FindFirst();
        lvngStartLine := CSVBufferTemp."Line No.";
        lvngEndLine := CSVBufferTemp.GetNumberOfLines();
        CSVBufferTemp.ResetFilters();
        repeat
            Clear(lvngGenJnlImportBuffer);
            lvngGenJnlImportBuffer.lvngLineNo := lvngStartLine;
            lvngGenJnlImportBuffer.Insert(true);
            lvngFileImportJnlLineTemp.reset;
            lvngFileImportJnlLineTemp.SetRange(Code, lvngFileImportSchema.Code);
            lvngFileImportJnlLineTemp.SetFilter("Sales Import Field Type", '<>%1', lvngFileImportJnlLine."Sales Import Field Type"::lvngDummy);
            lvngFileImportJnlLineTemp.FindSet();
            repeat
                lvngValue := CSVBufferTemp.GetValue(lvngStartLine, lvngFileImportJnlLineTemp."Column No.");
                if lvngValue <> '' then begin
                    case lvngFileImportJnlLineTemp."Sales Import Field Type" of
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngAccountNo:
                            begin
                                lvngGenJnlImportBuffer.lvngAccountValue := copystr(lvngValue, 1, maxstrlen(lvngGenJnlImportBuffer.lvngAccountValue));
                                if lvngFileImportJnlLineTemp."Dimension Split" then begin
                                    IF lvngFileImportJnlLineTemp."Dimension Split Character" <> '' THEN BEGIN
                                        Pos := STRPOS(lvngValue, lvngFileImportJnlLineTemp."Dimension Split Character");
                                        IF Pos <> 0 THEN BEGIN
                                            lvngValue2 := COPYSTR(lvngValue, Pos + 1);
                                            lvngValue := COPYSTR(lvngValue, 1, Pos - 1);
                                            lvngGenJnlImportBuffer.lvngAccountValue := copystr(lvngValue, 1, maxstrlen(lvngGenJnlImportBuffer.lvngAccountValue));
                                            case lvngFileImportJnlLineTemp."Split Dimension No." of
                                                1:
                                                    lvngGenJnlImportBuffer.lvngGlobalDimension1Value := lvngValue2;
                                                2:
                                                    lvngGenJnlImportBuffer.lvngGlobalDimension2Value := lvngValue2;
                                                3:
                                                    lvngGenJnlImportBuffer.lvngShortcutDimension3Value := lvngValue2;
                                                4:
                                                    lvngGenJnlImportBuffer.lvngShortcutDimension4Value := lvngValue2;
                                                5:
                                                    lvngGenJnlImportBuffer.lvngShortcutDimension5Value := lvngValue2;
                                                6:
                                                    lvngGenJnlImportBuffer.lvngShortcutDimension6Value := lvngValue2;
                                                7:
                                                    lvngGenJnlImportBuffer.lvngShortcutDimension7Value := lvngValue2;
                                                8:
                                                    lvngGenJnlImportBuffer.lvngShortcutDimension8Value := lvngValue2;
                                            end;
                                        END;
                                    END;
                                end;
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngAmount:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngAmount, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDescription:
                            begin
                                lvngGenJnlImportBuffer.lvngDescription := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngDescription));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension1Code:
                            begin
                                lvngGenJnlImportBuffer.lvngGlobalDimension1Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngGlobalDimension1Value));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension2Code:
                            begin
                                lvngGenJnlImportBuffer.lvngGlobalDimension2Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngGlobalDimension2Value));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension3Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension3Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension3Value));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension4Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension4Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension4Value));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension5Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension5Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension5Value));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension6Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension6Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension6Value));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension7Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension7Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension7Value));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension8Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension8Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension8Value));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngLoanNo:
                            begin
                                lvngGenJnlImportBuffer.lvngLoanNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngLoanNo));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngReasonCode:
                            begin
                                lvngGenJnlImportBuffer.lvngReasonCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngReasonCode));
                            end;
                    end;
                end;
            until lvngFileImportJnlLineTemp.Next() = 0;
            lvngGenJnlImportBuffer.Modify();
            lvngStartLine := lvngStartLine + 1;
        until (lvngStartLine > lvngEndLine);
    end;

    local procedure ValidateEntries(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; var lvngImportBufferError: Record lvngImportBufferError)
    var
        lvngAccountNoBlankOrMissingLbl: Label 'Account %1 %2 is missing or blank';
        lvngLoanNoNotFoundLbl: Label 'Loan No. %1 not found';
        lvngReasonCodeMissingLbl: Label '%1 Reason Code is not available';
    begin
        MainDimensionCode := lvngDimensionsManagement.GetMainHierarchyDimensionCode();
        MainDimensionNo := lvngDimensionsManagement.GetMainHierarchyDimensionNo();
        lvngDimensionsManagement.GetHierarchyDimensionsUsage(HierarchyDimensionsUsage);
        if MainDimensionNo <> 0 then
            HierarchyDimensionsUsage[MainDimensionNo] := false;

        lvngImportBufferError.reset;
        lvngImportBufferError.DeleteAll();
        lvngGenJnlImportBuffer.reset;
        if lvngGenJnlImportBuffer.FindSet() then begin
            repeat
                //Amount
                if lvngFileImportSchema."Reverse Amount Sign" then begin
                    lvngGenJnlImportBuffer.lvngAmount := -lvngGenJnlImportBuffer.lvngAmount;
                end;
                //Document Type
                if lvngFileImportSchema."Document Type Option" = lvngFileImportSchema."Document Type Option"::lvngPredefined then begin
                    lvngGenJnlImportBuffer.lvngDocumentType := lvngFileImportSchema."Document Type";
                end;

                //Account Type and Account No.
                FindAccountNo(lvngGenJnlImportBuffer.lvngAccountValue, lvngGenJnlImportBuffer.lvngAccountNo);
                if lvngFileImportSchema."Default Account No." <> '' then begin
                    lvngGenJnlImportBuffer.lvngAccountType := lvngFileImportSchema."Gen. Jnl. Account Type"::"G/L Account";
                    lvngGenJnlImportBuffer.lvngAccountNo := lvngFileImportSchema."Default Account No.";
                end;
                if lvngGenJnlImportBuffer.lvngAccountNo = '' then begin
                    AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngAccountNoBlankOrMissingLbl, lvngGenJnlImportBuffer.lvngAccountType, lvngGenJnlImportBuffer.lvngAccountValue));
                end;

                //Loan No.
                if lvngGenJnlImportBuffer.lvngLoanNo <> '' then begin
                    if not CheckLoanNo(lvngGenJnlImportBuffer.lvngLoanNo) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngLoanNoNotFoundLbl, lvngGenJnlImportBuffer.lvngLoanNo));
                    end;
                    if lvngGenJnlImportBuffer.lvngLoanNo <> '' then begin
                        if lvngFileImportSchema."Dimension Validation Rule" = lvngFileImportSchema."Dimension Validation Rule"::lvngAllLoanDimensions then begin
                            AssignLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                        if lvngFileImportSchema."Dimension Validation Rule" = lvngFileImportSchema."Dimension Validation Rule"::lvngEmptyDimensions then begin
                            AssignEmptyLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                        if lvngFileImportSchema."Dimension Validation Rule" = lvngFileImportSchema."Dimension Validation Rule"::lvngLoanAndExcludeImportedDimensions then begin
                            AssignNotImportedLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                    end;
                end;

                //Dimensions
                AssignDimensions(lvngGenJnlImportBuffer);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 1 Mandatory", 1, lvngGenJnlImportBuffer.lvngGlobalDimension1Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 2 Mandatory", 2, lvngGenJnlImportBuffer.lvngGlobalDimension2Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 3 Mandatory", 3, lvngGenJnlImportBuffer.lvngShortcutDimension3Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 4 Mandatory", 4, lvngGenJnlImportBuffer.lvngShortcutDimension4Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 5 Mandatory", 5, lvngGenJnlImportBuffer.lvngShortcutDimension5Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 6 Mandatory", 6, lvngGenJnlImportBuffer.lvngShortcutDimension6Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 7 Mandatory", 7, lvngGenJnlImportBuffer.lvngShortcutDimension7Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 8 Mandatory", 8, lvngGenJnlImportBuffer.lvngShortcutDimension8Code, lvngImportBufferError);

                //Reason Code
                if lvngGenJnlImportBuffer.lvngReasonCode = '' then begin
                    lvngGenJnlImportBuffer.lvngReasonCode := lvngFileImportSchema."Reason Code";
                end;
                if lvngGenJnlImportBuffer.lvngReasonCode <> '' then begin
                    if not CheckReasonCode(lvngGenJnlImportBuffer) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, strsubstno(lvngReasonCodeMissingLbl, lvngGenJnlImportBuffer.lvngReasonCode));
                    end;
                end;
                //----
                lvngGenJnlImportBuffer.Modify();
            until lvngGenJnlImportBuffer.Next() = 0
        end;
    end;

    local procedure ValidateDimension(lvngLineNo: integer; Mandatory: boolean; DimensionNo: Integer; DimensionValueCode: Code[20]; var lvngImportBufferError: Record lvngImportBufferError)
    var
        DimensionValue: Record "Dimension Value";
        lvngMandatoryDimensionBlankLbl: Label 'Mandatory Dimension %1 is blank';
        lvngDimensionValueCodeMissingLbl: Label 'Dimension Value Code %1 is missing';
        lvngDimensionValueCodeBlockedLbl: Label 'Dimension Value Code %1 is blocked';
    begin
        if Mandatory then begin
            if DimensionValueCode = '' then begin
                AddErrorLine(lvngLineNo, lvngImportBufferError, StrSubstNo(lvngMandatoryDimensionBlankLbl, DimensionNo));
            end;
        end;
        if DimensionValueCode <> '' then begin
            DimensionValue.reset;
            DimensionValue.SetRange("Global Dimension No.", DimensionNo);
            DimensionValue.SetRange(Code, DimensionValueCode);
            if not DimensionValue.FindFirst() then begin
                AddErrorLine(lvngLineNo, lvngImportBufferError, StrSubstNo(lvngDimensionValueCodeMissingLbl, DimensionValueCode));
            end else begin
                if DimensionValue.Blocked then begin
                    AddErrorLine(lvngLineNo, lvngImportBufferError, StrSubstNo(lvngDimensionValueCodeBlockedLbl, DimensionValueCode));
                end;
            end;
        end;
    end;

    local procedure AssignDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngDimensionHierarchy: Record lvngDimensionHierarchy;
        DimensionCode: Code[20];
    begin
        SearchDimension(1, lvngFileImportSchema."Dimension 1 Mapping Type", lvngGenJnlImportBuffer.lvngGlobalDimension1Value, lvngGenJnlImportBuffer.lvngGlobalDimension1Code);
        SearchDimension(2, lvngFileImportSchema."Dimension 2 Mapping Type", lvngGenJnlImportBuffer.lvngGlobalDimension2Value, lvngGenJnlImportBuffer.lvngGlobalDimension2Code);
        SearchDimension(3, lvngFileImportSchema."Dimension 3 Mapping Type", lvngGenJnlImportBuffer.lvngShortcutDimension3Value, lvngGenJnlImportBuffer.lvngShortcutDimension3Code);
        SearchDimension(4, lvngFileImportSchema."Dimension 4 Mapping Type", lvngGenJnlImportBuffer.lvngShortcutDimension4Value, lvngGenJnlImportBuffer.lvngShortcutDimension4Code);
        SearchDimension(5, lvngFileImportSchema."Dimension 5 Mapping Type", lvngGenJnlImportBuffer.lvngShortcutDimension5Value, lvngGenJnlImportBuffer.lvngShortcutDimension5Code);
        SearchDimension(6, lvngFileImportSchema."Dimension 6 Mapping Type", lvngGenJnlImportBuffer.lvngShortcutDimension6Value, lvngGenJnlImportBuffer.lvngShortcutDimension6Code);
        SearchDimension(7, lvngFileImportSchema."Dimension 7 Mapping Type", lvngGenJnlImportBuffer.lvngShortcutDimension7Value, lvngGenJnlImportBuffer.lvngShortcutDimension7Code);
        SearchDimension(8, lvngFileImportSchema."Dimension 8 Mapping Type", lvngGenJnlImportBuffer.lvngShortcutDimension8Value, lvngGenJnlImportBuffer.lvngShortcutDimension8Code);
        case MainDimensionNo of
            1:
                DimensionCode := lvngGenJnlImportBuffer.lvngGlobalDimension1Code;
            2:
                DimensionCode := lvngGenJnlImportBuffer.lvngGlobalDimension2Code;
            3:
                DimensionCode := lvngGenJnlImportBuffer.lvngShortcutDimension3Code;
            4:
                DimensionCode := lvngGenJnlImportBuffer.lvngShortcutDimension4Code;
        end;
        lvngDimensionHierarchy.reset;
        lvngDimensionHierarchy.Ascending(false);
        lvngDimensionHierarchy.SetFilter(Date, '..%1', lvngGenJnlImportBuffer.lvngPostingDate);
        lvngDimensionHierarchy.SetRange(Code, DimensionCode);
        if lvngDimensionHierarchy.FindFirst() then begin
            if HierarchyDimensionsUsage[1] then
                lvngGenJnlImportBuffer.lvngGlobalDimension1Code := lvngDimensionHierarchy."Global Dimension 1 Code";
            if HierarchyDimensionsUsage[2] then
                lvngGenJnlImportBuffer.lvngGlobalDimension2Code := lvngDimensionHierarchy."Global Dimension 2 Code";
            if HierarchyDimensionsUsage[3] then
                lvngGenJnlImportBuffer.lvngShortcutDimension3Code := lvngDimensionHierarchy."Shortcut Dimension 3 Code";
            if HierarchyDimensionsUsage[4] then
                lvngGenJnlImportBuffer.lvngShortcutDimension4Code := lvngDimensionHierarchy."Shortcut Dimension 4 Code";
            if HierarchyDimensionsUsage[5] then
                lvngGenJnlImportBuffer.lvngBusinessUnitCode := lvngDimensionHierarchy."Business Unit Code";
        end;
    end;

    local procedure SearchDimension(lvngDimensionNo: Integer; lvngDimensionMappingType: enum lvngDimensionMappingType; lvngDimensionValue: Text; var DimensionValueCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
    begin
        if (DimensionValueCode = '') and (lvngDimensionValue <> '') then begin
            DimensionValue.reset;
            DimensionValue.SetRange("Global Dimension No.", lvngDimensionNo);
            case lvngDimensionMappingType of
                lvngDimensionMappingType::lvngCode:
                    begin
                        DimensionValue.SetRange(Code, copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.Code)));
                    end;
                lvngDimensionMappingType::lvngName:
                    begin
                        DimensionValue.SetFilter(Name, copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.Name)));
                    end;
                lvngDimensionMappingType::lvngSearchName:
                    begin
                        DimensionValue.Setrange(Name, '@' + copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.Name)));
                    end;
                lvngDimensionMappingType::lvngAdditionalCode:
                    begin
                        DimensionValue.SetRange(lvngAdditionalCode, copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.lvngAdditionalCode)));
                    end;
            end;
            if DimensionValue.FindFirst() then
                DimensionValueCode := DimensionValue.Code;
        end;
    end;

    local procedure CheckReasonCode(lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        ReasonCode: record "Reason Code";
    begin
        if not ReasonCode.Get(lvngGenJnlImportBuffer.lvngReasonCode) then
            exit(false);
        exit(True);
    end;

    local procedure AssignLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer.lvngLoanNo) then begin
            lvngGenJnlImportBuffer.lvngGlobalDimension1Code := lvngLoan."Global Dimension 1 Code";
            lvngGenJnlImportBuffer.lvngGlobalDimension2Code := lvngLoan."Global Dimension 2 Code";
            lvngGenJnlImportBuffer.lvngShortcutDimension3Code := lvngLoan."Shortcut Dimension 3 Code";
            lvngGenJnlImportBuffer.lvngShortcutDimension4Code := lvngLoan."Shortcut Dimension 4 Code";
            lvngGenJnlImportBuffer.lvngShortcutDimension5Code := lvngLoan."Shortcut Dimension 5 Code";
            lvngGenJnlImportBuffer.lvngShortcutDimension6Code := lvngLoan."Shortcut Dimension 6 Code";
            lvngGenJnlImportBuffer.lvngShortcutDimension7Code := lvngLoan."Shortcut Dimension 7 Code";
            lvngGenJnlImportBuffer.lvngShortcutDimension8Code := lvngLoan."Shortcut Dimension 8 Code";
            lvngGenJnlImportBuffer.lvngBusinessUnitCode := lvngLoan."Business Unit Code";
        end;
    end;

    local procedure AssignEmptyLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer.lvngLoanNo) then begin
            if lvngGenJnlImportBuffer.lvngGlobalDimension1Value = '' then
                lvngGenJnlImportBuffer.lvngGlobalDimension1Code := lvngLoan."Global Dimension 1 Code";
            if lvngGenJnlImportBuffer.lvngGlobalDimension2Value = '' then
                lvngGenJnlImportBuffer.lvngGlobalDimension2Code := lvngLoan."Global Dimension 2 Code";
            if lvngGenJnlImportBuffer.lvngShortcutDimension3Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension3Code := lvngLoan."Shortcut Dimension 3 Code";
            if lvngGenJnlImportBuffer.lvngShortcutDimension4Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension4Code := lvngLoan."Shortcut Dimension 4 Code";
            if lvngGenJnlImportBuffer.lvngShortcutDimension5Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension5Code := lvngLoan."Shortcut Dimension 5 Code";
            if lvngGenJnlImportBuffer.lvngShortcutDimension6Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension6Code := lvngLoan."Shortcut Dimension 6 Code";
            if lvngGenJnlImportBuffer.lvngShortcutDimension7Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension7Code := lvngLoan."Shortcut Dimension 7 Code";
            if lvngGenJnlImportBuffer.lvngShortcutDimension8Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension8Code := lvngLoan."Shortcut Dimension 8 Code";
            if lvngGenJnlImportBuffer.lvngBusinessUnitCode = '' then
                lvngGenJnlImportBuffer.lvngBusinessUnitCode := lvngLoan."Business Unit Code";
        end;
    end;

    local procedure AssignNotImportedLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer.lvngLoanNo) then begin
            lvngFileImportJnlLineTemp.reset;
            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension1Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngGlobalDimension1Code := lvngLoan."Global Dimension 1 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension2Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngGlobalDimension2Code := lvngLoan."Global Dimension 2 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension3Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension3Code := lvngLoan."Shortcut Dimension 3 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension4Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension4Code := lvngLoan."Shortcut Dimension 4 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension5Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension5Code := lvngLoan."Shortcut Dimension 5 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension6Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension6Code := lvngLoan."Shortcut Dimension 6 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension7Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension7Code := lvngLoan."Shortcut Dimension 7 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::lvngDimension8Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension8Code := lvngLoan."Shortcut Dimension 8 Code";
        end;
    end;

    local procedure CheckLoanNo(var lvngLoanNo: Code[20]): Boolean
    var
        lvngLoan: Record lvngLoan;
    begin
        case lvngFileImportSchema."Loan No. Validation Rule" of
            lvngFileImportSchema."Loan No. Validation Rule"::lvngBlankIfNotFound:
                begin
                    if not lvngLoan.Get(lvngLoanNo) then begin
                        Clear(lvngLoanNo);
                        exit(true);
                    end;
                end;
            lvngFileImportSchema."Loan No. Validation Rule"::lvngValidate:
                begin
                    if not lvngloan.Get(lvngLoanNo) then
                        exit(false);
                end;
        end;
        exit(true);
    end;

    local procedure FindAccountNo(lvngValue: Text; var lvngAccountNo: Code[20])
    var
        GLAccount: Record "G/L Account";
    begin
        //Account Type and Account No.
        case lvngFileImportSchema."Account Mapping Type" of
            lvngFileImportSchema."Account Mapping Type"::lvngName:
                begin
                    GLAccount.reset;
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.SetFilter(Name, '@' + lvngValue);
                    if GLAccount.FindFirst() then begin
                        lvngAccountNo := GLAccount."No.";
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::lvngNo:
                begin
                    GLAccount.reset;
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.SetRange("No.", lvngValue);
                    if GLAccount.FindFirst() then begin
                        lvngAccountNo := GLAccount."No.";
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::lvngNo2:
                begin
                    GLAccount.reset;
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.SetRange("No. 2", lvngValue);
                    if GLAccount.FindFirst() then begin
                        lvngAccountNo := GLAccount."No.";
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::lvngSearchName:
                begin
                    GLAccount.reset;
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.SetRange("Search Name", lvngValue);
                    if GLAccount.FindFirst() then begin
                        lvngAccountNo := GLAccount."No.";
                    end;
                end;
        end;
    end;

    local procedure AddErrorLine(lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; var lvngImportBufferError: Record lvngImportBufferError; ErrorText: Text)
    var
        lvngErrorLineNo: Integer;
    begin
        lvngImportBufferError.reset;
        lvngImportBufferError.SetRange(lvngLineNo, lvngGenJnlImportBuffer.lvngLineNo);
        if lvngImportBufferError.FindLast() then begin
            lvngErrorLineNo := lvngImportBufferError.lvngErrorNo + 100;
        end else begin
            lvngErrorLineNo := 100;
        end;
        Clear(lvngImportBufferError);
        lvngImportBufferError.lvngLineNo := lvngGenJnlImportBuffer.lvngLineNo;
        lvngImportBufferError.lvngErrorNo := lvngErrorLineNo;
        lvngImportBufferError.lvngDescription := CopyStr(ErrorText, 1, MaxStrLen(lvngImportBufferError.lvngDescription));
        lvngImportBufferError.Insert();
    end;

    local procedure AddErrorLine(lvngLineNo: Integer; var lvngImportBufferError: Record lvngImportBufferError; ErrorText: Text)
    var
        lvngErrorLineNo: Integer;
    begin
        lvngImportBufferError.reset;
        lvngImportBufferError.SetRange(lvngLineNo, lvngLineNo);
        if lvngImportBufferError.FindLast() then begin
            lvngErrorLineNo := lvngImportBufferError.lvngErrorNo + 100;
        end else begin
            lvngErrorLineNo := 100;
        end;
        Clear(lvngImportBufferError);
        lvngImportBufferError.lvngLineNo := lvngLineNo;
        lvngImportBufferError.lvngErrorNo := lvngErrorLineNo;
        lvngImportBufferError.lvngDescription := CopyStr(ErrorText, 1, MaxStrLen(lvngImportBufferError.lvngDescription));
        lvngImportBufferError.Insert();
    end;

    var
        lvngFileImportSchema: Record lvngFileImportSchema;
        lvngFileImportJnlLine: Record lvngFileImportJnlLine;
        lvngFileImportJnlLineTemp: Record lvngFileImportJnlLine temporary;
        CSVBufferTemp: Record "CSV Buffer" temporary;
        lvngDimensionsManagement: Codeunit lvngDimensionsManagement;
        lvngOpenFileLabel: Label 'Open File for Import';
        lvngErrorReadingToStreamLabel: Label 'Error reading file to stream';
        MainDimensionCode: Code[20];
        HierarchyDimensionsUsage: array[5] of boolean;
        MainDimensionNo: Integer;
        lvngImportStream: InStream;
        lvngFileName: Text;
        lvngImportToStream: Boolean;
}