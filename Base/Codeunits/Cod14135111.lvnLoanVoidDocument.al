codeunit 14135111 "lvnLoanVoidDocument"
{
    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        LoanVisionSetupRetrieved: Boolean;
        ConfirmationDialogLbl: Label 'Do you want to create Void document for %1?';

    procedure CreateFundedVoidDocument(LoanFundedDocument: Record lvnLoanFundedDocument; ShowConfirmation: Boolean)
    var
        LoanDocument: Record lvnLoanDocument;
        LoanDocumentLine: Record lvnLoanDocumentLine;
        LoanFundedDocumentLine: Record lvnLoanFundedDocumentLine;
    begin
        GetLoanVisionSetup();
        LoanVisionSetup.TestField("Void Funded No. Series");
        if ShowConfirmation then
            if not Confirm(ConfirmationDialogLbl, false, LoanFundedDocument."Document No.") then
                exit;
        Clear(LoanDocument);
        LoanDocument.TransferFields(LoanFundedDocument);
        LoanDocument."Transaction Type" := LoanDocument."Transaction Type"::Funded;
        LoanDocument."Document No." := NoSeriesMgmt.DoGetNextNo(LoanVisionSetup."Void Funded No. Series", Today(), true, true);
        if LoanFundedDocument."Document Type" = LoanFundedDocument."Document Type"::"Credit Memo" then
            LoanDocument."Document Type" := LoanDocument."Document Type"::Invoice
        else
            LoanDocument."Document Type" := LoanDocument."Document Type"::"Credit Memo";
        LoanDocument.Void := true;
        LoanDocument."Void Document No." := LoanFundedDocument."Document No.";
        LoanDocument.Insert();
        LoanFundedDocumentLine.Reset();
        LoanFundedDocumentLine.SetRange("Document No.", LoanFundedDocument."Document No.");
        if LoanFundedDocumentLine.FindSet() then
            repeat
                Clear(LoanDocumentLine);
                LoanDocumentLine.TransferFields(LoanFundedDocumentLine);
                LoanDocumentLine."Transaction Type" := LoanDocument."Transaction Type";
                LoanDocumentLine."Document No." := LoanDocument."Document No.";
                LoanDocumentLine."Reason Code" := LoanVisionSetup."Funded Void Reason Code";
                LoanDocumentLine.Amount := -LoanDocumentLine.Amount;
                LoanDocumentLine.Insert();
            until LoanFundedDocumentLine.Next() = 0;
    end;

    procedure CreateSoldVoidDocument(LoanSoldDocument: Record lvnLoanSoldDocument; ShowConfirmation: Boolean)
    var
        LoanDocument: Record lvnLoanDocument;
        LoanDocumentLine: Record lvnLoanDocumentLine;
        LoanSoldDocumentLine: Record lvnLoanSoldDocumentLine;
    begin
        GetLoanVisionSetup();
        LoanVisionSetup.TestField("Void Funded No. Series");
        if ShowConfirmation then
            if not Confirm(ConfirmationDialogLbl, false, LoanSoldDocument."Document No.") then
                exit;
        Clear(LoanDocument);
        LoanDocument.TransferFields(LoanSoldDocument);
        LoanDocument."Transaction Type" := LoanDocument."Transaction Type"::Funded;
        LoanDocument."Document No." := NoSeriesMgmt.DoGetNextNo(LoanVisionSetup."Void Funded No. Series", Today(), true, true);
        if LoanSoldDocument."Document Type" = LoanSoldDocument."Document Type"::"Credit Memo" then
            LoanDocument."Document Type" := LoanDocument."Document Type"::Invoice
        else
            LoanDocument."Document Type" := LoanDocument."Document Type"::"Credit Memo";
        LoanDocument.Void := true;
        LoanDocument."Void Document No." := LoanSoldDocument."Document No.";
        LoanDocument.Insert();
        LoanSoldDocumentLine.Reset();
        LoanSoldDocumentLine.SetRange("Document No.", LoanSoldDocument."Document No.");
        if LoanSoldDocumentLine.FindSet() then
            repeat
                Clear(LoanDocumentLine);
                LoanDocumentLine.TransferFields(LoanSoldDocumentLine);
                LoanDocumentLine."Transaction Type" := LoanDocument."Transaction Type";
                LoanDocumentLine."Document No." := LoanDocument."Document No.";
                LoanDocumentLine."Reason Code" := LoanVisionSetup."Funded Void Reason Code";
                LoanDocumentLine.Amount := -LoanDocumentLine.Amount;
                LoanDocumentLine.Insert();
            until LoanSoldDocumentLine.Next() = 0;
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not LoanVisionSetupRetrieved then begin
            LoanVisionSetupRetrieved := true;
            LoanVisionSetup.Get();
        end;
    end;
}