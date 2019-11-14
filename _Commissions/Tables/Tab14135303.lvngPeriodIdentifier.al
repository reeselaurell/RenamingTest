table 14135303 "lvngPeriodIdentifier"
{
    Caption = 'Period Identifier';
    DataClassification = CustomerContent;
    LookupPageId = lvngPeriodIdentifiers;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; lvngDescription; Text[100])
        {
            Caption = 'Description';
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
        fieldgroup(DropDown; lvngCode, lvngDescription) { }
    }


}