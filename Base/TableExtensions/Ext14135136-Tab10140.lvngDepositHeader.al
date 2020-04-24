tableextension 14135136 lvngDepositHeader extends "Deposit Header"
{
    fields
    {
        field(14135999; lvngDocumentGuid; Guid) { DataClassification = CustomerContent; }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvngDocumentGuid = EmptyGuid then
            lvngDocumentGuid := CreateGuid();
    end;
}
