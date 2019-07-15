table 14135101 "lvngWarehouseLine"
{
    DataClassification = CustomerContent;
    LookupPageId = lvngWarehouseLines;

    fields
    {
        field(1; lvngCode; Code[50])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(10; lvngDescription; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(11; lvngShowInRolecenter; Boolean)
        {
            Caption = 'Show in Rolecenter';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }


    fieldgroups
    {
        fieldgroup(DropDown; lvngCode, lvngDescription)
        {

        }
        fieldgroup(Brick; lvngCode, lvngDescription)
        {

        }
    }

}