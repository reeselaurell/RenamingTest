pageextension 14135116 "lvngDeposit" extends Deposit
{
    layout
    {

    }

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
                    lvngDepositFileImportMgmt: codeunit lvngDepositFileImportMgmt;
                    lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer temporary;
                    lvngImportBufferError: Record lvngImportBufferError temporary;
                    lvngJournalDataImport: Page lvngJournalDataImport;
                begin
                    clear(lvngDepositFileImportMgmt);
                    if not lvngDepositFileImportMgmt.ManualFileImport(lvngGenJnlImportBuffer, lvngImportBufferError) then
                        exit;
                    lvngImportBufferError.reset;
                    if not lvngImportBufferError.IsEmpty() then begin
                        clear(lvngJournalDataImport);
                        lvngJournalDataImport.SetParams(lvngGenJnlImportBuffer, lvngImportBufferError);
                        lvngJournalDataImport.Run();
                    end else begin
                        lvngDepositFileImportMgmt.CreateJournalLines(lvngGenJnlImportBuffer, "No.");
                    end;
                    CurrPage.Update(false);
                end;
            }
        }
    }
}