table 14135181 lvngExcelExportSetup
{
    Caption = 'Excel Export Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; DataClassification = CustomerContent; }
        field(10; "Base Url"; Text[250]) { Caption = 'Base Url'; DataClassification = CustomerContent; }
        field(11; "Access Key"; Text[250]) { Caption = 'Access Key'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}