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
        lvngLoanJournalLine.SetRange("Loan Journal Batch Code", lvngJournalBatchCode);
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
        if lvngLoanJournalLine."Loan No." = '' then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, LoanNoEmptyLbl);
        if (lvngLoanVisionSetup."Funded Void Reason Code" <> '') and
            (lvngLoanVisionSetup."Funded Void Reason Code" = lvngLoanJournalLine."Reason Code") then begin
            lvngLoanDocument.reset;
            lvngLoanDocument.SetRange(Void, true);
            lvngLoanDocument.SetRange("Loan No.", lvngLoanJournalLine."Loan No.");
            lvngLoanDocument.SetRange("Transaction Type", lvngLoanDocument."Transaction Type"::Funded);
            if not lvngLoanDocument.IsEmpty() then begin
                lvngLoanDocument.FindFirst();
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(NonPostedVoidDocumentExistsLbl, lvngLoanDocument."Document No."));
            end;
            lvngLoanFundedDocument.reset;
            lvngLoanFundedDocument.SetRange("Loan No.", lvngLoanJournalLine."Loan No.");
            lvngLoanFundedDocument.SetRange(Void, false);
            if lvngLoanFundedDocument.IsEmpty() then begin
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, NothingToVoidLbl);
            end;
            exit;
        end else begin
            lvngLoanDocument.reset;
            lvngLoanDocument.SetRange(Void, false);
            lvngLoanDocument.SetRange("Loan No.", lvngLoanJournalLine."Loan No.");
            lvngLoanDocument.SetRange("Transaction Type", lvngLoanDocument."Transaction Type"::Funded);
            if not lvngLoanDocument.IsEmpty() then begin
                lvngLoanDocument.FindFirst();
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(NonPostedDocumentExistsLbl, lvngLoanDocument."Document No."));
            end;
            lvngLoanFundedDocument.reset;
            lvngLoanFundedDocument.SetRange("Loan No.", lvngLoanJournalLine."Loan No.");
            lvngLoanFundedDocument.SetRange(Void, false);
            if not lvngLoanFundedDocument.IsEmpty() then begin
                lvngFundedDocumentsCount := lvngLoanFundedDocument.Count();
                lvngLoanFundedDocument.SetRange(Void, true);
                lvngVoidedDocumentsCount := lvngLoanFundedDocument.Count();
                if (lvngFundedDocumentsCount <> lvngVoidedDocumentsCount) then begin
                    lvngLoanFundedDocument.SetRange(Void, false);
                    lvngLoanFundedDocument.FindLast();
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(PostedDocumentExistsLbl, lvngLoanFundedDocument."Document No."));
                end;
            end;
        end;
        if lvngLoanJournalLine."Date Funded" = 0D then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, FundedDateBlankLbl);
        if lvngLoanJournalLine."Search Name" = '' then begin
            GetLoanVisionSetup();
            lvngLoanJournalLine."Search Name" := StrSubstNo(lvngLoanVisionSetup."Search Name Template", lvngLoanJournalLine."Borrower First Name", lvngLoanJournalLine."Borrower Last Name", lvngLoanJournalLine."Borrower Middle Name");
            if DelChr(lvngLoanJournalLine."Search Name", '=', ', ') = '' then
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, SearchNameBlankLbl) else
                lvngLoanJournalLine.Modify();
        end;
        if lvngLoanJournalLine."Processing Schema Code" = '' then begin
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, ProcessingSchemaBlankLbl)
        end else begin
            clear(lvngLoanJournalLine."Calculated Document Amount");
            Clear(lvngCreateFundedDocuments);
            lvngCreateFundedDocuments.CreateSingleDocument(lvngLoanJournalLine, lvngLoanDocumentTemp, lvngLoanDocumentLine, true);
            lvngLoanDocumentLine.reset;
            lvngLoanDocumentLine.SetRange("Balancing Entry", false);
            if lvngLoanDocumentLine.FindSet() then begin
                repeat
                    lvngLoanJournalLine."Calculated Document Amount" := lvngLoanJournalLine."Calculated Document Amount" + lvngLoanDocumentLine.Amount;
                until lvngLoanDocumentLine.Next() = 0;
            end;
            lvngLoanJournalLine.Modify()
        end;
        lvngJournalValidationRule.reset;
        lvngJournalValidationRule.SetRange("Journal Batch Code", lvngLoanJournalLine."Loan Journal Batch Code");
        if lvngJournalValidationRule.FindSet() then begin
            lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
            repeat
                if not ValidateConditionLine(lvngExpressionValueBuffer, lvngJournalValidationRule."Condition Code") then begin
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, lvngJournalValidationRule."Error Message");
                end;
            until lvngJournalValidationRule.Next() = 0;
        end;
        if (lvngLoanDocumentTemp."Customer No." = '') then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, TitleCustomerNoMissingLbl) else begin
            if not Customer.get(lvngLoanDocumentTemp."Customer No.") then
                lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, TitleCustomerNoMissingLbl);
        end;
        lvngLoanDocumentLine.reset;
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                if lvngLoanDocumentLine."Reason Code" = '' then begin
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(ReasonCodeMissingOnLineLbl, lvngLoanDocumentLine."Line No."));
                end;
                if lvngLoanDocumentLine."Account No." = '' then begin
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, strsubstno(AccountNoMissingOnLineLbl, lvngLoanDocumentLine."Line No."));
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