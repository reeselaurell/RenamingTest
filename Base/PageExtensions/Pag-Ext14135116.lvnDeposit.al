pageextension 14135116 "lvnDeposit" extends Deposit
{
    layout
    {
        modify("Currency Code") { Visible = false; }

        addfirst(factboxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox) { ApplicationArea = All; }
        }
    }

    actions
    {
        addafter(PostAndPrint)
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
                    DepositFileImportMgmt: codeunit lvnDepositFileImportMgmt;
                    GenJnlImportBuffer: Record lvnGenJnlImportBuffer temporary;
                    ImportBufferError: Record lvnImportBufferError temporary;
                    JournalDataImport: Page lvnJournalDataImport;
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
                        DepositFileImportMgmt.CreateJournalLines(GenJnlImportBuffer, Rec."No.");
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