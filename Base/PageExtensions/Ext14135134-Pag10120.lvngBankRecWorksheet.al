pageextension 14135134 lvngBankRecWorksheet extends "Bank Rec. Worksheet"
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