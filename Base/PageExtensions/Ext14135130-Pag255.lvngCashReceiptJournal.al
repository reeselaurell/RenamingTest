pageextension 14135130 lvngCashReceiptJournal extends "Cash Receipt Journal"
{
    layout
    {
        modify("Reason Code") { Visible = true; }
        modify("Credit Amount") { Visible = true; }
        modify("Debit Amount") { Visible = true; }

        addfirst(factboxes)
        {
            part(DocumentExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
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