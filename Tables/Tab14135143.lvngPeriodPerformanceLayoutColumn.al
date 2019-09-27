table 14135143 lvngPeriodPerfLayoutColumn
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Layout Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPeriodPerformanceLayout.Code; }
        field(2; "Column No."; Integer) { DataClassification = CustomerContent; }
        field(10; "Period Type"; Enum lvngPerformancePeriodType) { DataClassification = CustomerContent; }
        field(11; "Period Offset"; Integer) { DataClassification = CustomerContent; }
        field(12; "Period Length Formula"; DateFormula) { DataClassification = CustomerContent; }
        field(13; Source; Enum lvngPerformanceColumnSource) { DataClassification = CustomerContent; }
        //14,15 - Column type (normal/formula) & formula text ??? Not needed now?
        field(20; "Header Description"; Text[50]) { DataClassification = CustomerContent; }
        field(21; "Dynamic Date Description"; Boolean) { DataClassification = CustomerContent; }
        field(22; Priority; Integer) { DataClassification = CustomerContent; }
        field(30; "Date From"; Date) { DataClassification = CustomerContent; }
        field(31; "Date To"; Date) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Layout Code", "Column No.") { }
        key(Priority; Priority) { }
    }
}