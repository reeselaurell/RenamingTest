codeunit 14135117 "lvngSalesFileImportManagement"
{
    procedure CreateSalesLines(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; lvngDocumentType: enum lvngLoanDocumentType; lvngDocumentNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        DimensionManagement: Codeunit DimensionManagement;
        LineNo: Integer;
    begin
        if lvngDocumentType = lvngDocumentType::"Credit Memo" then begin
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
            SalesLine.Validate("No.", lvngGenJnlImportBuffer."Account No.");
            if lvngGenJnlImportBuffer.Description <> '' then begin
                SalesLine.Description := lvngGenJnlImportBuffer.Description;
            end;
            SalesLine.Validate(Quantity, 1);
            SalesLine.Validate("Unit Price", lvngGenJnlImportBuffer.Amount);
            if lvngGenJnlImportBuffer."Reason Code" <> '' then begin
                SalesLine.Validate("Reason Code", lvngGenJnlImportBuffer."Reason Code");
            end;
            SalesLine."Loan No." := lvngGenJnlImportBuffer."Loan No.";
            if lvngGenJnlImportBuffer."Shortcut Dimension 4 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(4, lvngGenJnlImportBuffer."Shortcut Dimension 4 Code", SalesLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Shortcut Dimension 3 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(3, lvngGenJnlImportBuffer."Shortcut Dimension 3 Code", SalesLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Global Dimension 2 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(2, lvngGenJnlImportBuffer."Global Dimension 2 Code", SalesLine."Dimension Set ID");
            SalesLine."Shortcut Dimension 2 Code" := lvngGenJnlImportBuffer."Global Dimension 2 Code";
            if lvngGenJnlImportBuffer."Global Dimension 1 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(1, lvngGenJnlImportBuffer."Global Dimension 1 Code", SalesLine."Dimension Set ID");
            SalesLine."Shortcut Dimension 1 Code" := lvngGenJnlImportBuffer."Global Dimension 1 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 5 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(5, lvngGenJnlImportBuffer."Shortcut Dimension 5 Code", SalesLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Shortcut Dimension 6 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(6, lvngGenJnlImportBuffer."Shortcut Dimension 6 Code", SalesLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Shortcut Dimension 7 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(7, lvngGenJnlImportBuffer."Shortcut Dimension 7 Code", SalesLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Shortcut Dimension 8 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(8, lvngGenJnlImportBuffer."Shortcut Dimension 8 Code", SalesLine."Dimension Set ID");
            SalesLine.Modify();
            LineNo := LineNo + 100;
        until lvngGenJnlImportBuffer.Next() = 0;
    end;

    procedure ManualFileImport(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; var lvngImportBufferError: Record lvngImportBufferError): Boolean
    begin
        lvngFileImportSchema.reset;
        lvngFileImportSchema.SetRange("File Import Type", lvngFileImportSchema."File Import Type"::"Sales Line");
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
            lvngGenJnlImportBuffer."Line No." := lvngStartLine;
            lvngGenJnlImportBuffer.Insert(true);
            lvngFileImportJnlLineTemp.reset;
            lvngFileImportJnlLineTemp.SetRange(Code, lvngFileImportSchema.Code);
            lvngFileImportJnlLineTemp.SetFilter("Sales Import Field Type", '<>%1', lvngFileImportJnlLine."Sales Import Field Type"::Dummy);
            lvngFileImportJnlLineTemp.FindSet();
            repeat
                lvngValue := CSVBufferTemp.GetValue(lvngStartLine, lvngFileImportJnlLineTemp."Column No.");
                if lvngValue <> '' then begin
                    case lvngFileImportJnlLineTemp."Sales Import Field Type" of
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Account No.":
                            begin
                                lvngGenJnlImportBuffer."Account Value" := copystr(lvngValue, 1, maxstrlen(lvngGenJnlImportBuffer."Account Value"));
                                if lvngFileImportJnlLineTemp."Dimension Split" then begin
                                    IF lvngFileImportJnlLineTemp."Dimension Split Character" <> '' THEN BEGIN
                                        Pos := STRPOS(lvngValue, lvngFileImportJnlLineTemp."Dimension Split Character");
                                        IF Pos <> 0 THEN BEGIN
                                            lvngValue2 := COPYSTR(lvngValue, Pos + 1);
                                            lvngValue := COPYSTR(lvngValue, 1, Pos - 1);
                                            lvngGenJnlImportBuffer."Account Value" := copystr(lvngValue, 1, maxstrlen(lvngGenJnlImportBuffer."Account Value"));
                                            case lvngFileImportJnlLineTemp."Split Dimension No." of
                                                1:
                                                    lvngGenJnlImportBuffer."Global Dimension 1 Value" := lvngValue2;
                                                2:
                                                    lvngGenJnlImportBuffer."Global Dimension 2 Value" := lvngValue2;
                                                3:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 3 Value" := lvngValue2;
                                                4:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 4 Value" := lvngValue2;
                                                5:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 5 Value" := lvngValue2;
                                                6:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 6 Value" := lvngValue2;
                                                7:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 7 Value" := lvngValue2;
                                                8:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 8 Value" := lvngValue2;
                                            end;
                                        END;
                                    END;
                                end;
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::Amount:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.Amount, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::Description:
                            begin
                                lvngGenJnlImportBuffer.Description := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.Description));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 1 Code":
                            begin
                                lvngGenJnlImportBuffer."Global Dimension 1 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Global Dimension 1 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 2 Code":
                            begin
                                lvngGenJnlImportBuffer."Global Dimension 2 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Global Dimension 2 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 3 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 3 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 3 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 4 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 4 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 4 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 5 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 5 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 5 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 6 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 6 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 6 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 7 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 7 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 7 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 8 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 8 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 8 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Loan No.":
                            begin
                                lvngGenJnlImportBuffer."Loan No." := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Loan No."));
                            end;
                        lvngFileImportJnlLineTemp."Sales Import Field Type"::"Reason Code":
                            begin
                                lvngGenJnlImportBuffer."Reason Code" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Reason Code"));
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
                    lvngGenJnlImportBuffer.Amount := -lvngGenJnlImportBuffer.Amount;
                end;
                //Document Type
                if lvngFileImportSchema."Document Type Option" = lvngFileImportSchema."Document Type Option"::Predefined then begin
                    lvngGenJnlImportBuffer."Document Type" := lvngFileImportSchema."Document Type";
                end;

                //Account Type and Account No.
                FindAccountNo(lvngGenJnlImportBuffer."Account Value", lvngGenJnlImportBuffer."Account No.");
                if lvngFileImportSchema."Default Account No." <> '' then begin
                    lvngGenJnlImportBuffer."Account Type" := lvngFileImportSchema."Gen. Jnl. Account Type"::"G/L Account";
                    lvngGenJnlImportBuffer."Account No." := lvngFileImportSchema."Default Account No.";
                end;
                if lvngGenJnlImportBuffer."Account No." = '' then begin
                    AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngAccountNoBlankOrMissingLbl, lvngGenJnlImportBuffer."Account Type", lvngGenJnlImportBuffer."Account Value"));
                end;

                //Loan No.
                if lvngGenJnlImportBuffer."Loan No." <> '' then begin
                    if not CheckLoanNo(lvngGenJnlImportBuffer."Loan No.") then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngLoanNoNotFoundLbl, lvngGenJnlImportBuffer."Loan No."));
                    end;
                    if lvngGenJnlImportBuffer."Loan No." <> '' then begin
                        if lvngFileImportSchema."Dimension Validation Rule" = lvngFileImportSchema."Dimension Validation Rule"::"All Loan Dimensions" then begin
                            AssignLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                        if lvngFileImportSchema."Dimension Validation Rule" = lvngFileImportSchema."Dimension Validation Rule"::"Empty Dimensions" then begin
                            AssignEmptyLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                        if lvngFileImportSchema."Dimension Validation Rule" = lvngFileImportSchema."Dimension Validation Rule"::"Loan & Exclude Imported Dimensions" then begin
                            AssignNotImportedLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                    end;
                end;

                //Dimensions
                AssignDimensions(lvngGenJnlImportBuffer);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 1 Mandatory", 1, lvngGenJnlImportBuffer."Global Dimension 1 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 2 Mandatory", 2, lvngGenJnlImportBuffer."Global Dimension 2 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 3 Mandatory", 3, lvngGenJnlImportBuffer."Shortcut Dimension 3 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 4 Mandatory", 4, lvngGenJnlImportBuffer."Shortcut Dimension 4 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 5 Mandatory", 5, lvngGenJnlImportBuffer."Shortcut Dimension 5 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 6 Mandatory", 6, lvngGenJnlImportBuffer."Shortcut Dimension 6 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 7 Mandatory", 7, lvngGenJnlImportBuffer."Shortcut Dimension 7 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 8 Mandatory", 8, lvngGenJnlImportBuffer."Shortcut Dimension 8 Code", lvngImportBufferError);

                //Reason Code
                if lvngGenJnlImportBuffer."Reason Code" = '' then begin
                    lvngGenJnlImportBuffer."Reason Code" := lvngFileImportSchema."Reason Code";
                end;
                if lvngGenJnlImportBuffer."Reason Code" <> '' then begin
                    if not CheckReasonCode(lvngGenJnlImportBuffer) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, strsubstno(lvngReasonCodeMissingLbl, lvngGenJnlImportBuffer."Reason Code"));
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
        SearchDimension(1, lvngFileImportSchema."Dimension 1 Mapping Type", lvngGenJnlImportBuffer."Global Dimension 1 Value", lvngGenJnlImportBuffer."Global Dimension 1 Code");
        SearchDimension(2, lvngFileImportSchema."Dimension 2 Mapping Type", lvngGenJnlImportBuffer."Global Dimension 2 Value", lvngGenJnlImportBuffer."Global Dimension 2 Code");
        SearchDimension(3, lvngFileImportSchema."Dimension 3 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 3 Value", lvngGenJnlImportBuffer."Shortcut Dimension 3 Code");
        SearchDimension(4, lvngFileImportSchema."Dimension 4 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 4 Value", lvngGenJnlImportBuffer."Shortcut Dimension 4 Code");
        SearchDimension(5, lvngFileImportSchema."Dimension 5 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 5 Value", lvngGenJnlImportBuffer."Shortcut Dimension 5 Code");
        SearchDimension(6, lvngFileImportSchema."Dimension 6 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 6 Value", lvngGenJnlImportBuffer."Shortcut Dimension 6 Code");
        SearchDimension(7, lvngFileImportSchema."Dimension 7 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 7 Value", lvngGenJnlImportBuffer."Shortcut Dimension 7 Code");
        SearchDimension(8, lvngFileImportSchema."Dimension 8 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 8 Value", lvngGenJnlImportBuffer."Shortcut Dimension 8 Code");
        case MainDimensionNo of
            1:
                DimensionCode := lvngGenJnlImportBuffer."Global Dimension 1 Code";
            2:
                DimensionCode := lvngGenJnlImportBuffer."Global Dimension 2 Code";
            3:
                DimensionCode := lvngGenJnlImportBuffer."Shortcut Dimension 3 Code";
            4:
                DimensionCode := lvngGenJnlImportBuffer."Shortcut Dimension 4 Code";
        end;
        lvngDimensionHierarchy.reset;
        lvngDimensionHierarchy.Ascending(false);
        lvngDimensionHierarchy.SetFilter(Date, '..%1', lvngGenJnlImportBuffer."Posting Date");
        lvngDimensionHierarchy.SetRange(Code, DimensionCode);
        if lvngDimensionHierarchy.FindFirst() then begin
            if HierarchyDimensionsUsage[1] then
                lvngGenJnlImportBuffer."Global Dimension 1 Code" := lvngDimensionHierarchy."Global Dimension 1 Code";
            if HierarchyDimensionsUsage[2] then
                lvngGenJnlImportBuffer."Global Dimension 2 Code" := lvngDimensionHierarchy."Global Dimension 2 Code";
            if HierarchyDimensionsUsage[3] then
                lvngGenJnlImportBuffer."Shortcut Dimension 3 Code" := lvngDimensionHierarchy."Shortcut Dimension 3 Code";
            if HierarchyDimensionsUsage[4] then
                lvngGenJnlImportBuffer."Shortcut Dimension 4 Code" := lvngDimensionHierarchy."Shortcut Dimension 4 Code";
            if HierarchyDimensionsUsage[5] then
                lvngGenJnlImportBuffer."Business Unit Code" := lvngDimensionHierarchy."Business Unit Code";
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
                lvngDimensionMappingType::Code:
                    begin
                        DimensionValue.SetRange(Code, copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.Code)));
                    end;
                lvngDimensionMappingType::Name:
                    begin
                        DimensionValue.SetFilter(Name, copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.Name)));
                    end;
                lvngDimensionMappingType::"Search Name":
                    begin
                        DimensionValue.Setrange(Name, '@' + copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.Name)));
                    end;
                lvngDimensionMappingType::"Additional Code":
                    begin
                        DimensionValue.SetRange("Additional Code", copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue."Additional Code")));
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
        if not ReasonCode.Get(lvngGenJnlImportBuffer."Reason Code") then
            exit(false);
        exit(True);
    end;

    local procedure AssignLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer."Loan No.") then begin
            lvngGenJnlImportBuffer."Global Dimension 1 Code" := lvngLoan."Global Dimension 1 Code";
            lvngGenJnlImportBuffer."Global Dimension 2 Code" := lvngLoan."Global Dimension 2 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 3 Code" := lvngLoan."Shortcut Dimension 3 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 4 Code" := lvngLoan."Shortcut Dimension 4 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 5 Code" := lvngLoan."Shortcut Dimension 5 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 6 Code" := lvngLoan."Shortcut Dimension 6 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 7 Code" := lvngLoan."Shortcut Dimension 7 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 8 Code" := lvngLoan."Shortcut Dimension 8 Code";
            lvngGenJnlImportBuffer."Business Unit Code" := lvngLoan."Business Unit Code";
        end;
    end;

    local procedure AssignEmptyLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer."Loan No.") then begin
            if lvngGenJnlImportBuffer."Global Dimension 1 Value" = '' then
                lvngGenJnlImportBuffer."Global Dimension 1 Code" := lvngLoan."Global Dimension 1 Code";
            if lvngGenJnlImportBuffer."Global Dimension 2 Value" = '' then
                lvngGenJnlImportBuffer."Global Dimension 2 Code" := lvngLoan."Global Dimension 2 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 3 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 3 Code" := lvngLoan."Shortcut Dimension 3 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 4 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 4 Code" := lvngLoan."Shortcut Dimension 4 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 5 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 5 Code" := lvngLoan."Shortcut Dimension 5 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 6 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 6 Code" := lvngLoan."Shortcut Dimension 6 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 7 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 7 Code" := lvngLoan."Shortcut Dimension 7 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 8 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 8 Code" := lvngLoan."Shortcut Dimension 8 Code";
            if lvngGenJnlImportBuffer."Business Unit Code" = '' then
                lvngGenJnlImportBuffer."Business Unit Code" := lvngLoan."Business Unit Code";
        end;
    end;

    local procedure AssignNotImportedLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer."Loan No.") then begin
            lvngFileImportJnlLineTemp.reset;
            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 1 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Global Dimension 1 Code" := lvngLoan."Global Dimension 1 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 2 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Global Dimension 2 Code" := lvngLoan."Global Dimension 2 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 3 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 3 Code" := lvngLoan."Shortcut Dimension 3 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 4 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 4 Code" := lvngLoan."Shortcut Dimension 4 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 5 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 5 Code" := lvngLoan."Shortcut Dimension 5 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 6 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 6 Code" := lvngLoan."Shortcut Dimension 6 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 7 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 7 Code" := lvngLoan."Shortcut Dimension 7 Code";

            lvngFileImportJnlLineTemp.SetRange("Sales Import Field Type", lvngFileImportJnlLineTemp."Sales Import Field Type"::"Dimension 8 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 8 Code" := lvngLoan."Shortcut Dimension 8 Code";
        end;
    end;

    local procedure CheckLoanNo(var lvngLoanNo: Code[20]): Boolean
    var
        lvngLoan: Record lvngLoan;
    begin
        case lvngFileImportSchema."Loan No. Validation Rule" of
            lvngFileImportSchema."Loan No. Validation Rule"::"Blank If Not Found":
                begin
                    if not lvngLoan.Get(lvngLoanNo) then begin
                        Clear(lvngLoanNo);
                        exit(true);
                    end;
                end;
            lvngFileImportSchema."Loan No. Validation Rule"::Validate:
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
            lvngFileImportSchema."Account Mapping Type"::Name:
                begin
                    GLAccount.reset;
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.SetFilter(Name, '@' + lvngValue);
                    if GLAccount.FindFirst() then begin
                        lvngAccountNo := GLAccount."No.";
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::"No.":
                begin
                    GLAccount.reset;
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.SetRange("No.", lvngValue);
                    if GLAccount.FindFirst() then begin
                        lvngAccountNo := GLAccount."No.";
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::"No. 2":
                begin
                    GLAccount.reset;
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.SetRange("No. 2", lvngValue);
                    if GLAccount.FindFirst() then begin
                        lvngAccountNo := GLAccount."No.";
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::"Search Name":
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
        lvngImportBufferError.SetRange("Line No.", lvngGenJnlImportBuffer."Line No.");
        if lvngImportBufferError.FindLast() then begin
            lvngErrorLineNo := lvngImportBufferError."Error No." + 100;
        end else begin
            lvngErrorLineNo := 100;
        end;
        Clear(lvngImportBufferError);
        lvngImportBufferError."Line No." := lvngGenJnlImportBuffer."Line No.";
        lvngImportBufferError."Error No." := lvngErrorLineNo;
        lvngImportBufferError.Description := CopyStr(ErrorText, 1, MaxStrLen(lvngImportBufferError.Description));
        lvngImportBufferError.Insert();
    end;

    local procedure AddErrorLine(lvngLineNo: Integer; var lvngImportBufferError: Record lvngImportBufferError; ErrorText: Text)
    var
        lvngErrorLineNo: Integer;
    begin
        lvngImportBufferError.reset;
        lvngImportBufferError.SetRange("Line No.", lvngLineNo);
        if lvngImportBufferError.FindLast() then begin
            lvngErrorLineNo := lvngImportBufferError."Error No." + 100;
        end else begin
            lvngErrorLineNo := 100;
        end;
        Clear(lvngImportBufferError);
        lvngImportBufferError."Line No." := lvngLineNo;
        lvngImportBufferError."Error No." := lvngErrorLineNo;
        lvngImportBufferError.Description := CopyStr(ErrorText, 1, MaxStrLen(lvngImportBufferError.Description));
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