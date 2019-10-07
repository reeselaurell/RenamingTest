table 14135233 lvngDimPerfBandSchemaLine
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Schema Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngDimensionPerfBandSchema.Code; }
        field(2; "Band No."; Integer) { DataClassification = CustomerContent; }
        field(10; "Dimension Filter"; Code[20]) { DataClassification = CustomerContent; }
        field(11; "Header Description"; Text[100]) { DataClassification = CustomerContent; }
        field(12; "Band Type"; Enum lvngPerformanceBandType) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Schema Code", "Band No.") { Clustered = true; }
    }
}