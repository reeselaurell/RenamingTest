pageextension 14135109 "lvnPurchaseInvoice" extends "Purchase Invoice"
{
    layout
    {
        modify("Shipping and Payment")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Buy-from Contact")
        {
            Visible = false;
        }
        modify("No.")
        {
            Importance = Standard;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Buy-from Contact No.")
        {
            Visible = false;
        }
        modify("Electronic Invoice")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Tax Exemption No.")
        {
            Visible = false;
        }
        modify("Provincial Tax Area Code")
        {
            Visible = false;
        }
        modify("Payment Reference")
        {
            Visible = false;
        }
        modify("Due Date")
        {
            Importance = Additional;
        }
        modify("Assigned User ID")
        {
            Importance = Standard;
        }
        modify("Buy-from Vendor No.")
        {
            Importance = Standard;
        }
        modify("Purchaser Code")
        {
            Importance = Standard;
        }
        modify(Status)
        {
            Importance = Standard;
        }
        modify("Payment Method Code")
        {
            Importance = Standard;
        }
        addafter("Job Queue Status")
        {
            field(lvnLoanNo; Rec.lvnLoanNo)
            {
                ApplicationArea = All;
            }
            field(lvnDocumentTotalCheck; Rec.lvnDocumentTotalCheck)
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field(lvnTotalAmount; Rec.lvnTotalAmount)
            {
                ApplicationArea = All;
            }
        }
        addfirst(factboxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        modify(IncomingDocument)
        {
            Visible = false;
            Enabled = false;
        }
        addafter(CopyDocument)
        {
            action(lvnFileImport)
            {
                Caption = 'Import From File';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TempGenJnlImportBuffer: Record lvnGenJnlImportBuffer temporary;
                    TempImportBufferError: Record lvnImportBufferError temporary;
                    PurchFileImportManagement: Codeunit lvnPurchFileImportManagement;
                    JournalDataImport: Page lvnJournalDataImport;
                    DocumentType: Enum lvnLoanDocumentType;
                begin
                    Clear(PurchFileImportManagement);
                    if not PurchFileImportManagement.ManualFileImport(TempGenJnlImportBuffer, TempImportBufferError) then
                        exit;
                    TempImportBufferError.Reset();
                    if not TempImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(TempGenJnlImportBuffer, TempImportBufferError);
                        JournalDataImport.Run();
                    end else
                        PurchFileImportManagement.CreatePurchaseLines(TempGenJnlImportBuffer, DocumentType::Invoice, Rec."No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.lvnDocumentGuid := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentExchange.Page.ReloadDocuments(Rec.lvnDocumentGuid);
    end;
}