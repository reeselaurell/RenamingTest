table 14135223 lvngPeriodPerfBandSchemaLine
{
    DataClassification = CustomerContent;
    LookupPageId = lvngPeriodPerfBandSchemaLines;

    fields
    {
        field(1; "Schema Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPeriodPerfBandSchema.Code; }
        field(2; "Band No."; Integer) { DataClassification = CustomerContent; }
        field(10; "Period Type"; Enum lvngPerformancePeriodType) { DataClassification = CustomerContent; }
        field(11; "Period Offset"; Integer) { DataClassification = CustomerContent; }
        field(12; "Period Length Formula"; DateFormula) { DataClassification = CustomerContent; }
        field(13; "Header Description"; Text[50]) { DataClassification = CustomerContent; }
        field(14; "Dynamic Date Description"; Boolean) { DataClassification = CustomerContent; }
        field(18; "Date From"; Date) { DataClassification = CustomerContent; }
        field(19; "Date To"; Date) { DataClassification = CustomerContent; }
        field(20; "Band Type"; Enum lvngPerformanceBandType) { DataClassification = CustomerContent; }
        field(21; "Row Formula Code"; Code[20]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Schema Code", "Band No.") { Clustered = true; }
    }
}