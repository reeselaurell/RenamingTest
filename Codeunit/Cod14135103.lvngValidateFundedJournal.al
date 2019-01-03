codeunit 14135103 "lvngValidateFundedJournal"
{
    var
        lvngLoanImportErrorLine: Record lvngLoanImportErrorLine;
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        lvngCreateFundedDocuments: Codeunit lvngCreateFundedDocuments;
        lvngLoanVisionSetupRetrieved: Boolean;

    procedure ValidateFundedLines(lvngJournalBatchCode: Code[20])
    var
        lvngLoanJournalLine: Record lvngLoanJournalLine;
    begin
        lvngLoanJournalLine.reset;
        lvngLoanJournalLine.SetRange(lvngLoanJournalBatchCode, lvngJournalBatchCode);
        lvngLoanJournalLine.FindSet();
        repeat
            ClearJournalLineErrors(lvngLoanJournalLine);
            ValidateSingleJournalLine(lvngLoanJournalLine);
        until lvngLoanJournalLine.Next() = 0;

    end;

    local procedure ValidateSingleJournalLine(var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngJournalValidationRule: Record lvngJournalValidationRule;
        Customer: Record Customer;
        lvngLoanDocument: Record lvngLoanDocument temporary;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine temporary;
        LoanNoEmptyLbl: Label 'Loan No. can not be blank';
        FundedDateBlankLbl: Label 'Funded Date can not be blank';
        SearchNameBlankLbl: Label 'Search Name can not be compiled';
        ProcessingSchemaBlankLbl: Label 'Processing Schema Code can not be blank';
        TitleCustomerNoMissingLbl: Label 'Title Customer No. is missing';
        ReasonCodeMissingOnLineLbl: Label 'Reason Code is mandatory for Transaction, Line No. %1';
    begin
        GetLoanVisionSetup();
        if lvngLoanJournalLine.lvngLoanNo = '' then
            AddJournalLineError(lvngLoanJournalLine, LoanNoEmptyLbl);
        if lvngLoanJournalLine.lvngDateFunded = 0D then
            AddJournalLineError(lvngLoanJournalLine, FundedDateBlankLbl);
        if lvngLoanJournalLine.lvngSearchName = '' then begin
            GetLoanVisionSetup();
            lvngLoanJournalLine.lvngSearchName := StrSubstNo(lvngLoanVisionSetup.lvngSearchNameTemplate, lvngLoanJournalLine.lvngBorrowerFirstName, lvngLoanJournalLine.lvngBorrowerLastName, lvngLoanJournalLine.lvngBorrowerMiddleName);
            if DelChr(lvngLoanJournalLine.lvngSearchName, '=', ', ') = '' then
                AddJournalLineError(lvngLoanJournalLine, SearchNameBlankLbl) else
                lvngLoanJournalLine.Modify();
        end;
        if lvngLoanJournalLine.lvngProcessingSchemaCode = '' then begin
            AddJournalLineError(lvngLoanJournalLine, ProcessingSchemaBlankLbl)
        end else begin
            clear(lvngLoanJournalLine.lvngCalculatedDocumentAmount);
            Clear(lvngCreateFundedDocuments);
            lvngCreateFundedDocuments.CreateSingleDocument(lvngLoanJournalLine, lvngLoanDocument, lvngLoanDocumentLine, true);
            lvngLoanDocumentLine.reset;
            lvngLoanDocumentLine.SetRange(lvngBalancingEntry, false);
            if lvngLoanDocumentLine.FindSet() then begin
                repeat
                    lvngLoanJournalLine.lvngCalculatedDocumentAmount := lvngLoanJournalLine.lvngCalculatedDocumentAmount + lvngLoanDocumentLine.lvngAmount;
                until lvngLoanDocumentLine.Next() = 0;
            end;
            lvngLoanJournalLine.Modify()
        end;
        lvngJournalValidationRule.reset;
        lvngJournalValidationRule.SetRange(lvngJournalBatchCode, lvngLoanJournalLine.lvngLoanJournalBatchCode);
        if lvngJournalValidationRule.FindSet() then begin
            repeat
                if not ValidateConditionLine(lvngLoanJournalLine) then begin
                    AddJournalLineError(lvngLoanJournalLine, lvngJournalValidationRule.lvngErrorMessage);
                end;
            until lvngJournalValidationRule.Next() = 0;
        end;
        if (lvngLoanDocument.lvngCustomerNo = '') then
            AddJournalLineError(lvngLoanJournalLine, TitleCustomerNoMissingLbl) else begin
            if not Customer.get(lvngLoanDocument.lvngCustomerNo) then
                AddJournalLineError(lvngLoanJournalLine, TitleCustomerNoMissingLbl);
        end;
        lvngLoanDocumentLine.reset;
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                if lvngLoanDocumentLine.lvngReasonCode = '' then begin
                    AddJournalLineError(lvngLoanJournalLine, strsubstno(ReasonCodeMissingOnLineLbl, lvngLoanDocumentLine.lvngLineNo));
                end;
            until lvngLoanDocumentLine.Next() = 0;
        end;
    end;

    local procedure ValidateConditionLine(var lvngLoanJournalLine: record lvngLoanJournalLine): Boolean
    begin
        //not implemented cz one alcoholic is off
        exit(false);
    end;

    local procedure ClearJournalLineErrors(lvngLoanJournalLine: Record lvngLoanJournalLine)
    begin
        lvngLoanImportErrorLine.reset;
        lvngLoanImportErrorLine.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLoanJournalBatchCode);
        lvngLoanImportErrorLine.SetRange(lvngLineNo, lvngLoanJournalLine.lvngLineNo);
        lvngLoanImportErrorLine.DeleteAll();
    end;

    local procedure AddJournalLineError(lvngLoanJournalLine: Record lvngLoanJournalLine; lvngErrorText: Text)
    var
        lvngErrorLineNo: Integer;
    begin
        lvngErrorLineNo := 100;
        lvngLoanImportErrorLine.reset;
        lvngLoanImportErrorLine.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLoanJournalBatchCode);
        lvngLoanImportErrorLine.SetRange(lvngLineNo, lvngLoanJournalLine.lvngLineNo);
        if lvngLoanImportErrorLine.FindLast() then
            lvngErrorLineNo := lvngLoanImportErrorLine.lvngErrorLineNo + 100;
        Clear(lvngLoanImportErrorLine);
        lvngLoanImportErrorLine.Init();
        lvngLoanImportErrorLine.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
        lvngLoanImportErrorLine.lvngLineNo := lvngLoanJournalLine.lvngLineNo;
        lvngLoanImportErrorLine.lvngErrorLineNo := lvngErrorLineNo;
        lvngLoanImportErrorLine.lvngDescription := CopyStr(lvngErrorText, 1, MaxStrLen(lvngLoanImportErrorLine.lvngDescription));
        lvngLoanImportErrorLine.Insert;
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetup.Get();
            lvngLoanVisionSetupRetrieved := true;
        end;
    end;

}