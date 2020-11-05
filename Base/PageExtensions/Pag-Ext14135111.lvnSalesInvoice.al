pageextension 14135111 "lvnSalesInvoice" extends "Sales Invoice"
{
    layout
    {
        addfirst(factboxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox)
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
    }

    actions
    {
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
                    GenJnlImportBuffer: Record lvnGenJnlImportBuffer temporary;
                    ImportBufferError: Record lvnImportBufferError temporary;
                    SalesFileImportManagement: Codeunit lvnSalesFileImportManagement;
                    JournalDataImport: Page lvnJournalDataImport;
                    DocumentType: Enum lvnLoanDocumentType;
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
                        SalesFileImportManagement.CreateSalesLines(GenJnlImportBuffer, DocumentType::Invoice, Rec."No.");
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