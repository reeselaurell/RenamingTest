table 14135314 "lvngCommissionReportTemplate"
{
    DataClassification = CustomerContent;
    Caption = 'Commission Reporting Template';
    LookupPageId = lvngCommissionReportTemplates;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(10; lvngDescription; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
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
        fieldgroup(DrowDown; lvngCode, lvngDescription)
        {

        }
    }
}