codeunit 14135111 "lvngLoanVoidDocument"
{
    local procedure CreateFundedVoidDocument(lvngLoanFundedDocument: record lvngLoanFundedDocument; ShowConfirmation: Boolean)
    var
        lvngLoanDocument: Record lvngLoanDocument;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
        lvngLoanFundedDocumentLine: Record lvngLoanFundedDocumentLine;
        ConfirmationDialogLbl: Label 'Do you want to create Void document for %1?';

    begin
        if ShowConfirmation then begin
            if not Confirm(ConfirmationDialogLbl, false, lvngLoanFundedDocument.lvngDocumentNo) then
                exit;
        end;

    end;


}