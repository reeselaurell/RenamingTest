table 14135314 lvnCommissionReportTemplate
{
    DataClassification = CustomerContent;
    Caption = 'Commission Reporting Template';
    LookupPageId = lvnCommissionReportTemplates;

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
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DrowDown; Code, Description) { }
    }
}