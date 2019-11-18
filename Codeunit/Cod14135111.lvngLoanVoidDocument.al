codeunit 14135111 "lvngLoanVoidDocument"
{
    procedure CreateFundedVoidDocument(lvngLoanFundedDocument: record lvngLoanFundedDocument; ShowConfirmation: Boolean)
    var
        lvngLoanDocument: Record lvngLoanDocument;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
        lvngLoanFundedDocumentLine: Record lvngLoanFundedDocumentLine;
        ConfirmationDialogLbl: Label 'Do you want to create Void document for %1?';
    begin
        GetLoanVisionSetup();
        lvngLoanVisionSetup.TestField("Void Funded No. Series");
        if ShowConfirmation then begin
            if not Confirm(ConfirmationDialogLbl, false, lvngLoanFundedDocument."Document No.") then
                exit;
        end;
        Clear(lvngLoanDocument);
        lvngLoanDocument.TransferFields(lvngLoanFundedDocument);
        lvngLoanDocument."Transaction Type" := lvngLoanDocument."Transaction Type"::Funded;
        lvngLoanDocument."Document No." := NoSeriesMgmt.DoGetNextNo(lvngLoanVisionSetup."Void Funded No. Series", TODAY, true, true);
        if lvngLoanFundedDocument."Document Type" = lvngLoanFundedDocument."Document Type"::"Credit Memo" then
            lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::Invoice else
            lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::"Credit Memo";
        lvngLoanDocument.Void := true;
        lvngLoanDocument."Void Document No." := lvngLoanFundedDocument."Document No.";
        lvngLoanDocument.Insert();
        lvngLoanFundedDocumentLine.reset;
        lvngLoanFundedDocumentLine.SetRange("Document No.", lvngLoanFundedDocument."Document No.");
        if lvngLoanFundedDocumentLine.FindSet() then begin
            repeat
                Clear(lvngLoanDocumentLine);
                lvngLoanDocumentLine.TransferFields(lvngLoanFundedDocumentLine);
                lvngLoanDocumentLine."Transaction Type" := lvngLoanDocument."Transaction Type";
                lvngLoanDocumentLine."Document No." := lvngLoanDocument."Document No.";
                lvngLoanDocumentLine."Reason Code" := lvngLoanVisionSetup."Funded Void Reason Code";
                lvngLoanDocumentLine.Amount := -lvngLoanDocumentLine.Amount;
                lvngLoanDocumentLine.Insert();
            until lvngLoanFundedDocumentLine.Next() = 0;
        end;
    end;

    procedure CreateSoldVoidDocument(lvngLoanSoldDocument: record lvngLoanSoldDocument; ShowConfirmation: Boolean)
    var
        lvngLoanDocument: Record lvngLoanDocument;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
        lvngLoanSoldDocumentLine: Record lvngLoanSoldDocumentLine;
        ConfirmationDialogLbl: Label 'Do you want to create Void document for %1?';
    begin
        GetLoanVisionSetup();
        lvngLoanVisionSetup.TestField("Void Funded No. Series");
        if ShowConfirmation then begin
            if not Confirm(ConfirmationDialogLbl, false, lvngLoanSoldDocument."Document No.") then
                exit;
        end;
        Clear(lvngLoanDocument);
        lvngLoanDocument.TransferFields(lvngLoanSoldDocument);
        lvngLoanDocument."Transaction Type" := lvngLoanDocument."Transaction Type"::Funded;
        lvngLoanDocument."Document No." := NoSeriesMgmt.DoGetNextNo(lvngLoanVisionSetup."Void Funded No. Series", TODAY, true, true);
        if lvngLoanSoldDocument."Document Type" = lvngLoanSoldDocument."Document Type"::"Credit Memo" then
            lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::Invoice else
            lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::"Credit Memo";
        lvngLoanDocument.Void := true;
        lvngLoanDocument."Void Document No." := lvngLoanSoldDocument."Document No.";
        lvngLoanDocument.Insert();
        lvngLoanSoldDocumentLine.reset;
        lvngLoanSoldDocumentLine.SetRange("Document No.", lvngLoanSoldDocument."Document No.");
        if lvngLoanSoldDocumentLine.FindSet() then begin
            repeat
                Clear(lvngLoanDocumentLine);
                lvngLoanDocumentLine.TransferFields(lvngLoanSoldDocumentLine);
                lvngLoanDocumentLine."Transaction Type" := lvngLoanDocument."Transaction Type";
                lvngLoanDocumentLine."Document No." := lvngLoanDocument."Document No.";
                lvngLoanDocumentLine."Reason Code" := lvngLoanVisionSetup."Funded Void Reason Code";
                lvngLoanDocumentLine.Amount := -lvngLoanDocumentLine.Amount;
                lvngLoanDocumentLine.Insert();
            until lvngLoanSoldDocumentLine.Next() = 0;
        end;
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetupRetrieved := true;
            lvngLoanVisionSetup.Get();
        end;
    end;

    var
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        lvngLoanVisionSetupRetrieved: Boolean;


}