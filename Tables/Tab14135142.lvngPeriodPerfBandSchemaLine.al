table 14135142 lvngPeriodPerfBandSchemaLine
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Band Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPeriodPerfBandSchema.Code; }
        field(2; "Line No."; Integer) { DataClassification = CustomerContent; AutoIncrement = true; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
        field(11; "Period Type"; Enum lvngPerformancePeriodType) { DataClassification = CustomerContent; }
        field(12; "Period Offset"; Integer) { DataClassification = CustomerContent; }
        field(13; "Period Length Formula"; DateFormula) { DataClassification = CustomerContent; }
        field(14; Source; Enum lvngPerformanceBandSource) { DataClassification = CustomerContent; }
        field(15; "Header Description"; Text[50]) { DataClassification = CustomerContent; }
        field(16; "Dynamic Date Description"; Boolean) { DataClassification = CustomerContent; }
        field(17; Priority; Integer) { DataClassification = CustomerContent; }
        field(18; "Date From"; Date) { DataClassification = CustomerContent; }
        field(19; "Date To"; Date) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Band Code", "Line No.") { Clustered = true; }
        key(Priority; Priority) { }
    }
}