tableextension 14135132 "lvnBankAccount" extends "Bank Account"
{
    fields
    {
        field(14135999; lvnDocumentGuid; Guid)
        {
            DataClassification = CustomerContent;
        }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvnDocumentGuid = EmptyGuid then
            lvnDocumentGuid := CreateGuid();
    end;
}