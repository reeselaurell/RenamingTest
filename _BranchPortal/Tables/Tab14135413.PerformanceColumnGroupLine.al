table 14135413 lvngPerformanceColumnGroupLine
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Group Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceColumnGroup.Code; }
        field(2; "Line No."; Integer) { DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Group Code", "Line No.") { Clustered = true; }
    }
}