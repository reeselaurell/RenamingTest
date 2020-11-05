pageextension 14135100 "lvnGeneralJournal" extends "General Journal"
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
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Bal. Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Reason Code")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("Debit Amount")
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
        addafter(GetStandardJournals)
        {
            action(lvnMappedImport)
            {
                Caption = 'Import (Mapped)';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJnlImportBuffer: Record lvnGenJnlImportBuffer temporary;
                    ImportBufferError: Record lvnImportBufferError temporary;
                    ImportGenJnlFile: Codeunit lvnGenJnlFileImportManagement;
                    JournalDataImport: Page lvnJournalDataImport;
                begin
                    Clear(ImportGenJnlFile);
                    if not ImportGenJnlFile.ManualFileImport(GenJnlImportBuffer, ImportBufferError) then
                        exit;
                    ImportBufferError.Reset();
                    if not ImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(GenJnlImportBuffer, ImportBufferError);
                        JournalDataImport.Run();
                    end else
                        ImportGenJnlFile.CreateJournalLines(GenJnlImportBuffer, Rec."Journal Template Name", Rec."Journal Batch Name", CreateGuid());
                    CurrPage.Update(false);
                end;
            }
            action(lvnFlexibleImport)
            {
                Caption = 'Import (Flexible)';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Import;

                trigger OnAction()
                var
                    GenJnlImportBuffer: Record lvnGenJnlImportBuffer temporary;
                    ImportBufferError: Record lvnImportBufferError temporary;
                    GenJnlFlexImportMgmt: Codeunit lvnGenJnlFlexImportManagement;
                    JournalDataImport: Page lvnJournalDataImport;
                begin
                    Clear(GenJnlFlexImportMgmt);
                    if not GenJnlFlexImportMgmt.ManualFileImport(GenJnlImportBuffer, ImportBufferError) then
                        exit;
                    if not ImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(GenJnlImportBuffer, ImportBufferError);
                        JournalDataImport.Run();
                    end else
                        GenJnlFlexImportMgmt.CreateJournalLines(GenJnlImportBuffer, Rec."Journal Template Name", Rec."Journal Batch Name", CreateGuid());
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