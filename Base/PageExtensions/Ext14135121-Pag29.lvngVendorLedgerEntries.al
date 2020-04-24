pageextension 14135121 lvngVendorLedgerEntries extends "Vendor Ledger Entries"
{
    layout
    {
        addfirst(factboxes)
        {
            part(DocumentExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
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
