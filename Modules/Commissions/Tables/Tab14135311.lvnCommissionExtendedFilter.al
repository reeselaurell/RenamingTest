table 14135311 lvnCommissionExtendedFilter
{
    Caption = 'Commission Extended Filter';
    DataClassification = CustomerContent;
    LookupPageId = lvnExtendedFilters;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Extended Filter"; Blob)
        {
            Caption = 'Filter';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description) { }
    }
}