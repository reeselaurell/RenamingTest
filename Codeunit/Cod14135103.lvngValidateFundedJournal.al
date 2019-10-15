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
        lvngLoanDocument: Record lvngLoanDocument;
        lvngLoanFundedDocument: Record lvngLoanFundedDocument;
        lvngLoanDocumentTemp: Record lvngLoanDocument temporary;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine temporary;
        lvngVoidedDocumentsCount: Integer;
        lvngFundedDocumentsCount: Integer;
        LoanNoEmptyLbl: Label 'Loan No. can not be blank';
        FundedDateBlankLbl: Label 'Funded Date can not be blank';
        SearchNameBlankLbl: Label 'Search Name can not be compiled';
        ProcessingSchemaBlankLbl: Label 'Processing Schema Code can not be blank';
        TitleCustomerNoMissingLbl: Label 'Title Customer No. is missing';
        ReasonCodeMissingOnLineLbl: Label 'Reason Code is mandatory for Transaction, Line No. %1';
        AccountNoMissingOnLineLbl: Label 'Account No. is mandatory for Transaction, Line No. %1';
        NonPostedVoidDocumentExistsLbl: Label 'Non-Posted Funded Void document already exists %1';
        NonPostedDocumentExistsLbl: Label 'Non-Posted Funded document already exists %1';
        PostedDocumentExistsLbl: Label 'Posted Funded document already exists %1';
        NothingToVoidLbl: Label 'There is nothing to void';
    begin
        GetLoanVisionSetup();
        if lvngLoanJournalLine.lvngLoanNo = '' then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, LoanNoEmptyLbl);
        if (lvngLoanVisionSetup.lvngFundedVoidReasonCode <> '') and
            (lvngLoanVisionSetup.lvngFundedVoidReasonCode = lvngLoanJournalLine.lvngReasonCode) then begin
            lvngLoanDocument.reset;
            lvngLoanDocument.SetRange(lvngVoid, true);
            lvngLoanDocument.SetRange(lvngLoanNo, lvngLoanJournalLine.lvngLoanNo);
            lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngFunded);
            if not lvngLoanDocument.IsEmpty() then begin
                lvngLoanDocument.FindFirst();
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(NonPostedVoidDocumentExistsLbl, lvngLoanDocument.lvngDocumentNo));
            end;
            lvngLoanFundedDocument.reset;
            lvngLoanFundedDocument.SetRange(lvngLoanNo, lvngLoanJournalLine.lvngLoanNo);
            lvngLoanFundedDocument.SetRange(lvngVoid, false);
            if lvngLoanFundedDocument.IsEmpty() then begin
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, NothingToVoidLbl);
            end;
            exit;
        end else begin
            lvngLoanDocument.reset;
            lvngLoanDocument.SetRange(lvngVoid, false);
            lvngLoanDocument.SetRange(lvngLoanNo, lvngLoanJournalLine.lvngLoanNo);
            lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngFunded);
            if not lvngLoanDocument.IsEmpty() then begin
                lvngLoanDocument.FindFirst();
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(NonPostedDocumentExistsLbl, lvngLoanDocument.lvngDocumentNo));
            end;
            lvngLoanFundedDocument.reset;
            lvngLoanFundedDocument.SetRange(lvngLoanNo, lvngLoanJournalLine.lvngLoanNo);
            lvngLoanFundedDocument.SetRange(lvngVoid, false);
            if not lvngLoanFundedDocument.IsEmpty() then begin
                lvngFundedDocumentsCount := lvngLoanFundedDocument.Count();
                lvngLoanFundedDocument.SetRange(lvngVoid, true);
                lvngVoidedDocumentsCount := lvngLoanFundedDocument.Count();
                if (lvngFundedDocumentsCount <> lvngVoidedDocumentsCount) then begin
                    lvngLoanFundedDocument.SetRange(lvngVoid, false);
                    lvngLoanFundedDocument.FindLast();
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(PostedDocumentExistsLbl, lvngLoanFundedDocument.lvngDocumentNo));
                end;
            end;
        end;
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
            lvngCreateFundedDocuments.CreateSingleDocument(lvngLoanJournalLine, lvngLoanDocumentTemp, lvngLoanDocumentLine, true);
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
        if (lvngLoanDocumentTemp.lvngCustomerNo = '') then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, TitleCustomerNoMissingLbl) else begin
            if not Customer.get(lvngLoanDocumentTemp.lvngCustomerNo) then
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
        ConditionMgmt: Codeunit lvngConditionsMgmt;
        ExpressionHeader: Record lvngExpressionHeader;
    begin
        GetLoanVisionSetup();
        ExpressionHeader.Get(lvngConditionCode, ConditionMgmt.GetConditionsMgmtConsumerId());
        exit(lvngExpressionEngine.CheckCondition(ExpressionHeader, lvngExpressionValueBuffer));
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