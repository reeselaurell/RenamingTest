table 14135900 lvngDocumentExchangeSetup
{
    fields
    {
        field(1; "Primary Key"; Code[10]) { DataClassification = CustomerContent; }
        field(10; "Storage Root"; Text[250]) { DataClassification = CustomerContent; }
        field(20; "Azure Base Url"; Text[250]) { DataClassification = CustomerContent; }
        field(21; "Access Key"; Text[250]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}