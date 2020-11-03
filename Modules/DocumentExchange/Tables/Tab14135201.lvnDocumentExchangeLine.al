table 14135201 "lvnDocumentExchangeLine"
{
    fields
    {
        field(1; "Id"; Guid) { DataClassification = CustomerContent; }
        field(10; "Object Id"; Guid) { DataClassification = CustomerContent; }
        field(11; "Is Imported"; Boolean) { DataClassification = CustomerContent; }
        field(12; "Original Name"; Text[250]) { DataClassification = CustomerContent; }
        field(13; "Storage Path"; Text[250]) { DataClassification = CustomerContent; }
        field(14; "Storage Name"; Text[250]) { DataClassification = CustomerContent; }
        field(15; "Creation Date/Time"; DateTime) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Id) { Clustered = true; }
        key(ObjectId; "Object Id") { }
    }
}