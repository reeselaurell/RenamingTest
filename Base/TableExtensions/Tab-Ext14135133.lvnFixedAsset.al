tableextension 14135133 "lvnFixedAsset" extends "Fixed Asset"
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
