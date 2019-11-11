table 14135241 lvngLoanLevelValueBuffer
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Row No."; Integer) { DataClassification = CustomerContent; }
        field(2; "Column No."; Integer) { DataClassification = CustomerContent; }
        field(10; "Value Type"; Enum lvngLoanLevelValueType) { DataClassification = CustomerContent; }
        field(11; "Raw Value"; Text[250]) { DataClassification = CustomerContent; }
        field(12; "Numeric Value"; Decimal) { DataClassification = CustomerContent; }
        field(13; "Date Value"; Date) { DataClassification = CustomerContent; }
        field(14; "Number Format Code"; Code[20]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Row No.", "Column No.") { Clustered = true; }
    }
}