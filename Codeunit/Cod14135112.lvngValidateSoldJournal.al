codeunit 14135112 "lvngValidateSoldJournal"
{
    var
        lvngLoanImportErrorLine: Record lvngLoanImportErrorLine;
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        lvngCreateSoldDocuments: Codeunit lvngCreateSoldDocuments;
        lvngLoanVisionSetupRetrieved: Boolean;

    procedure ValidateSoldLines(lvngJournalBatchCode: Code[20])
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
        lvngLoanSoldDocument: Record lvngLoanSoldDocument;
        lvngLoanDocumentTemp: Record lvngLoanDocument temporary;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine temporary;
        lvngVoidedDocumentsCount: Integer;
        lvngSoldDocumentsCount: Integer;
        LoanNoEmptyLbl: Label 'Loan No. can not be blank';
        SoldDateBlankLbl: Label 'Sold Date can not be blank';
        SearchNameBlankLbl: Label 'Search Name can not be compiled';
        ProcessingSchemaBlankLbl: Label 'Processing Schema Code can not be blank';
        InvestorCustomerNoMissingLbl: Label 'Investor Customer No. is missing';
        ReasonCodeMissingOnLineLbl: Label 'Reason Code is mandatory for Transaction, Line No. %1';
        AccountNoMissingOnLineLbl: Label 'Account No. is mandatory for Transaction, Line No. %1';
        NonPostedVoidDocumentExistsLbl: Label 'Non-Posted Sold Void document already exists %1';
        NonPostedDocumentExistsLbl: Label 'Non-Posted Sold document already exists %1';
        PostedDocumentExistsLbl: Label 'Posted Sold document already exists %1';
        NothingToVoidLbl: Label 'There is nothing to void';
    begin
        GetLoanVisionSetup();
        if lvngLoanJournalLine.lvngLoanNo = '' then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, LoanNoEmptyLbl);
        if (lvngLoanVisionSetup.lvngSoldVoidReasonCode <> '') and
            (lvngLoanVisionSetup.lvngSoldVoidReasonCode = lvngLoanJournalLine.lvngReasonCode) then begin
            lvngLoanDocument.reset;
            lvngLoanDocument.SetRange(lvngVoid, true);
            lvngLoanDocument.SetRange(lvngLoanNo, lvngLoanJournalLine.lvngLoanNo);
            lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngSold);
            if not lvngLoanDocument.IsEmpty() then begin
                lvngLoanDocument.FindFirst();
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(NonPostedVoidDocumentExistsLbl, lvngLoanDocument.lvngDocumentNo));
            end;
            lvngLoanSoldDocument.reset;
            lvngLoanSoldDocument.SetRange(lvngLoanNo, lvngLoanJournalLine.lvngLoanNo);
            lvngLoanSoldDocument.SetRange(lvngVoid, false);
            if lvngLoanSoldDocument.IsEmpty() then begin
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, NothingToVoidLbl);
            end;
            exit;
        end else begin
            lvngLoanDocument.reset;
            lvngLoanDocument.SetRange(lvngVoid, false);
            lvngLoanDocument.SetRange(lvngLoanNo, lvngLoanJournalLine.lvngLoanNo);
            lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngSold);
            if not lvngLoanDocument.IsEmpty() then begin
                lvngLoanDocument.FindFirst();
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(NonPostedDocumentExistsLbl, lvngLoanDocument.lvngDocumentNo));
            end;
            lvngLoanSoldDocument.reset;
            lvngLoanSoldDocument.SetRange(lvngLoanNo, lvngLoanJournalLine.lvngLoanNo);
            lvngLoanSoldDocument.SetRange(lvngVoid, false);
            if not lvngLoanSoldDocument.IsEmpty() then begin
                lvngSoldDocumentsCount := lvngLoanSoldDocument.Count();
                lvngLoanSoldDocument.SetRange(lvngVoid, true);
                lvngVoidedDocumentsCount := lvngLoanSoldDocument.Count();
                if (lvngSoldDocumentsCount <> lvngVoidedDocumentsCount) then begin
                    lvngLoanSoldDocument.SetRange(lvngVoid, false);
                    lvngLoanSoldDocument.FindLast();
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(PostedDocumentExistsLbl, lvngLoanSoldDocument.lvngDocumentNo));
                end;
            end;
        end;
        if lvngLoanJournalLine.lvngDateSold = 0D then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, SoldDateBlankLbl);
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
            Clear(lvngCreateSoldDocuments);
            lvngCreateSoldDocuments.CreateSingleDocument(lvngLoanJournalLine, lvngLoanDocumentTemp, lvngLoanDocumentLine, true);
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
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, InvestorCustomerNoMissingLbl) else begin
            if not Customer.get(lvngLoanDocumentTemp.lvngCustomerNo) then
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, InvestorCustomerNoMissingLbl);
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
        exit(lvngExpressionEngine.CheckCondition(lvngConditionCode, lvngExpressionValueBuffer, true));
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