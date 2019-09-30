table 14135221 lvngPerformanceRowSchemaLine
{
    fields
    {
        field(1; "Schema Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceRowSchema.Code; }
        field(2; "Line No."; Integer) { DataClassification = CustomerContent; }
        field(3; "Column No."; Integer) { DataClassification = CustomerContent; }
        field(10; Description; Text[100]) { DataClassification = CustomerContent; }
        field(11; "Calculation Unit Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(12; "Number Format Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngNumberFormat.Code; }
        field(13; "Style Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngStyle.Code; }
        field(14; "Neg. Style Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngStyle.Code; }
    }

    keys
    {
        key(PK; "Schema Code", "Line No.", "Column No.") { Clustered = true; }
    }
}