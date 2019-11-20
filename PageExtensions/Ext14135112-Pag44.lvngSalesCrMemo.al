pageextension 14135112 lvngSalesCrMemo extends "Sales Credit Memo"
{
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
                        SalesFileImportManagement.CreateSalesLines(GenJnlImportBuffer, DocumentType::"Credit Memo", "No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }
}