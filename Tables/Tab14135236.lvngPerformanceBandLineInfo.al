table 14135236 lvngPerformanceBandLineInfo
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Band No."; Integer) { DataClassification = CustomerContent; }
        field(10; "Header Description"; Text[50]) { DataClassification = CustomerContent; }
        field(11; "Band Type"; Enum lvngPerformanceBandType) { DataClassification = CustomerContent; }
        field(12; "Row Formula Code"; Code[20]) { DataClassification = CustomerContent; }
        field(13; "Band Index"; Integer) { DataClassification = CustomerContent; }
        field(14; "Date From"; Date) { DataClassification = CustomerContent; }
        field(15; "Date To"; Date) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Band No.") { Clustered = true; }
    }
}