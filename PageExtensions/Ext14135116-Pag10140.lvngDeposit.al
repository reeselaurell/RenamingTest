pageextension 14135116 "lvngDeposit" extends Deposit
{
    actions
    {
        addafter(PostAndPrint)
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
                    DepositFileImportMgmt: codeunit lvngDepositFileImportMgmt;
                    GenJnlImportBuffer: Record lvngGenJnlImportBuffer temporary;
                    ImportBufferError: Record lvngImportBufferError temporary;
                    JournalDataImport: Page lvngJournalDataImport;
                begin
                    Clear(DepositFileImportMgmt);
                    if not DepositFileImportMgmt.ManualFileImport(GenJnlImportBuffer, ImportBufferError) then
                        exit;
                    ImportBufferError.Reset();
                    if not ImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(GenJnlImportBuffer, ImportBufferError);
                        JournalDataImport.Run();
                    end else
                        DepositFileImportMgmt.CreateJournalLines(GenJnlImportBuffer, "No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }
}