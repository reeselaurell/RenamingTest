table 14135408 lvngDimensionPerfLayoutColumn
{
    fields
    {
        field(1; "Layout Code"; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Column No."; Integer) { DataClassification = CustomerContent; }
        field(10; Sequence; Integer) { DataClassification = CustomerContent; }
        field(11; "Dimension Filter"; Code[20]) { DataClassification = CustomerContent; }
        field(12; "Column Name"; Text[100]) { DataClassification = CustomerContent; }
        field(13; "Column Type"; Enum lvngLayoutColumnType) { DataClassification = CustomerContent; }
        field(14; Formula; Text[250]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Layout Code", "Column No.") { Clustered = true; }
        key(Sequence; Sequence) { }
    }
}