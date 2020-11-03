pageextension 14135130 "lvnCashReceiptJournal" extends "Cash Receipt Journal"
{
    layout
    {
        modify("Reason Code") { Visible = true; }
        modify("Credit Amount") { Visible = true; }
        modify("Debit Amount") { Visible = true; }

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