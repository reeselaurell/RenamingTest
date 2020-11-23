table 14135170 "lvnPerformanceColSchema"
{
    Caption = 'Performance Column Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvnPerformanceColSchemaList;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}