codeunit 14135115 "lvngGenJnlFileImportManagement"
{

    procedure ManualFileImport(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; var lvngImportBufferError: Record lvngImportBufferError)
    begin
        lvngFileImportSchema.reset;
        lvngFileImportSchema.SetRange(lvngFileImportType, lvngFileImportSchema.lvngFileImportType::lvngGeneralJournal);
        if page.RunModal(0, lvngFileImportSchema) = Action::LookupOK then begin
            lvngGenJnlImportBuffer.reset;
            lvngGenJnlImportBuffer.DeleteAll();
            lvngFileImportSchema.Get(lvngFileImportSchema.lvngCode);
            lvngFileImportJnlLine.Reset();
            lvngFileImportJnlLine.SetRange(lvngCode, lvngFileImportSchema.lvngCode);
            lvngFileImportJnlLine.FindSet();
            repeat
                Clear(lvngFileImportJnlLineTemp);
                lvngFileImportJnlLineTemp := lvngFileImportJnlLine;
                lvngFileImportJnlLineTemp.Insert();
            until lvngFileImportJnlLine.Next() = 0;
            ReadCSVStream();
            ProcessImportCSVBuffer(lvngGenJnlImportBuffer);
            ValidateEntries(lvngGenJnlImportBuffer, lvngImportBufferError);
        end;
    end;

    local procedure ReadCSVStream()
    var
        TabChar: Char;
    begin
        TabChar := 9;
        if lvngFileImportSchema.lvngFieldSeparator = '<TAB>' then
            lvngFileImportSchema.lvngFieldSeparator := Format(TabChar);
        lvngImportToStream := UploadIntoStream(lvngOpenFileLabel, '', '', lvngFileName, lvngImportStream);
        if lvngImportToStream then begin
            CSVBufferTemp.LoadDataFromStream(lvngImportStream, lvngFileImportSchema.lvngFieldSeparator);
            CSVBufferTemp.ResetFilters();
            CSVBufferTemp.SetRange("Line No.", 0, lvngFileImportSchema.lvngSkipRows);
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
            lvngFileImportJnlLineTemp.SetRange(lvngCode, lvngFileImportSchema.lvngCode);
            lvngFileImportJnlLineTemp.SetFilter(lvngImportFieldType, '<>%1', lvngFileImportJnlLine.lvngImportFieldType::lvngDummy);
            lvngFileImportJnlLineTemp.FindSet();
            repeat
                lvngValue := CSVBufferTemp.GetValue(lvngStartLine, lvngFileImportJnlLineTemp.lvngColumnNo);
                if lvngValue <> '' then begin
                    case lvngFileImportJnlLineTemp.lvngImportFieldType of
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngAccountNo:
                            begin
                                lvngGenJnlImportBuffer.lvngAccountValue := copystr(lvngValue, 1, maxstrlen(lvngGenJnlImportBuffer.lvngAccountValue));
                                if lvngFileImportJnlLineTemp.lvngDimensionSplit then begin
                                    IF lvngFileImportJnlLineTemp.lvngDimensionSplitCharacter <> '' THEN BEGIN
                                        Pos := STRPOS(lvngValue, lvngFileImportJnlLineTemp.lvngDimensionSplitCharacter);
                                        IF Pos <> 0 THEN BEGIN
                                            lvngValue2 := COPYSTR(lvngValue, Pos + 1);
                                            lvngValue := COPYSTR(lvngValue, 1, Pos - 1);
                                            lvngGenJnlImportBuffer.lvngAccountValue := copystr(lvngValue, 1, maxstrlen(lvngGenJnlImportBuffer.lvngAccountValue));
                                            case lvngFileImportJnlLineTemp.lvngSplitDimensionNo of
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
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngAccountType:
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngAccountType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngAmount:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngAmount, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngAppliesToDocNo:
                            begin
                                lvngGenJnlImportBuffer.lvngAppliesToDocNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngAppliesToDocNo));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngAppliesToDocType:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngAppliesToDocType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngBalAccountNo:
                            begin
                                lvngGenJnlImportBuffer.lvngBalAccountValue := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngBalAccountValue));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngBalAccountType:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngBalAccountType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngBankPaymentType:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngBankPaymentType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngBusinessUnitCode:
                            begin
                                lvngGenJnlImportBuffer.lvngBusinessUnitCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngBusinessUnitCode));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngComment:
                            begin
                                lvngGenJnlImportBuffer.lvngComment := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngComment));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDepreciationBookCode:
                            begin
                                lvngGenJnlImportBuffer.lvngDepreciationBookCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngDepreciationBookCode));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDescription:
                            begin
                                lvngGenJnlImportBuffer.lvngDescription := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngDescription));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension1Code:
                            begin
                                lvngGenJnlImportBuffer.lvngGlobalDimension1Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngGlobalDimension1Value));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension2Code:
                            begin
                                lvngGenJnlImportBuffer.lvngGlobalDimension2Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngGlobalDimension2Value));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension3Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension3Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension3Value));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension4Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension4Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension4Value));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension5Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension5Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension5Value));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension6Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension6Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension6Value));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension7Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension7Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension7Value));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension8Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension8Value := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension8Value));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDocumentDate:
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngDocumentDate, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDocumentNo:
                            begin
                                lvngGenJnlImportBuffer.lvngDocumentNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngDocumentNo));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDocumentType:
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngDocumentType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDueDate:
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngDueDate, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngExternalDocumentNo:
                            begin
                                lvngGenJnlImportBuffer.lvngExternalDocumentNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngExternalDocumentNo));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngFAPostingType:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngFAPostingType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngLoanNo:
                            begin
                                lvngGenJnlImportBuffer.lvngLoanNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngLoanNo));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngPaymentMethodCode:
                            begin
                                lvngGenJnlImportBuffer.lvngPaymentMethodCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngPaymentMethodCode));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngPostingDate:
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngPostingDate, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngPostingGroupCode:
                            begin
                                lvngGenJnlImportBuffer.lvngPostingGroup := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngPostingGroup));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngReasonCode:
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
        UserSetupMgmt: codeunit "User Setup Management";
        GLAccount: Record "G/L Account";
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
                if lvngFileImportSchema.lvngReverseAmountSign then begin
                    lvngGenJnlImportBuffer.lvngAmount := -lvngGenJnlImportBuffer.lvngAmount;
                end;
                //Posting Date
                if lvngGenJnlImportBuffer.lvngPostingDate = 0D then begin
                    AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, lvngPostingDateIsBlankLbl);
                end else begin
                    if not UserSetupMgmt.IsPostingDateValid(lvngGenJnlImportBuffer.lvngPostingDate) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, strsubstno(lvngPostingDateIsBlankLbl, lvngGenJnlImportBuffer.lvngPostingDate));
                    end;
                end;
                if lvngGenJnlImportBuffer.lvngDocumentDate = 0D then begin
                    lvngGenJnlImportBuffer.lvngDocumentDate := lvngGenJnlImportBuffer.lvngPostingDate;
                end;

                //Account Type and Account No.
                FindAccountNo(lvngGenJnlImportBuffer.lvngAccountType, lvngGenJnlImportBuffer.lvngAccountValue, lvngGenJnlImportBuffer.lvngAccountNo);
                if lvngFileImportSchema.lvngDefaultAccountNo <> '' then begin
                    lvngGenJnlImportBuffer.lvngAccountType := lvngFileImportSchema.lvngGenJnlAccountType;
                    lvngGenJnlImportBuffer.lvngAccountNo := lvngFileImportSchema.lvngDefaultAccountNo;
                end;
                if lvngGenJnlImportBuffer.lvngAccountNo = '' then begin
                    AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngAccountNoBlankOrMissingLbl, lvngGenJnlImportBuffer.lvngAccountType, lvngGenJnlImportBuffer.lvngAccountValue));
                end else begin
                    if lvngFileImportSchema.lvngSubsGLWithBankAcc then begin
                        if GLAccount.Get(lvngGenJnlImportBuffer.lvngAccountNo) then begin
                            lvngGenJnlImportBuffer.lvngAccountType := lvngGenJnlImportBuffer.lvngAccountType::"Bank Account";
                            lvngGenJnlImportBuffer.lvngAccountNo := GLAccount.lvngLinkedBankAccountNo;
                        end;
                    end;
                end;


                //Bal. Account Type and Bal. Account No.
                if lvngFileImportSchema.lvngDefaultBalAccountNo <> '' then begin
                    lvngGenJnlImportBuffer.lvngBalAccountType := lvngFileImportSchema.lvngGenJnlBalAccountType;
                    lvngGenJnlImportBuffer.lvngBalAccountNo := lvngFileImportSchema.lvngDefaultBalAccountNo;
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
                        if lvngFileImportSchema.lvngDimensionValidationRule = lvngFileImportSchema.lvngDimensionValidationRule::lvngAllLoanDimensions then begin
                            AssignLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                        if lvngFileImportSchema.lvngDimensionValidationRule = lvngFileImportSchema.lvngDimensionValidationRule::lvngEmptyDimensions then begin
                            AssignEmptyLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                        if lvngFileImportSchema.lvngDimensionValidationRule = lvngFileImportSchema.lvngDimensionValidationRule::lvngLoanAndExcludeImportedDimensions then begin
                            AssignNotImportedLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                    end;
                end;

                //Dimensions
                AssignDimensions(lvngGenJnlImportBuffer);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema.lvngDimension1Mandatory, 1, lvngGenJnlImportBuffer.lvngGlobalDimension1Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema.lvngDimension2Mandatory, 2, lvngGenJnlImportBuffer.lvngGlobalDimension2Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema.lvngDimension3Mandatory, 3, lvngGenJnlImportBuffer.lvngShortcutDimension3Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema.lvngDimension4Mandatory, 4, lvngGenJnlImportBuffer.lvngShortcutDimension4Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema.lvngDimension5Mandatory, 5, lvngGenJnlImportBuffer.lvngShortcutDimension5Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema.lvngDimension6Mandatory, 6, lvngGenJnlImportBuffer.lvngShortcutDimension6Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema.lvngDimension7Mandatory, 7, lvngGenJnlImportBuffer.lvngShortcutDimension7Code, lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer.lvngLineNo, lvngFileImportSchema.lvngDimension8Mandatory, 8, lvngGenJnlImportBuffer.lvngShortcutDimension8Code, lvngImportBufferError);

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
                    lvngGenJnlImportBuffer.lvngPostingGroup := lvngFileImportSchema.lvngPostingGroup;
                end;
                if lvngGenJnlImportBuffer.lvngPostingGroup <> '' then begin
                    if not CheckPostingGroup(lvngGenJnlImportBuffer) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, strsubstno(lvngPostingGroupMissingLbl, lvngGenJnlImportBuffer.lvngAccountType, lvngGenJnlImportBuffer.lvngPostingGroup));
                    end;
                end;

                //Reason Code
                if lvngGenJnlImportBuffer.lvngReasonCode = '' then begin
                    lvngGenJnlImportBuffer.lvngReasonCode := lvngFileImportSchema.lvngReasonCode;
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
                    lvngGenJnlImportBuffer.lvngBankPaymentType := lvngFileImportSchema.lvngBankPaymentType;
                end;

                //Recurring Frequence
                if format(lvngGenJnlImportBuffer.lvngRecurringFrequency) = '' then
                    lvngGenJnlImportBuffer.lvngRecurringFrequency := lvngFileImportSchema.lvngRecurringFrequency;

                //Recurring Method
                if lvngGenJnlImportBuffer.lvngRecurringMethod = lvngGenJnlImportBuffer.lvngRecurringMethod::" " then begin
                    lvngGenJnlImportBuffer.lvngRecurringMethod := lvngFileImportSchema.lvngRecurringMethod;
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
        SearchDimension(1, lvngFileImportSchema.lvngDimension1MappingType, lvngGenJnlImportBuffer.lvngGlobalDimension1Value, lvngGenJnlImportBuffer.lvngGlobalDimension1Code);
        SearchDimension(2, lvngFileImportSchema.lvngDimension2MappingType, lvngGenJnlImportBuffer.lvngGlobalDimension2Value, lvngGenJnlImportBuffer.lvngGlobalDimension2Code);
        SearchDimension(3, lvngFileImportSchema.lvngDimension3MappingType, lvngGenJnlImportBuffer.lvngShortcutDimension3Value, lvngGenJnlImportBuffer.lvngShortcutDimension3Code);
        SearchDimension(4, lvngFileImportSchema.lvngDimension4MappingType, lvngGenJnlImportBuffer.lvngShortcutDimension4Value, lvngGenJnlImportBuffer.lvngShortcutDimension4Code);
        SearchDimension(5, lvngFileImportSchema.lvngDimension5MappingType, lvngGenJnlImportBuffer.lvngShortcutDimension5Value, lvngGenJnlImportBuffer.lvngShortcutDimension5Code);
        SearchDimension(6, lvngFileImportSchema.lvngDimension6MappingType, lvngGenJnlImportBuffer.lvngShortcutDimension6Value, lvngGenJnlImportBuffer.lvngShortcutDimension6Code);
        SearchDimension(7, lvngFileImportSchema.lvngDimension7MappingType, lvngGenJnlImportBuffer.lvngShortcutDimension7Value, lvngGenJnlImportBuffer.lvngShortcutDimension7Code);
        SearchDimension(8, lvngFileImportSchema.lvngDimension8MappingType, lvngGenJnlImportBuffer.lvngShortcutDimension8Value, lvngGenJnlImportBuffer.lvngShortcutDimension8Code);
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
        lvngDimensionHierarchy.SetFilter(lvngDate, '..%1', lvngGenJnlImportBuffer.lvngPostingDate);
        lvngDimensionHierarchy.SetRange(lvngCode, DimensionCode);
        if lvngDimensionHierarchy.FindFirst() then begin
            if HierarchyDimensionsUsage[1] then
                lvngGenJnlImportBuffer.lvngGlobalDimension1Code := lvngDimensionHierarchy.lvngGlobalDimension1Code;
            if HierarchyDimensionsUsage[2] then
                lvngGenJnlImportBuffer.lvngGlobalDimension2Code := lvngDimensionHierarchy.lvngGlobalDimension2Code;
            if HierarchyDimensionsUsage[3] then
                lvngGenJnlImportBuffer.lvngShortcutDimension3Code := lvngDimensionHierarchy.lvngShortcutDimension3Code;
            if HierarchyDimensionsUsage[4] then
                lvngGenJnlImportBuffer.lvngShortcutDimension4Code := lvngDimensionHierarchy.lvngShortcutDimension4Code;
            if HierarchyDimensionsUsage[5] then
                lvngGenJnlImportBuffer.lvngBusinessUnitCode := lvngDimensionHierarchy.lvngBusinessUnitCode;
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
            lvngGenJnlImportBuffer.lvngGlobalDimension1Code := lvngLoan.lvngGlobalDimension1Code;
            lvngGenJnlImportBuffer.lvngGlobalDimension2Code := lvngLoan.lvngGlobalDimension2Code;
            lvngGenJnlImportBuffer.lvngShortcutDimension3Code := lvngLoan.lvngShortcutDimension3Code;
            lvngGenJnlImportBuffer.lvngShortcutDimension4Code := lvngLoan.lvngShortcutDimension4Code;
            lvngGenJnlImportBuffer.lvngShortcutDimension5Code := lvngLoan.lvngShortcutDimension5Code;
            lvngGenJnlImportBuffer.lvngShortcutDimension6Code := lvngLoan.lvngShortcutDimension6Code;
            lvngGenJnlImportBuffer.lvngShortcutDimension7Code := lvngLoan.lvngShortcutDimension7Code;
            lvngGenJnlImportBuffer.lvngShortcutDimension8Code := lvngLoan.lvngShortcutDimension8Code;
            lvngGenJnlImportBuffer.lvngBusinessUnitCode := lvngLoan.lvngBusinessUnitCode;
        end;
    end;

    local procedure AssignEmptyLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer.lvngLoanNo) then begin
            if lvngGenJnlImportBuffer.lvngGlobalDimension1Value = '' then
                lvngGenJnlImportBuffer.lvngGlobalDimension1Code := lvngLoan.lvngGlobalDimension1Code;
            if lvngGenJnlImportBuffer.lvngGlobalDimension2Value = '' then
                lvngGenJnlImportBuffer.lvngGlobalDimension2Code := lvngLoan.lvngGlobalDimension2Code;
            if lvngGenJnlImportBuffer.lvngShortcutDimension3Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension3Code := lvngLoan.lvngShortcutDimension3Code;
            if lvngGenJnlImportBuffer.lvngShortcutDimension4Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension4Code := lvngLoan.lvngShortcutDimension4Code;
            if lvngGenJnlImportBuffer.lvngShortcutDimension5Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension5Code := lvngLoan.lvngShortcutDimension5Code;
            if lvngGenJnlImportBuffer.lvngShortcutDimension6Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension6Code := lvngLoan.lvngShortcutDimension6Code;
            if lvngGenJnlImportBuffer.lvngShortcutDimension7Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension7Code := lvngLoan.lvngShortcutDimension7Code;
            if lvngGenJnlImportBuffer.lvngShortcutDimension8Value = '' then
                lvngGenJnlImportBuffer.lvngShortcutDimension8Code := lvngLoan.lvngShortcutDimension8Code;
            if lvngGenJnlImportBuffer.lvngBusinessUnitCode = '' then
                lvngGenJnlImportBuffer.lvngBusinessUnitCode := lvngLoan.lvngBusinessUnitCode;
        end;
    end;

    local procedure AssignNotImportedLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer.lvngLoanNo) then begin
            lvngFileImportJnlLineTemp.reset;
            lvngFileImportJnlLineTemp.SetRange(lvngImportFieldType, lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension1Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngGlobalDimension1Code := lvngLoan.lvngGlobalDimension1Code;

            lvngFileImportJnlLineTemp.SetRange(lvngImportFieldType, lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension2Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngGlobalDimension2Code := lvngLoan.lvngGlobalDimension2Code;

            lvngFileImportJnlLineTemp.SetRange(lvngImportFieldType, lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension3Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension3Code := lvngLoan.lvngShortcutDimension3Code;

            lvngFileImportJnlLineTemp.SetRange(lvngImportFieldType, lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension4Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension4Code := lvngLoan.lvngShortcutDimension4Code;

            lvngFileImportJnlLineTemp.SetRange(lvngImportFieldType, lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension5Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension5Code := lvngLoan.lvngShortcutDimension5Code;

            lvngFileImportJnlLineTemp.SetRange(lvngImportFieldType, lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension6Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension6Code := lvngLoan.lvngShortcutDimension6Code;

            lvngFileImportJnlLineTemp.SetRange(lvngImportFieldType, lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension7Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension7Code := lvngLoan.lvngShortcutDimension7Code;

            lvngFileImportJnlLineTemp.SetRange(lvngImportFieldType, lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension8Code);
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer.lvngShortcutDimension8Code := lvngLoan.lvngShortcutDimension8Code;
        end;
    end;

    local procedure CheckLoanNo(var lvngLoanNo: Code[20]): Boolean
    var
        lvngLoan: Record lvngLoan;
    begin
        case lvngFileImportSchema.lvngLoanNoValidationRule of
            lvngFileImportSchema.lvngLoanNoValidationRule::lvngBlankIfNotFound:
                begin
                    if not lvngLoan.Get(lvngLoanNo) then begin
                        Clear(lvngLoanNo);
                        exit(true);
                    end;
                end;
            lvngFileImportSchema.lvngLoanNoValidationRule::lvngValidate:
                begin
                    if not lvngloan.Get(lvngLoanNo) then
                        exit(false);
                end;
        end;
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
        case lvngFileImportSchema.lvngAccountMappingType of
            lvngFileImportSchema.lvngAccountMappingType::lvngName:
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
            lvngFileImportSchema.lvngAccountMappingType::lvngNo:
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
            lvngFileImportSchema.lvngAccountMappingType::lvngNo2:
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
            lvngFileImportSchema.lvngAccountMappingType::lvngSearchName:
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