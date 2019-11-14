table 14135101 lvngWarehouseLine
{
    DataClassification = CustomerContent;
    LookupPageId = lvngWarehouseLines;

    fields
    {
        field(1; Code; Code[50]) { DataClassification = CustomerContent; NotBlank = true; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
        field(11; "Show In Rolecenter"; Boolean) { Caption = 'Show in Rolecenter'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description) { }
        fieldgroup(Brick; Code, Description) { }
    }
}