table 14135311 "lvngCommissionExtendedFilter"
{
    Caption = 'Commission Extended Filter';
    DataClassification = CustomerContent;
    LookupPageId = lvngExtendedFilters;

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
        field(11; lvngFilter; Blob)
        {
            Caption = 'Filter';
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