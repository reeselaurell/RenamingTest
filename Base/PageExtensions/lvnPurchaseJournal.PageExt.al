pageextension 14135107 "lvnPurchaseJournal" extends "Purchase Journal"
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
        modify("Reason Code")
        {
            Visible = true;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Debit Amount")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        addlast(Control1)
        {
            field(lvnLoanNo; Rec.lvnLoanNo)
            {
                ApplicationArea = All;
            }
        }
        addfirst(factboxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Insert Conv. LCY Rndg. Lines")
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
                    TempGenJnlImportBuffer: Record lvnGenJnlImportBuffer temporary;
                    TempImportBufferError: Record lvnImportBufferError temporary;
                    ImportGenJnlFile: Codeunit lvnGenJnlFileImportManagement;
                    JournalDataImport: Page lvnJournalDataImport;
                begin
                    Clear(ImportGenJnlFile);
                    if not ImportGenJnlFile.ManualFileImport(TempGenJnlImportBuffer, TempImportBufferError) then
                        exit;
                    TempImportBufferError.Reset();
                    if not TempImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(TempGenJnlImportBuffer, TempImportBufferError);
                        JournalDataImport.Run();
                    end else
                        ImportGenJnlFile.CreateJournalLines(TempGenJnlImportBuffer, Rec."Journal Template Name", Rec."Journal Batch Name", CreateGuid());
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