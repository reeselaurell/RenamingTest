codeunit 14135103 lvngValidateFundedJournal
{
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        LoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        ConditionsMgmt: Codeunit lvngConditionsMgmt;
        CreateFundedDocuments: Codeunit lvngCreateFundedDocuments;
        LoanVisionSetupRetrieved: Boolean;

    procedure ValidateFundedLines(JournalBatchCode: Code[20])
    var
        LoanJournalLine: Record lvngLoanJournalLine;
    begin
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
        LoanNoEmptyErr: Label 'Loan No. can not be blank';
        FundedDateBlankErr: Label 'Funded Date can not be blank';
        SearchNameBlankErr: Label 'Search Name can not be compiled';
        ProcessingSchemaBlankErr: Label 'Processing Schema Code can not be blank';
        TitleCustomerNoMissingErr: Label 'Title Customer No. is missing';
        ReasonCodeMissingOnLineErr: Label 'Reason Code is mandatory for Transaction, Line No. %1';
        AccountNoMissingOnLineErr: Label 'Account No. is mandatory for Transaction, Line No. %1';
        NonPostedVoidDocumentExistsErr: Label 'Non-Posted Funded Void document already exists %1';
        NonPostedDocumentExistsErr: Label 'Non-Posted Funded document already exists %1';
        PostedDocumentExistsErr: Label 'Posted Funded document already exists %1';
        NothingToVoidErr: Label 'There is nothing to void';
        JournalValidationRule: Record lvngJournalValidationRule;
        ExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        Customer: Record Customer;
        LoanDocument: Record lvngLoanDocument;
        LoanFundedDocument: Record lvngLoanFundedDocument;
        TempLoanDocument: Record lvngLoanDocument temporary;
        TempLoanDocumentLine: Record lvngLoanDocumentLine temporary;
        VoidedDocumentsCount: Integer;
        FundedDocumentsCount: Integer;
        FieldSequenceNo: Integer;
    begin
        GetLoanVisionSetup();
        if LoanJournalLine."Loan No." = '' then
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, LoanNoEmptyErr);
        if (LoanVisionSetup."Funded Void Reason Code" <> '') and (LoanVisionSetup."Funded Void Reason Code" = LoanJournalLine."Reason Code") then begin
            LoanDocument.Reset();
            LoanDocument.SetRange(Void, true);
            LoanDocument.SetRange("Loan No.", LoanJournalLine."Loan No.");
            LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Funded);
            if not LoanDocument.IsEmpty() then begin
                LoanDocument.FindFirst();
                LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, StrSubstNo(NonPostedVoidDocumentExistsErr, LoanDocument."Document No."));
            end;
            LoanFundedDocument.Reset();
            LoanFundedDocument.SetRange("Loan No.", LoanJournalLine."Loan No.");
            LoanFundedDocument.SetRange(Void, false);
            if LoanFundedDocument.IsEmpty() then
                LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, NothingToVoidErr);
            exit;
        end else begin
            LoanDocument.Reset();
            LoanDocument.SetRange(Void, false);
            LoanDocument.SetRange("Loan No.", LoanJournalLine."Loan No.");
            LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Funded);
            if not LoanDocument.IsEmpty() then begin
                LoanDocument.FindFirst();
                LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, strsubstno(NonPostedDocumentExistsErr, LoanDocument."Document No."));
            end;
            LoanFundedDocument.Reset();
            LoanFundedDocument.SetRange("Loan No.", LoanJournalLine."Loan No.");
            LoanFundedDocument.SetRange(Void, false);
            if not LoanFundedDocument.IsEmpty() then begin
                FundedDocumentsCount := LoanFundedDocument.Count();
                LoanFundedDocument.SetRange(Void, true);
                VoidedDocumentsCount := LoanFundedDocument.Count();
                if (FundedDocumentsCount <> VoidedDocumentsCount) then begin
                    LoanFundedDocument.SetRange(Void, false);
                    LoanFundedDocument.FindLast();
                    LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, strsubstno(PostedDocumentExistsErr, LoanFundedDocument."Document No."));
                end;
            end;
        end;
        if LoanJournalLine."Date Funded" = 0D then
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, FundedDateBlankErr);
        if LoanJournalLine."Search Name" = '' then begin
            LoanJournalLine."Search Name" := StrSubstNo(LoanVisionSetup."Search Name Template", LoanJournalLine."Borrower First Name", LoanJournalLine."Borrower Last Name", LoanJournalLine."Borrower Middle Name");
            if DelChr(LoanJournalLine."Search Name", '=', ', ') = '' then
                LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, SearchNameBlankErr) else
                LoanJournalLine.Modify();
        end;
        if LoanJournalLine."Processing Schema Code" = '' then
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, ProcessingSchemaBlankErr)
        else begin
            LoanJournalLine."Calculated Document Amount" := 0;
            Clear(CreateFundedDocuments);
            CreateFundedDocuments.CreateSingleDocument(LoanJournalLine, TempLoanDocument, TempLoanDocumentLine, true);
            TempLoanDocumentLine.Reset();
            TempLoanDocumentLine.SetRange("Balancing Entry", false);
            if TempLoanDocumentLine.FindSet() then begin
                repeat
                    LoanJournalLine."Calculated Document Amount" := LoanJournalLine."Calculated Document Amount" + TempLoanDocumentLine.Amount;
                until TempLoanDocumentLine.Next() = 0;
            end;
            LoanJournalLine.Modify();
        end;
        JournalValidationRule.Reset();
        JournalValidationRule.SetRange("Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
        if JournalValidationRule.FindSet() then begin
            ConditionsMgmt.FillJournalFieldValues(ExpressionValueBuffer, LoanJournalLine, FieldSequenceNo);
            repeat
                if not ValidateConditionLine(ExpressionValueBuffer, JournalValidationRule."Condition Code") then
                    LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, JournalValidationRule."Error Message");
            until JournalValidationRule.Next() = 0;
        end;
        if (TempLoanDocument."Customer No." = '') then
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, TitleCustomerNoMissingErr)
        else
            if not Customer.Get(TempLoanDocument."Customer No.") then
                LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, TitleCustomerNoMissingErr);
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
        ConditionMgmt: Codeunit lvngConditionsMgmt;
        ExpressionHeader: Record lvngExpressionHeader;
    begin
        ExpressionHeader.Get(ConditionCode, ConditionMgmt.GetConditionsMgmtConsumerId());
        exit(ExpressionEngine.CheckCondition(ExpressionHeader, ExpressionValueBuffer));
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not LoanVisionSetupRetrieved then begin
            LoanVisionSetup.Get();
            LoanVisionSetupRetrieved := true;
        end;
    end;
}