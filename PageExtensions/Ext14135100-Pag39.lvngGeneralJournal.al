pageextension 14135100 lvngGeneralJournal extends "General Journal"
{
    layout
    {
        modify(ShortcutDimCode3) { Visible = true; }
        modify(ShortcutDimCode4) { Visible = true; }
        modify(ShortcutDimCode5) { Visible = true; }
        modify(ShortcutDimCode6) { Visible = true; }
        modify(ShortcutDimCode7) { Visible = true; }
        modify(ShortcutDimCode8) { Visible = true; }

        addlast(Control1)
        {
            field(lvngLoanNo; "Loan No.") { ApplicationArea = All; }
        }
    }

    actions
    {
        addafter(GetStandardJournals)
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
                    ImportGenJnlFile: Codeunit lvngGenJnlFileImportManagement;
                    GenJnlImportBuffer: Record lvngGenJnlImportBuffer temporary;
                    ImportBufferError: Record lvngImportBufferError temporary;
                    JournalDataImport: Page lvngJournalDataImport;
                begin
                    clear(ImportGenJnlFile);
                    if not ImportGenJnlFile.ManualFileImport(GenJnlImportBuffer, ImportBufferError) then
                        exit;
                    ImportBufferError.reset;
                    if not ImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(GenJnlImportBuffer, ImportBufferError);
                        JournalDataImport.Run();
                    end else
                        ImportGenJnlFile.CreateJournalLines(GenJnlImportBuffer, "Journal Template Name", "Journal Batch Name");
                    CurrPage.Update(false);
                end;
            }
        }
    }

}