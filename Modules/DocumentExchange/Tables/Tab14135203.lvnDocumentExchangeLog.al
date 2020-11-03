table 14135203 "lvnDocumentExchangeLog"
{
    fields
    {
        field(1; "Primary Key"; BigInteger) { DataClassification = CustomerContent; AutoIncrement = true; }
        field(10; "Creation Date/Time"; DateTime) { DataClassification = CustomerContent; }
        field(11; Success; Boolean) { DataClassification = CustomerContent; }
        field(12; "File Name"; Text[250]) { DataClassification = CustomerContent; }
        field(13; Message; Text[250]) { DataClassification = CustomerContent; }
        field(14; "Document Guid"; Guid) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}