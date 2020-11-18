pageextension 14135112 "lvnSalesCrMemo" extends "Sales Credit Memo"
{
    layout
    {
        addfirst(factboxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox)
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field(lvnTotalAmount; Rec.lvnTotalAmount)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(CopyDocument)
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
                    SalesFileImportManagement: Codeunit lvnSalesFileImportManagement;
                    JournalDataImport: Page lvnJournalDataImport;
                    DocumentType: Enum lvnLoanDocumentType;
                begin
                    Clear(SalesFileImportManagement);
                    if not SalesFileImportManagement.ManualFileImport(TempGenJnlImportBuffer, TempImportBufferError) then
                        exit;
                    TempImportBufferError.Reset();
                    if not TempImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(TempGenJnlImportBuffer, TempImportBufferError);
                        JournalDataImport.Run();
                    end else
                        SalesFileImportManagement.CreateSalesLines(TempGenJnlImportBuffer, DocumentType::"Credit Memo", Rec."No.");
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