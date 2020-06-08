pageextension 14135107 lvngPurchaseJournal extends "Purchase Journal"
{
    layout
    {
        modify(ShortcutDimCode3) { Visible = true; }
        modify(ShortcutDimCode4) { Visible = true; }
        modify(ShortcutDimCode5) { Visible = true; }
        modify(ShortcutDimCode6) { Visible = true; }
        modify(ShortcutDimCode7) { Visible = true; }
        modify(ShortcutDimCode8) { Visible = true; }
        modify("Reason Code") { Visible = true; }
        modify("Currency Code") { Visible = false; }

        addlast(Control1)
        {
            field(lvngLoanNo; lvngLoanNo) { ApplicationArea = All; }
        }

        addfirst(factboxes)
        {
            part(DocumentExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
        }
    }

    actions
    {
        addafter("Insert Conv. LCY Rndg. Lines")
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
                    ImportBufferError.Reset();
                    if not ImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(GenJnlImportBuffer, ImportBufferError);
                        JournalDataImport.Run();
                    end else
                        ImportGenJnlFile.CreateJournalLines(GenJnlImportBuffer, "Journal Template Name", "Journal Batch Name", CreateGuid());
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