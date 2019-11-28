codeunit 14135112 lvngValidateSoldJournal
{
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        CreateSoldDocuments: Codeunit lvngCreateSoldDocuments;
        LoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        ConditionsMgmt: Codeunit lvngConditionsMgmt;

    procedure ValidateSoldLines(JournalBatchCode: Code[20])
    var
        LoanJournalLine: Record lvngLoanJournalLine;
    begin
        LoanVisionSetup.Get();
        LoanJournalLine.Reset();
        LoanJournalLine.SetRange("Loan Journal Batch Code", JournalBatchCode);
        LoanJournalLine.FindSet();
        repeat
            LoanJournalErrorMgmt.ClearJournalLineErrors(LoanJournalLine);
            ValidateSingleJournalLine(LoanJournalLine);
        until LoanJournalLine.Next() = 0;
    end;

    local procedure ValidateSingleJournalLine(var LoanJournalLine: record lvngLoanJournalLine)
    var
        JournalValidationRule: Record lvngJournalValidationRule;
        ExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        Customer: Record Customer;
        LoanDocument: Record lvngLoanDocument;
        LoanSoldDocument: Record lvngLoanSoldDocument;
        TempLoanDocument: Record lvngLoanDocument temporary;
        TempLoanDocumentLine: Record lvngLoanDocumentLine temporary;
        VoidedDocumentsCount: Integer;
        SoldDocumentsCount: Integer;
        LoanNoEmptyErr: Label 'Loan No. can not be blank';
        SoldDateBlankErr: Label 'Sold Date can not be blank';
        SearchNameBlankErr: Label 'Search Name can not be compiled';
        ProcessingSchemaBlankErr: Label 'Processing Schema Code can not be blank';
        InvestorCustomerNoMissingErr: Label 'Investor Customer No. is missing';
        ReasonCodeMissingOnLineErr: Label 'Reason Code is mandatory for Transaction, Line No. %1';
        AccountNoMissingOnLineErr: Label 'Account No. is mandatory for Transaction, Line No. %1';
        NonPostedVoidDocumentExistsErr: Label 'Non-Posted Sold Void document already exists %1';
        NonPostedDocumentExistsErr: Label 'Non-Posted Sold document already exists %1';
        PostedDocumentExistsErr: Label 'Posted Sold document already exists %1';
        NothingToVoidErr: Label 'There is nothing to void';
    begin
        if LoanJournalLine."Loan No." = '' then
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, LoanNoEmptyErr);
        if (LoanVisionSetup."Sold Void Reason Code" <> '') and (LoanVisionSetup."Sold Void Reason Code" = LoanJournalLine."Reason Code") then begin
            LoanDocument.Reset();
            LoanDocument.SetRange(Void, true);
            LoanDocument.SetRange("Loan No.", LoanJournalLine."Loan No.");
            LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Sold);
            if not LoanDocument.IsEmpty() then begin
                LoanDocument.FindFirst();
                LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, StrSubstNo(NonPostedVoidDocumentExistsErr, LoanDocument."Document No."));
            end;
            LoanSoldDocument.Reset();
            LoanSoldDocument.SetRange("Loan No.", LoanJournalLine."Loan No.");
            LoanSoldDocument.SetRange(Void, false);
            if LoanSoldDocument.IsEmpty() then
                LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, NothingToVoidErr);
            exit;
        end;
        LoanDocument.Reset();
        LoanDocument.SetRange(Void, false);
        LoanDocument.SetRange("Loan No.", LoanJournalLine."Loan No.");
        LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Sold);
        if not LoanDocument.IsEmpty() then begin
            LoanDocument.FindFirst();
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, strsubstno(NonPostedDocumentExistsErr, LoanDocument."Document No."));
        end;
        LoanSoldDocument.Reset();
        LoanSoldDocument.SetRange("Loan No.", LoanJournalLine."Loan No.");
        LoanSoldDocument.SetRange(Void, false);
        if not LoanSoldDocument.IsEmpty() then begin
            SoldDocumentsCount := LoanSoldDocument.Count();
            LoanSoldDocument.SetRange(Void, true);
            VoidedDocumentsCount := LoanSoldDocument.Count();
            if (SoldDocumentsCount <> VoidedDocumentsCount) then begin
                LoanSoldDocument.SetRange(Void, false);
                LoanSoldDocument.FindLast();
                LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, strsubstno(PostedDocumentExistsErr, LoanSoldDocument."Document No."));
            end;
        end;
        if LoanJournalLine."Date Sold" = 0D then
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, SoldDateBlankErr);
        if LoanJournalLine."Search Name" = '' then begin
            LoanJournalLine."Search Name" := StrSubstNo(LoanVisionSetup."Search Name Template", LoanJournalLine."Borrower First Name", LoanJournalLine."Borrower Last Name", LoanJournalLine."Borrower Middle Name");
            if DelChr(LoanJournalLine."Search Name", '=', ', ') = '' then
                LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, SearchNameBlankErr)
            else
                LoanJournalLine.Modify();
        end;
        if LoanJournalLine."Processing Schema Code" = '' then
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, ProcessingSchemaBlankErr)
        else begin
            Clear(LoanJournalLine."Calculated Document Amount");
            Clear(CreateSoldDocuments);
            CreateSoldDocuments.CreateSingleDocument(LoanJournalLine, TempLoanDocument, TempLoanDocumentLine, true);
            TempLoanDocumentLine.Reset();
            TempLoanDocumentLine.SetRange("Balancing Entry", false);
            if TempLoanDocumentLine.FindSet() then
                repeat
                    LoanJournalLine."Calculated Document Amount" := LoanJournalLine."Calculated Document Amount" + TempLoanDocumentLine.Amount;
                until TempLoanDocumentLine.Next() = 0;
            LoanJournalLine.Modify();
        end;
        JournalValidationRule.Reset();
        JournalValidationRule.SetRange("Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
        if JournalValidationRule.FindSet() then begin
            ConditionsMgmt.FillJournalFieldValues(ExpressionValueBuffer, LoanJournalLine);
            repeat
                if not ValidateConditionLine(ExpressionValueBuffer, JournalValidationRule."Condition Code") then
                    LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, JournalValidationRule."Error Message");
            until JournalValidationRule.Next() = 0;
        end;
        if (TempLoanDocument."Customer No." = '') then
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, InvestorCustomerNoMissingErr)
        else begin
            if not Customer.get(TempLoanDocument."Customer No.") then
                LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, InvestorCustomerNoMissingErr);
        end;
        TempLoanDocumentLine.Reset();
        if TempLoanDocumentLine.FindSet() then
            repeat
                if TempLoanDocumentLine."Reason Code" = '' then
                    LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, strsubstno(ReasonCodeMissingOnLineErr, TempLoanDocumentLine."Line No."));
                if TempLoanDocumentLine."Account No." = '' then
                    LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, strsubstno(AccountNoMissingOnLineErr, TempLoanDocumentLine."Line No."));
            until TempLoanDocumentLine.Next() = 0;
    end;

    local procedure ValidateConditionLine(var ExpressionValueBuffer: Record lvngExpressionValueBuffer; ConditionCode: Code[20]): Boolean
    var
        ExpressionEngine: Codeunit lvngExpressionEngine;
        ConditionsMgmt: Codeunit lvngConditionsMgmt;
        ExpressionHeader: Record lvngExpressionHeader;
    begin
        ExpressionHeader.Get(ConditionCode, ConditionsMgmt.GetConditionsMgmtConsumerId());
        exit(ExpressionEngine.CheckCondition(ExpressionHeader, ExpressionValueBuffer));
    end;
}