tableextension 14135134 "lvnBankRecHeader" extends "Bank Rec. Header"
{
    fields
    {
        field(14135999; lvnDocumentGuid; Guid) { DataClassification = CustomerContent; }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvnDocumentGuid = EmptyGuid then
            lvnDocumentGuid := CreateGuid();
    end;
}
