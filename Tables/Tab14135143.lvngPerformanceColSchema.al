table 14135143 lvngPerformanceColSchema
{
    DataClassification = CustomerContent;
    LookupPageId = lvngPerformanceColSchemaList;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}