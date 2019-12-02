pageextension 14135109 lvngPurchaseInvoice extends "Purchase Invoice"
{
    layout
    {
        modify("Shipping and Payment") { Visible = false; }
        modify("Foreign Trade") { Visible = false; }
        modify("Buy-from Contact") { Visible = false; }
        modify("No.") { Importance = Standard; }
        modify("Responsibility Center") { Visible = false; }
        modify("Order Address Code") { Visible = false; }
        modify("Campaign No.") { Visible = false; }
        modify("Buy-from Contact No.") { Visible = false; }
        modify("Electronic Invoice") { Visible = false; }
        modify("Creditor No.") { Visible = false; }
        modify("Shipment Method Code") { Visible = false; }
        modify("Pmt. Discount Date") { Visible = false; }
        modify("Payment Discount %") { Visible = false; }
        modify("Expected Receipt Date") { Visible = false; }
        modify("Currency Code") { Visible = false; }
        modify("Due Date") { Importance = Additional; }
        modify("Assigned User ID") { Importance = Standard; }
        modify("Buy-from Vendor No.") { Importance = Standard; }
        modify("Purchaser Code") { Importance = Standard; }
        modify(Status) { Importance = Standard; }
        modify("Payment Method Code") { Importance = Standard; }

        addafter("Job Queue Status")
        {
            field(lvngLoanNo; lvngLoanNo) { ApplicationArea = All; }
            field(lvngDocumentTotalCheck; lvngDocumentTotalCheck) { ApplicationArea = All; }
        }
    }

    actions
    {
        modify(IncomingDocument) { Visible = false; Enabled = false; }
        addafter(CopyDocument)
        {
            action(lvngFileImport)
            {
                Caption = 'Import From File';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchFileImportManagement: Codeunit lvngPurchFileImportManagement;
                    DocumentType: enum lvngLoanDocumentType;
                    GenJnlImportBuffer: Record lvngGenJnlImportBuffer temporary;
                    ImportBufferError: Record lvngImportBufferError temporary;
                    JournalDataImport: Page lvngJournalDataImport;
                begin
                    Clear(PurchFileImportManagement);
                    if not PurchFileImportManagement.ManualFileImport(GenJnlImportBuffer, ImportBufferError) then
                        exit;
                    ImportBufferError.Reset();
                    if not ImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(GenJnlImportBuffer, ImportBufferError);
                        JournalDataImport.Run();
                    end else
                        PurchFileImportManagement.CreatePurchaseLines(GenJnlImportBuffer, DocumentType::Invoice, "No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }
}