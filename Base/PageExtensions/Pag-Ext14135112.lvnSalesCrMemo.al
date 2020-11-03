pageextension 14135112 "lvnSalesCrMemo" extends "Sales Credit Memo"
{
    layout
    {
        addfirst(factboxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox) { ApplicationArea = All; }
        }

        addlast(General)
        {
            field(lvnTotalAmount; Rec.lvnTotalAmount) { ApplicationArea = All; }
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
                    SalesFileImportManagement: codeunit lvnSalesFileImportManagement;
                    DocumentType: enum lvnLoanDocumentType;
                    GenJnlImportBuffer: Record lvnGenJnlImportBuffer temporary;
                    ImportBufferError: Record lvnImportBufferError temporary;
                    JournalDataImport: Page lvnJournalDataImport;
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
                        SalesFileImportManagement.CreateSalesLines(GenJnlImportBuffer, DocumentType::"Credit Memo", Rec."No.");
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