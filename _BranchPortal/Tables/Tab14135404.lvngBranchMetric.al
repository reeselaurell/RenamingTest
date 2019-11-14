table 14135404 lvngBranchMetric
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Type; Enum lvngBranchMetricType) { DataClassification = CustomerContent; }
        field(2; "No."; Integer) { DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
        field(11; "Calculation Unit Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(12; "Number Format Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngNumberFormat.Code; }
    }

    keys
    {
        key(PK; Type, "No.") { Clustered = true; }
    }
}