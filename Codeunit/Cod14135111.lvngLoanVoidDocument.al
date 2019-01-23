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
        lvngLoanVisionSetup.TestField(lvngVoidFundedNoSeries);
        if ShowConfirmation then begin
            if not Confirm(ConfirmationDialogLbl, false, lvngLoanFundedDocument.lvngDocumentNo) then
                exit;
        end;
        Clear(lvngLoanDocument);
        lvngLoanDocument.TransferFields(lvngLoanFundedDocument);
        lvngLoanDocument.lvngTransactionType := lvngLoanDocument.lvngTransactionType::lvngFunded;
        lvngLoanDocument.lvngDocumentNo := NoSeriesMgmt.DoGetNextNo(lvngLoanVisionSetup.lvngVoidFundedNoSeries, TODAY, true, true);
        if lvngLoanFundedDocument.lvngDocumentType = lvngLoanFundedDocument.lvngDocumentType::lvngCreditMemo then
            lvngLoanDocument.lvngDocumentType := lvngLoanDocument.lvngDocumentType::lvngInvoice else
            lvngLoanDocument.lvngDocumentType := lvngLoanDocument.lvngDocumentType::lvngCreditMemo;
        lvngLoanDocument.lvngVoid := true;
        lvngLoanDocument.lvngVoidDocumentNo := lvngLoanFundedDocument.lvngDocumentNo;
        lvngLoanDocument.Insert();
        lvngLoanFundedDocumentLine.reset;
        lvngLoanFundedDocumentLine.SetRange(lvngDocumentNo, lvngLoanFundedDocument.lvngDocumentNo);
        if lvngLoanFundedDocumentLine.FindSet() then begin
            repeat
                Clear(lvngLoanDocumentLine);
                lvngLoanDocumentLine.TransferFields(lvngLoanFundedDocumentLine);
                lvngLoanDocumentLine.lvngTransactionType := lvngLoanDocument.lvngTransactionType;
                lvngLoanDocumentLine.lvngDocumentNo := lvngLoanDocument.lvngDocumentNo;
                lvngLoanDocumentLine.lvngReasonCode := lvngLoanVisionSetup.lvngFundedVoidReasonCode;
                lvngLoanDocumentLine.lvngAmount := -lvngLoanDocumentLine.lvngAmount;
                lvngLoanDocumentLine.Insert();
            until lvngLoanFundedDocumentLine.Next() = 0;
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