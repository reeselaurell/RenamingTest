codeunit 14135115 "lvngGenJnlFileImportManagement"
{

    procedure CreateJournalLines(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; pGenJnlTemplate: Code[10]; pGenJnlBatch: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        DimensionManagement: Codeunit DimensionManagement;
        LineNo: Integer;
    begin
        GenJnlTemplate.get(pGenJnlTemplate);
        GenJnlLine.reset;
        GenJnlLine.SetRange("Journal Template Name", pGenJnlTemplate);
        GenJnlLine.SetRange("Journal Batch Name", pGenJnlBatch);
        if GenJnlLine.FindLast() then begin
            LineNo := GenJnlLine."Line No." + 100;
        end else begin
            LineNo := 100;
        end;
        lvngGenJnlImportBuffer.reset;
        lvngGenJnlImportBuffer.FindSet();
        repeat
            Clear(GenJnlLine);
            GenJnlLine.init;
            GenJnlLine.validate("Journal Template Name", pGenJnlTemplate);
            GenJnlLine.validate("Journal Batch Name", pGenJnlBatch);
            GenJnlLine."Line No." := LineNo;
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine.Insert();
            GenJnlLine."Account Type" := lvngGenJnlImportBuffer.lvngAccountType;
            GenJnlLine.validate("Account No.", lvngGenJnlImportBuffer.lvngAccountNo);
            if lvngGenJnlImportBuffer.lvngDescription <> '' then begin
                GenJnlLine.Description := lvngGenJnlImportBuffer.lvngDescription;
            end;
            GenJnlLine.validate("Document Type", lvngGenJnlImportBuffer.lvngDocumentType);
            GenJnlLine.validate("Document No.", lvngGenJnlImportBuffer.lvngDocumentNo);
            GenjnlLine.validate("External Document No.", lvngGenJnlImportBuffer.lvngExternalDocumentNo);
            GenJnlLine.validate("Document No.", lvngGenJnlImportBuffer.lvngDocumentNo);
            GenJnlLine.validate("Posting Date", lvngGenJnlImportBuffer.lvngPostingDate);
            GenJnlLine.validate("Document Date", lvngGenJnlImportBuffer.lvngDocumentDate);
            GenJnlLine.validate(Amount, lvngGenJnlImportBuffer.lvngAmount);
            GenJnlLine."Applies-to Doc. Type" := lvngGenJnlImportBuffer.lvngAppliesToDocType;
            GenJnlLine."Applies-to Doc. No." := lvngGenJnlImportBuffer.lvngAppliesToDocNo;
            GenJnlLine."Bal. Account Type" := lvngGenJnlImportBuffer.lvngBalAccountType;
            GenJnlLine.validate("Bal. Account No.", lvngGenJnlImportBuffer.lvngBalAccountNo);
            GenJnlLine."Bank Payment Type" := lvngGenJnlImportBuffer.lvngBankPaymentType;
            GenJnlLine.Comment := lvngGenJnlImportBuffer.lvngComment;
            GenJnlLine.validate("Depreciation Book Code", lvngGenJnlImportBuffer.lvngDepreciationBookCode);
            if lvngGenJnlImportBuffer.lvngDueDate <> 0D then
                GenJnlLine."Due Date" := lvngGenJnlImportBuffer.lvngDueDate;
            GenJnlLine."FA Posting Type" := lvngGenJnlImportBuffer.lvngFAPostingType;
            if lvngGenJnlImportBuffer.lvngPostingGroup <> '' then
                GenjnlLine.validate("Posting Group", lvngGenJnlImportBuffer.lvngPostingGroup);
            GenJnlLine."Recurring Frequency" := lvngGenJnlImportBuffer.lvngRecurringFrequency;
            GenJnlLine."Recurring Method" := lvngGenJnlImportBuffer.lvngRecurringMethod;
            GenJnlLine.lvngLoanNo := lvngGenJnlImportBuffer.lvngLoanNo;
            GenJnlLine.validate("Reason Code", lvngGenJnlImportBuffer.lvngReasonCode);
            GenJnlLine."Shortcut Dimension 1 Code" := lvngGenJnlImportBuffer.lvngGlobalDimension1Code;
            GenJnlLine."Shortcut Dimension 2 Code" := lvngGenJnlImportBuffer.lvngGlobalDimension2Code;
            GenJnlLine."Business Unit Code" := lvngGenJnlImportBuffer.lvngBusinessUnitCode;
            if lvngGenJnlImportBuffer.lvngGlobalDimension1Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(1, lvngGenJnlImportBuffer.lvngGlobalDimension1Code, GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngGlobalDimension2Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(2, lvngGenJnlImportBuffer.lvngGlobalDimension2Code, GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngShortcutDimension3Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(3, lvngGenJnlImportBuffer.lvngShortcutDimension3Code, GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngShortcutDimension4Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(4, lvngGenJnlImportBuffer.lvngShortcutDimension4Code, GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngShortcutDimension5Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(5, lvngGenJnlImportBuffer.lvngShortcutDimension5Code, GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngShortcutDimension6Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(6, lvngGenJnlImportBuffer.lvngShortcutDimension6Code, GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngShortcutDimension7Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(7, lvngGenJnlImportBuffer.lvngShortcutDimension7Code, GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer.lvngShortcutDimension8Code <> '' then
                DimensionManagement.ValidateShortcutDimValues(8, lvngGenJnlImportBuffer.lvngShortcutDimension8Code, GenJnlLine."Dimension Set ID");
            GenJnlLine.Modify();
            LineNo := LineNo + 100;
        until lvngGenJnlImportBuffer.Next() = 0;
    end;

    procedure ManualFileImport(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; var lvngImportBufferError: Record lvngImportBufferError): Boolean
    begin
        lvngFileImportSchema.reset;
        lvngFileImportSchema.SetRange("File Import Type", lvngFileImportSchema."File Import Type"::"General Journal");
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
        exit(False);
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
            lvngFileImportJnlLineTemp.SetFilter("Import Field Type", '<>%1', lvngFileImportJnlLine."Import Field Type"::Dummy);
            lvngFileImportJnlLineTemp.FindSet();
            repeat
                lvngValue := CSVBufferTemp.GetValue(lvngStartLine, lvngFileImportJnlLineTemp."Column No.");
                if lvngValue <> '' then begin
                    case lvngFileImportJnlLineTemp."Import Field Type" of
                        lvngFileImportJnlLineTemp."Import Field Type"::"Account No.":
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
                        lvngFileImportJnlLineTemp."Import Field Type"::"Account Type":
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngAccountType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::Amount:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngAmount, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Applies-To Doc. No.":
                            begin
                                lvngGenJnlImportBuffer.lvngAppliesToDocNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngAppliesToDocNo));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Applies-To Doc. Type":
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngAppliesToDocType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Bal. Account No.":
                            begin
                                lvngGenJnlImportBuffer.lvngBalAccountValue := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngBalAccountValue));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Bal. Account Type":
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngBalAccountType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Bank Payment Type":
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngBankPaymentType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Business Unit Code":
                            begin
                                lvngGenJnlImportBuffer.lvngBusinessUnitCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngBusinessUnitCode));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::Comment:
                            begin
                                lvngGenJnlImportBuffer.lvngComment := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngComment));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Depreciation Book Code":
                            begin
                                lvngGenJnlImportBuffer.lvngDepreciationBookCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngDepreciationBookCode));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::Description:
                            begin
                                lvngGenJnlImportBuffer.lvngDescription := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngDescription));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 1 Code":
                            begin
                                lvngGenJnlImportBuffer.lvngGlobalDimension1Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngGlobalDimension1Value));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 2 Code":
                            begin
                                lvngGenJnlImportBuffer.lvngGlobalDimension2Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngGlobalDimension2Value));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 3 Code":
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension3Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension3Value));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 4 Code":
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension4Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension4Value));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 5 Code":
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension5Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension5Value));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 6 Code":
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension6Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension6Value));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 7 Code":
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension7Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension7Value));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 8 Code":
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension8Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension8Value));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Document Date":
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngDocumentDate, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Document No.":
                            begin
                                lvngGenJnlImportBuffer.lvngDocumentNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngDocumentNo));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Document Type":
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngDocumentType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Due Date":
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngDueDate, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"External Document No.":
                            begin
                                lvngGenJnlImportBuffer.lvngExternalDocumentNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngExternalDocumentNo));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"FA Posting Type":
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngFAPostingType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Loan No.":
                            begin
                                lvngGenJnlImportBuffer.lvngLoanNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngLoanNo));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Payment Method Code":
                            begin
                                lvngGenJnlImportBuffer.lvngPaymentMethodCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngPaymentMethodCode));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Posting Date":
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngPostingDate, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Posting Group Code":
                            begin
                                lvngGenJnlImportBuffer.lvngPostingGroup := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngPostingGroup));
                            end;
                        lvngFileImportJnlLineTemp."Import Field Type"::"Reason Code":
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
        lvngPostingDateIsBlankLbl: Label 'Posting Date is Blank';
        lvngPostingDateIsNotValidLbl: Label '%1 Posting Date is not within allowed date ranges';
        lvngAccountNoBlankOrMissingLbl: Label 'Account %1 %2 is missing or blank';
        lvngBalAccountNoBlankOrMissingLbl: Label 'Bal. Account %1 %2 is missing or blank';
        lvngLoanNoNotFoundLbl: Label 'Loan No. %1 not found';
        lvngPostingGroupMissingLbl: Label '%1 %2 Posting Group is not available';
        lvngReasonCodeMissingLbl: Label '%1 Reason Code is not available';
        lvngPaymentMethodCodeMissingLbl: Label '%1 Payment Method Code is not available';
        lvngExternalDocNoAlreadyPostedLbl: Label 'Document with External Document No. %1 for Vendor %2 is already posted';
        lvngExternalDocNoIsBlankLbl: Label 'External Document No. can not be blank';
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        UserSetupMgmt: codeunit "User Setup Management";
        GLAccount: Record "G/L Account";
        DocumentNo: Code[20];
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
                if lvngFileImportSchema."Document Type Option" = lvngFileImportSchema."Document Type Option"::Predefined then begin
                    lvngGenJnlImportBuffer.lvngDocumentType := lvngFileImportSchema."Document Type";
                end;

                //Posting Date
                if lvngGenJnlImportBuffer.lvngPostingDate = 0D then begin
                    AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, lvngPostingDateIsBlankLbl);
                end else begin
                    if not UserSetupMgmt.IsPostingDateValid(lvngGenJnlImportBuffer.lvngPostingDate) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, strsubstno(lvngPostingDateIsNotValidLbl, lvngGenJnlImportBuffer.lvngPostingDate));
                    end;
                end;
                if lvngGenJnlImportBuffer.lvngDocumentDate = 0D then begin
                    lvngGenJnlImportBuffer.lvngDocumentDate := lvngGenJnlImportBuffer.lvngPostingDate;
                end;

                //Account Type and Account No.
                FindAccountNo(lvngGenJnlImportBuffer.lvngAccountType, lvngGenJnlImportBuffer.lvngAccountValue, lvngGenJnlImportBuffer.lvngAccountNo);
                if lvngFileImportSchema."Default Account No." <> '' then begin
                    lvngGenJnlImportBuffer.lvngAccountType := lvngFileImportSchema."Gen. Jnl. Account Type";
                    lvngGenJnlImportBuffer.lvngAccountNo := lvngFileImportSchema."Default Account No.";
                end;
                if lvngGenJnlImportBuffer.lvngAccountNo = '' then begin
                    AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngAccountNoBlankOrMissingLbl, lvngGenJnlImportBuffer.lvngAccountType, lvngGenJnlImportBuffer.lvngAccountValue));
                end else begin
                    if lvngFileImportSchema."Subs. G/L With Bank Acc." then begin
                        if GLAccount.Get(lvngGenJnlImportBuffer.lvngAccountNo) then begin
                            lvngGenJnlImportBuffer.lvngAccountType := lvngGenJnlImportBuffer.lvngAccountType::"Bank Account";
                            lvngGenJnlImportBuffer.lvngAccountNo := GLAccount.lvngLinkedBankAccountNo;
                        end;
                    end;
                end;


                //Bal. Account Type and Bal. Account No.
                if lvngFileImportSchema."Default Bal. Account No." <> '' then begin
                    lvngGenJnlImportBuffer.lvngBalAccountType := lvngFileImportSchema."Gen. Jnl. Bal. Account Type";
                    lvngGenJnlImportBuffer.lvngBalAccountNo := lvngFileImportSchema."Default Bal. Account No.";
                end else begin
                    if lvngGenJnlImportBuffer.lvngBalAccountValue <> '' then begin
                        FindAccountNo(lvngGenJnlImportBuffer.lvngBalAccountType, lvngGenJnlImportBuffer.lvngBalAccountValue, lvngGenJnlImportBuffer.lvngBalAccountNo);
                        if lvngGenJnlImportBuffer.lvngBalAccountNo = '' then begin
                            AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngBalAccountNoBlankOrMissingLbl, lvngGenJnlImportBuffer.lvngBalAccountType, lvngGenJnlImportBuffer.lvngBalAccountValue));
                        end;
                    end;
                end;

                //Loan No.
                if lvngGenJnlImportBuffer.lvngLoanNo <> '' then begin
                    if not CheckLoanNo(lvngGenJnlImportBuffer.lvngLoanNo) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngLoanNoNotFoundLbl, lvngGenJnlImportBuffer.lvngLoanNo));
                    end;
                    if lvngGenJnlImportBuffer.lvngLoanNo <> '' then begin
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
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 1 Mandatory", 1, lvngGenJnlImportBuffer.lvngGlobalDimension1Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 2 Mandatory", 2, lvngGenJnlImportBuffer.lvngGlobalDimension2Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 3 Mandatory", 3, lvngGenJnlImportBuffer.lvngShortcutDimension3Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 4 Mandatory", 4, lvngGenJnlImportBuffer.lvngShortcutDimension4Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 5 Mandatory", 5, lvngGenJnlImportBuffer.lvngShortcutDimension5Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 6 Mandatory", 6, lvngGenJnlImportBuffer.lvngShortcutDimension6Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 7 Mandatory", 7, lvngGenJnlImportBuffer.lvngShortcutDimension7Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema."Dimension 8 Mandatory", 8, lvngGenJnlImportBuffer.lvngShortcutDimension8Code, lvngImportBufferError);

                //External Document No.
                if (lvngGenJnlImportBuffer.lvngDocumentType in [lvngGenJnlImportBuffer.lvngDocumentType::"Credit Memo", lvngGenJnlImportBuffer.lvngDocumentType::Invoice]) and
                    (lvngGenJnlImportBuffer.lvngAccountType = lvngGenJnlImportBuffer.lvngAccountType::Vendor) then begin
                    if lvngGenJnlImportBuffer.lvngExternalDocumentNo = '' then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, lvngExternalDocNoIsBlankLbl);
                    end else begin
                        if not CheckVendorExternalDocumentNo(lvngGenJnlImportBuffer) then begin
                            AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngExternalDocNoAlreadyPostedLbl, lvngGenJnlImportBuffer.lvngExternalDocumentNo, lvngGenJnlImportBuffer.lvngAccountNo));
                        end;
                    end;
                end;

                //Posting Group
                if lvngGenJnlImportBuffer.lvngPostingGroup = '' then begin
                    lvngGenJnlImportBuffer.lvngPostingGroup := lvngFileImportSchema."Posting Group";
                end;
                if lvngGenJnlImportBuffer.lvngPostingGroup <> '' then begin
                    if not CheckPostingGroup(lvngGenJnlImportBuffer) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, strsubstno(lvngPostingGroupMissingLbl, lvngGenJnlImportBuffer.lvngAccountType, lvngGenJnlImportBuffer.lvngPostingGroup));
                    end;
                end;

                //Reason Code
                if lvngGenJnlImportBuffer.lvngReasonCode = '' then begin
                    lvngGenJnlImportBuffer.lvngReasonCode := lvngFileImportSchema."Reason Code";
                end;
                if lvngGenJnlImportBuffer.lvngReasonCode <> '' then begin
                    if not CheckReasonCode(lvngGenJnlImportBuffer) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, strsubstno(lvngReasonCodeMissingLbl, lvngGenJnlImportBuffer.lvngReasonCode));
                    end;
                end;

                //Payment Method Code
                if lvngGenJnlImportBuffer.lvngPaymentMethodCode <> '' then begin
                    if not CheckPaymentMethodCode(lvngGenJnlImportBuffer) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, strsubstno(lvngPaymentMethodCodeMissingLbl, lvngGenJnlImportBuffer.lvngPaymentMethodCode));
                    end;
                end;

                //Bank Payment Type
                if lvngGenJnlImportBuffer.lvngBankPaymentType = lvngGenJnlImportBuffer.lvngBankPaymentType::" " then begin
                    lvngGenJnlImportBuffer.lvngBankPaymentType := lvngFileImportSchema."Bank Payment Type";
                end;

                //Recurring Frequence
                if format(lvngGenJnlImportBuffer.lvngRecurringFrequency) = '' then
                    lvngGenJnlImportBuffer.lvngRecurringFrequency := lvngFileImportSchema."Recurring Frequency";

                //Recurring Method
                if lvngGenJnlImportBuffer.lvngRecurringMethod = lvngGenJnlImportBuffer.lvngRecurringMethod::" " then begin
                    lvngGenJnlImportBuffer.lvngRecurringMethod := lvngFileImportSchema."Recurring Method";
                end;

                //Document No.
                if lvngFileImportSchema."Document No. Filling" = lvngFileImportSchema."Document No. Filling"::"Sames As Loan No." then begin
                    lvngGenJnlImportBuffer.lvngDocumentNo := lvngGenJnlImportBuffer.lvngLoanNo;
                end;

                if lvngFileImportSchema."Document No. Filling" = lvngFileImportSchema."Document No. Filling"::"Defined In File" then begin
                    if lvngGenJnlImportBuffer.lvngDocumentNo <> '' then begin
                        if lvngFileImportSchema."Document No. Prefix" <> '' then begin
                            lvngGenJnlImportBuffer.lvngDocumentNo := lvngFileImportSchema."Document No. Prefix" + lvngGenJnlImportBuffer.lvngDocumentNo;
                        end;
                    end;
                end;

                if lvngFileImportSchema."Document No. Filling" = lvngFileImportSchema."Document No. Filling"::"From Schema No. Series" then begin
                    if lvngFileImportSchema."Use Single Document No." then begin
                        if DocumentNo = '' then
                            DocumentNo := NoSeriesMgmt.GetNextNo(lvngFileImportSchema."Document No. Series", today, true);
                    end else begin
                        DocumentNo := NoSeriesMgmt.GetNextNo(lvngFileImportSchema."Document No. Series", today, true);
                    end;
                    lvngGenJnlImportBuffer.lvngDocumentNo := DocumentNo;
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
                        DimensionValue.SetRange(lvngAdditionalCode, copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.lvngAdditionalCode)));
                    end;
            end;
            if DimensionValue.FindFirst() then
                DimensionValueCode := DimensionValue.Code;
        end;
    end;

    local procedure CheckVendorExternalDocumentNo(lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        VendorMgt: codeunit "Vendor Mgt.";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        Clear(VendorMgt);
        VendorMgt.SetFilterForExternalDocNo(VendorLedgerEntry, lvngGenJnlImportBuffer.lvngDocumentType, lvngGenJnlImportBuffer.lvngExternalDocumentNo, lvngGenJnlImportBuffer.lvngAccountNo, lvngGenJnlImportBuffer.lvngPostingDate);
        if not VendorLedgerEntry.IsEmpty() then
            exit(false);
        exit(true);
    end;



    local procedure CheckPaymentMethodCode(lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        PaymentMethod: record "Payment MEthod";
    begin
        if not PaymentMethod.Get(lvngGenJnlImportBuffer.lvngPaymentMethodCode) then
            exit(false);
        exit(True);
    end;

    local procedure CheckReasonCode(lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        ReasonCode: record "Reason Code";
    begin
        if not ReasonCode.Get(lvngGenJnlImportBuffer.lvngReasonCode) then
            exit(false);
        exit(True);
    end;

    local procedure CheckPostingGroup(lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        VendorPostingGroup: Record "Vendor Posting Group";
        CustomerPostingGroup: Record "Customer Posting Group";
        FAPostingGroup: Record "FA Posting Group";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
    begin
        case lvngGenJnlImportBuffer.lvngAccountType of
            lvnggenjnlimportbuffer.lvngAccountType::"Bank Account":
                begin
                    if not BankAccountPostingGroup.Get(lvngGenJnlImportBuffer.lvngPostingGroup) then
                        exit(false)
                end;
            lvnggenjnlimportbuffer.lvngAccountType::"Fixed Asset":
                begin
                    if not FAPostingGroup.Get(lvngGenJnlImportBuffer.lvngPostingGroup) then
                        exit(false)
                end;
            lvnggenjnlimportbuffer.lvngAccountType::"Vendor":
                begin
                    if not VendorPostingGroup.Get(lvngGenJnlImportBuffer.lvngPostingGroup) then
                        exit(false)
                end;
            lvnggenjnlimportbuffer.lvngAccountType::"Customer":
                begin
                    if not CustomerPostingGroup.Get(lvngGenJnlImportBuffer.lvngPostingGroup) then
                        exit(false)
                end;
        end;
        exit(true);
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
            lvngFileImportJnlLineTemp.SetRange("Import Field Type", lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 1 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngGlobalDimension1Code := lvngLoan."Global Dimension 1 Code";

            lvngFileImportJnlLineTemp.SetRange("Import Field Type", lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 2 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngGlobalDimension2Code := lvngLoan."Global Dimension 2 Code";

            lvngFileImportJnlLineTemp.SetRange("Import Field Type", lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 3 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension3Code := lvngLoan."Shortcut Dimension 3 Code";

            lvngFileImportJnlLineTemp.SetRange("Import Field Type", lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 4 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension4Code := lvngLoan."Shortcut Dimension 4 Code";

            lvngFileImportJnlLineTemp.SetRange("Import Field Type", lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 5 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension5Code := lvngLoan."Shortcut Dimension 5 Code";

            lvngFileImportJnlLineTemp.SetRange("Import Field Type", lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 6 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension6Code := lvngLoan."Shortcut Dimension 6 Code";

            lvngFileImportJnlLineTemp.SetRange("Import Field Type", lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 7 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension7Code := lvngLoan."Shortcut Dimension 7 Code";

            lvngFileImportJnlLineTemp.SetRange("Import Field Type", lvngFileImportJnlLineTemp."Import Field Type"::"Dimension 8 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension8Code := lvngLoan."Shortcut Dimension 8 Code";
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

    local procedure FindAccountNo(lvngGenJnlAccountType: enum lvngGenJnlAccountType; lvngValue: Text; var lvngAccountNo: Code[20])
    var
        GLAccount: Record "G/L Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        FixedAsset: Record "Fixed Asset";
        BankAccount: Record "Bank Account";
        ICPartner: Record "IC Partner";
    begin
        //Account Type and Account No.
        case lvngFileImportSchema."Account Mapping Type" of
            lvngFileImportSchema."Account Mapping Type"::Name:
                begin
                    case lvngGenJnlAccountType of
                        lvngGenJnlAccountType::"G/L Account":
                            begin
                                GLAccount.reset;
                                GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                GLAccount.SetFilter(Name, '@' + lvngValue);
                                if GLAccount.FindFirst() then begin
                                    lvngAccountNo := GLAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Bank Account":
                            begin
                                BankAccount.reset;
                                BankAccount.SetFilter(Name, '@' + lvngValue);
                                if BankAccount.FindFirst() then begin
                                    lvngAccountNo := BankAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Customer:
                            begin
                                Customer.reset;
                                Customer.SetFilter(Name, '@' + lvngValue);
                                if Customer.FindFirst() then begin
                                    lvngAccountNo := Customer."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Vendor:
                            begin
                                Vendor.reset;
                                Vendor.SetFilter(Name, '@' + lvngValue);
                                if Vendor.FindFirst() then begin
                                    lvngAccountNo := Vendor."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Fixed Asset":
                            begin
                                FixedAsset.reset;
                                FixedAsset.SetFilter(Description, '@' + lvngValue);
                                if FixedAsset.FindFirst() then begin
                                    lvngAccountNo := FixedAsset."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"IC Partner":
                            begin
                                ICPartner.reset;
                                ICPartner.SetFilter(Name, '@' + lvngValue);
                                if ICPartner.FindFirst() then begin
                                    lvngAccountNo := ICPartner.Code;
                                end;
                            end;
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::"No.":
                begin
                    case lvngGenJnlAccountType of
                        lvngGenJnlAccountType::"G/L Account":
                            begin
                                GLAccount.reset;
                                GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                GLAccount.SetRange("No.", lvngValue);
                                if GLAccount.FindFirst() then begin
                                    lvngAccountNo := GLAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Bank Account":
                            begin
                                BankAccount.reset;
                                BankAccount.SetRange("No.", lvngValue);
                                if BankAccount.FindFirst() then begin
                                    lvngAccountNo := BankAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Customer:
                            begin
                                Customer.reset;
                                Customer.SetRange("No.", lvngValue);
                                if Customer.FindFirst() then begin
                                    lvngAccountNo := Customer."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Vendor:
                            begin
                                Vendor.reset;
                                Vendor.SetRange("No.", lvngValue);
                                if Vendor.FindFirst() then begin
                                    lvngAccountNo := Vendor."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Fixed Asset":
                            begin
                                FixedAsset.reset;
                                FixedAsset.SetRange("No.", lvngValue);
                                if FixedAsset.FindFirst() then begin
                                    lvngAccountNo := FixedAsset."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"IC Partner":
                            begin
                                ICPartner.reset;
                                ICPartner.SetRange(Code, lvngValue);
                                if ICPartner.FindFirst() then begin
                                    lvngAccountNo := ICPartner.Code;
                                end;
                            end;
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::"No. 2":
                begin
                    case lvngGenJnlAccountType of
                        lvngGenJnlAccountType::"G/L Account":
                            begin
                                GLAccount.reset;
                                GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                GLAccount.SetRange("No. 2", lvngValue);
                                if GLAccount.FindFirst() then begin
                                    lvngAccountNo := GLAccount."No.";
                                end;
                            end;
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::"Search Name":
                begin
                    case lvngGenJnlAccountType of
                        lvngGenJnlAccountType::"G/L Account":
                            begin
                                GLAccount.reset;
                                GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                GLAccount.SetRange("Search Name", lvngValue);
                                if GLAccount.FindFirst() then begin
                                    lvngAccountNo := GLAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Bank Account":
                            begin
                                BankAccount.reset;
                                BankAccount.SetRange("Search Name", lvngValue);
                                if BankAccount.FindFirst() then begin
                                    lvngAccountNo := BankAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Customer:
                            begin
                                Customer.reset;
                                Customer.SetRange("Search Name", lvngValue);
                                if Customer.FindFirst() then begin
                                    lvngAccountNo := Customer."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Vendor:
                            begin
                                Vendor.reset;
                                Vendor.SetRange("Search Name", lvngValue);
                                if Vendor.FindFirst() then begin
                                    lvngAccountNo := Vendor."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Fixed Asset":
                            begin
                                FixedAsset.reset;
                                FixedAsset.SetFilter(Description, '@' + lvngValue);
                                if FixedAsset.FindFirst() then begin
                                    lvngAccountNo := FixedAsset."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"IC Partner":
                            begin
                                ICPartner.reset;
                                ICPartner.SetFilter(Name, '@' + lvngValue);
                                if ICPartner.FindFirst() then begin
                                    lvngAccountNo := ICPartner.Code;
                                end;
                            end;
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