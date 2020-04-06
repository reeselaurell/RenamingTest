pageextension 14135111 lvngSalesInvoice extends "Sales Invoice"
{
    layout
    {
        addfirst(factboxes)
        {
            part(DocumentExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
        }

        addlast(General)
        {
            field(lvngTotalAmount; lvngTotalAmount) { ApplicationArea = All; }
        }
    }

    actions
    {
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
                    SalesFileImportManagement: codeunit lvngSalesFileImportManagement;
                    DocumentType: enum lvngLoanDocumentType;
                    GenJnlImportBuffer: Record lvngGenJnlImportBuffer temporary;
                    ImportBufferError: Record lvngImportBufferError temporary;
                    JournalDataImport: Page lvngJournalDataImport;
                begin
                    Clear(SalesFileImportManagement);
                    if not SalesFileImportManagement.ManualFileImport(GenJnlImportBuffer, ImportBufferError) then
                        exit;
                    ImportBufferError.Reset();
                    if not ImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(GenJnlImportBuffer, ImportBufferError);
                        JournalDataImport.Run();
                    end else
                        SalesFileImportManagement.CreateSalesLines(GenJnlImportBuffer, DocumentType::Invoice, "No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        lvngDocumentGuid := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentExchange.Page.ReloadDocuments(lvngDocumentGuid);
    end;
}