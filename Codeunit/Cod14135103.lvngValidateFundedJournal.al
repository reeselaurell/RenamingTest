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
            lvngLoanJournalErrorMgmt.ClearJournalLineErrors(lvngLoanJournalLine);
            ValidateSingleJournalLine(lvngLoanJournalLine);
        until lvngLoanJournalLine.Next() = 0;

    end;

    local procedure ValidateSingleJournalLine(var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngJournalValidationRule: Record lvngJournalValidationRule;
        lvngExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        Customer: Record Customer;
        lvngLoanDocument: Record lvngLoanDocument temporary;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine temporary;
        LoanNoEmptyLbl: Label 'Loan No. can not be blank';
        FundedDateBlankLbl: Label 'Funded Date can not be blank';
        SearchNameBlankLbl: Label 'Search Name can not be compiled';
        ProcessingSchemaBlankLbl: Label 'Processing Schema Code can not be blank';
        TitleCustomerNoMissingLbl: Label 'Title Customer No. is missing';
        ReasonCodeMissingOnLineLbl: Label 'Reason Code is mandatory for Transaction, Line No. %1';
        AccountNoMissingOnLineLbl: Label 'Account No. is mandatory for Transaction, Line No. %1';
    begin
        GetLoanVisionSetup();
        if lvngLoanJournalLine.lvngLoanNo = '' then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, LoanNoEmptyLbl);
        if lvngLoanJournalLine.lvngDateFunded = 0D then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, FundedDateBlankLbl);
        if lvngLoanJournalLine.lvngSearchName = '' then begin
            GetLoanVisionSetup();
            lvngLoanJournalLine.lvngSearchName := StrSubstNo(lvngLoanVisionSetup.lvngSearchNameTemplate, lvngLoanJournalLine.lvngBorrowerFirstName, lvngLoanJournalLine.lvngBorrowerLastName, lvngLoanJournalLine.lvngBorrowerMiddleName);
            if DelChr(lvngLoanJournalLine.lvngSearchName, '=', ', ') = '' then
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, SearchNameBlankLbl) else
                lvngLoanJournalLine.Modify();
        end;
        if lvngLoanJournalLine.lvngProcessingSchemaCode = '' then begin
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, ProcessingSchemaBlankLbl)
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
            lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
            repeat
                if not ValidateConditionLine(lvngExpressionValueBuffer, lvngJournalValidationRule.lvngConditionCode) then begin
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, lvngJournalValidationRule.lvngErrorMessage);
                end;
            until lvngJournalValidationRule.Next() = 0;
        end;
        if (lvngLoanDocument.lvngCustomerNo = '') then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, TitleCustomerNoMissingLbl) else begin
            if not Customer.get(lvngLoanDocument.lvngCustomerNo) then
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, TitleCustomerNoMissingLbl);
        end;
        lvngLoanDocumentLine.reset;
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                if lvngLoanDocumentLine.lvngReasonCode = '' then begin
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(ReasonCodeMissingOnLineLbl, lvngLoanDocumentLine.lvngLineNo));
                end;
                if lvngLoanDocumentLine.lvngAccountNo = '' then begin
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(AccountNoMissingOnLineLbl, lvngLoanDocumentLine.lvngLineNo));
                end;
            until lvngLoanDocumentLine.Next() = 0;
        end;
    end;

    local procedure ValidateConditionLine(var lvngExpressionValueBuffer: Record lvngExpressionValueBuffer; lvngConditionCode: Code[20]): Boolean
    var
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
    begin
        GetLoanVisionSetup();
        exit(lvngExpressionEngine.CheckCondition(lvngConditionCode, lvngExpressionValueBuffer));
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetup.Get();
            lvngLoanVisionSetupRetrieved := true;
        end;
    end;

    var
        lvngLoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        lvngConditionsMgmt: Codeunit lvngConditionsMgmt;

}