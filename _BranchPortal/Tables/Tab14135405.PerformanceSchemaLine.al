table 14135405 lvngPerformanceSchemaLine
{
    fields
    {
        field(1; "Performance Schema Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceSchema.Code; }
        field(2; "Column Group Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceColumnGroup.Code; }
        field(3; "Column Group Line No."; Integer) { DataClassification = CustomerContent; }
        field(4; "Line No."; Integer) { DataClassification = CustomerContent; }
        field(10; Description; Text[100]) { DataClassification = CustomerContent; }
        field(11; "Calculation Unit Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(12; "Number Format Code"; Code[20]) { DataClassification = CustomerContent; }
        field(13; "Style Code"; Code[20]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Performance Schema Code", "Column Group Code", "Column Group Line No.", "Line No.") { Clustered = true; }
    }
}