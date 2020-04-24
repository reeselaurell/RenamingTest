table 14135187 lvngLoanLevelValueBuffer
{
    Caption = 'Loan Level Value Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Row No."; Integer) { Caption = 'Row No.'; DataClassification = CustomerContent; }
        field(2; "Column No."; Integer) { Caption = 'Column No.'; DataClassification = CustomerContent; }
        field(10; "Value Type"; Enum lvngLoanLevelValueType) { Caption = 'Value Type'; DataClassification = CustomerContent; }
        field(11; "Raw Value"; Text[250]) { Caption = 'Raw Value'; DataClassification = CustomerContent; }
        field(12; "Numeric Value"; Decimal) { Caption = 'Numeric Value'; DataClassification = CustomerContent; }
        field(13; "Date Value"; Date) { Caption = 'Date Value'; DataClassification = CustomerContent; }
        field(14; "Number Format Code"; Code[20]) { Caption = 'Number Format Code'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Row No.", "Column No.") { Clustered = true; }
    }
}