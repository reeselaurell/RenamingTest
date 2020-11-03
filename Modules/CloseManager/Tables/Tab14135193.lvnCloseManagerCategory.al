table 14135193 "lvnCloseManagerCategory"
{
    DataClassification = CustomerContent;
    Caption = 'Close Manager Category';

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(10; "Description"; Text[50]) { Caption = 'Description'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}