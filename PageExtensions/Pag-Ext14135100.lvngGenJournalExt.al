pageextension 14135100 "lvngGenJournalExt" extends "General Journal"//MyTargetPageId
{
    layout
    {
        modify(ShortcutDimCode3)
        {
            Visible = true;
        }
        modify(ShortcutDimCode4)
        {
            Visible = true;
        }
        modify(ShortcutDimCode5)
        {
            Visible = true;
        }
        modify(ShortcutDimCode6)
        {
            Visible = true;
        }
        modify(ShortcutDimCode7)
        {
            Visible = true;
        }
        modify(ShortcutDimCode8)
        {
            Visible = true;
        }

        addlast(Control1)
        {
            field(lvngLoanNo; "Loan No.")
            {
                ApplicationArea = All;
            }
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
                    lvngImportGenJnlFile: codeunit lvngGenJnlFileImportManagement;
                    lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer temporary;
                    lvngImportBufferError: Record lvngImportBufferError temporary;
                    lvngJournalDataImport: Page lvngJournalDataImport;
                begin
                    clear(lvngImportGenJnlFile);
                    if not lvngImportGenJnlFile.ManualFileImport(lvngGenJnlImportBuffer, lvngImportBufferError) then
                        exit;
                    lvngImportBufferError.reset;
                    if not lvngImportBufferError.IsEmpty() then begin
                        clear(lvngJournalDataImport);
                        lvngJournalDataImport.SetParams(lvngGenJnlImportBuffer, lvngImportBufferError);
                        lvngJournalDataImport.Run();
                    end else begin
                        lvngImportGenJnlFile.CreateJournalLines(lvngGenJnlImportBuffer, "Journal Template Name", "Journal Batch Name");
                    end;
                    CurrPage.Update(false);
                end;
            }
        }
    }

}