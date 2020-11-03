pageextension 14135119 "lvnCustomerLedgerEntries" extends "Customer Ledger Entries"
{
    layout
    {
        addfirst(factboxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox) { ApplicationArea = All; }
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
