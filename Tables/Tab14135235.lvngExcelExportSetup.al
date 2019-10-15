table 14135235 lvngExcelExportSetup
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { DataClassification = CustomerContent; }
        field(10; "Base Url"; Text[250]) { DataClassification = CustomerContent; }
        field(11; "Access Key"; Text[250]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}