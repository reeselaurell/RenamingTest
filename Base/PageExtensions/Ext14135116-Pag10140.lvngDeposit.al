pageextension 14135116 lvngDeposit extends Deposit
{
    layout
    {
        modify("Currency Code") { Visible = false; }

        addfirst(factboxes)
        {
            part(DocumentExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
        }
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
                        DepositFileImportMgmt.CreateJournalLines(GenJnlImportBuffer, Rec."No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.lvngDocumentGuid := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentExchange.Page.ReloadDocuments(Rec.lvngDocumentGuid);
    end;
}