pageextension 14135112 "lvngSalesCrMemo" extends "Sales Credit Memo"
{
    layout
    {

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
                    lvngSalesFileImportManagement: codeunit lvngSalesFileImportManagement;
                    lvngDocumentType: enum lvngLoanDocumentType;
                    lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer temporary;
                    lvngImportBufferError: Record lvngImportBufferError temporary;
                    lvngJournalDataImport: Page lvngJournalDataImport;
                begin
                    clear(lvngSalesFileImportManagement);
                    if not lvngSalesFileImportManagement.ManualFileImport(lvngGenJnlImportBuffer, lvngImportBufferError) then
                        exit;
                    lvngImportBufferError.reset;
                    if not lvngImportBufferError.IsEmpty() then begin
                        clear(lvngJournalDataImport);
                        lvngJournalDataImport.SetParams(lvngGenJnlImportBuffer, lvngImportBufferError);
                        lvngJournalDataImport.Run();
                    end else begin
                        lvngSalesFileImportManagement.CreateSalesLines(lvngGenJnlImportBuffer, lvngDocumentType::"Credit Memo", "No.");
                    end;
                    CurrPage.Update(false);
                end;
            }
        }
    }
}