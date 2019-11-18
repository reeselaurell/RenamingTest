table 14135110 "lvngLoanImportSchemaLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Import Schema Line';
    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Line No."; Integer) { DataClassification = CustomerContent; }
        field(5; "Field Name"; Text[50]) { DataClassification = CustomerContent; }
        field(10; "Field Type"; enum lvngImportFieldType) { DataClassification = CustomerContent; }
        field(11; "Field No."; Integer) { DataClassification = CustomerContent; }
        field(12; Trimming; enum lvngTextTrimmingMode) { Caption = 'Trim'; DataClassification = CustomerContent; }
        field(13; "Field Size"; Integer) { DataClassification = CustomerContent; }
        field(14; "Padding Character"; Text[1]) { DataClassification = CustomerContent; }
        field(15; "Padding Side"; Enum lvngTextPaddingMode) { DataClassification = CustomerContent; }
        field(16; "Boolean Format"; enum lvngParseBooleanFormat) { DataClassification = CustomerContent; }
        field(17; "Numeric Format"; enum lvngParseNumericFormat) { DataClassification = CustomerContent; }
        field(18; "Value Type"; enum lvngLoanFieldValueType) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code, "Line No.") { Clustered = true; }
    }
}