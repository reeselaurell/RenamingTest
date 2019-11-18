pageextension 14135110 "lvngPurchaseCrMemo" extends "Purchase Credit Memo" //MyTargetPageId
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
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }

        addafter("Job Queue Status")
        {
            field(lvngLoanNo; lvngLoanNo)
            {
                ApplicationArea = All;
            }
            field(lvngDocumentTotalCheck; lvngDocumentTotalCheck)
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
        addafter(Post)
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
                    lvngPurchFileImportManagement: codeunit lvngPurchFileImportManagement;
                    lvngDocumentType: enum lvngLoanDocumentType;
                    lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer temporary;
                    lvngImportBufferError: Record lvngImportBufferError temporary;
                    lvngJournalDataImport: Page lvngJournalDataImport;
                begin
                    clear(lvngPurchFileImportManagement);
                    if not lvngPurchFileImportManagement.ManualFileImport(lvngGenJnlImportBuffer, lvngImportBufferError) then
                        exit;
                    lvngImportBufferError.reset;
                    if not lvngImportBufferError.IsEmpty() then begin
                        clear(lvngJournalDataImport);
                        lvngJournalDataImport.SetParams(lvngGenJnlImportBuffer, lvngImportBufferError);
                        lvngJournalDataImport.Run();
                    end else begin
                        lvngPurchFileImportManagement.CreatePurchaseLines(lvngGenJnlImportBuffer, lvngDocumentType::"Credit Memo", "No.");
                    end;
                    CurrPage.Update(false);
                end;
            }
        }
    }
}