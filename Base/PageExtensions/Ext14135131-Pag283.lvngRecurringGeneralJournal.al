pageextension 14135131 lvngRecurringGeneralJournal extends "Recurring General Journal"
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
        Rec.lvngDocumentGuid := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentExchange.Page.ReloadDocuments(Rec.lvngDocumentGuid);
    end;
}