table 14135110 "lvnLoanImportSchemaLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Import Schema Line';

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(5; "Field Name"; Text[50])
        {
            Caption = 'Field Name';
            DataClassification = CustomerContent;
        }
        field(10; "Field Type"; enum lvnImportFieldType)
        {
            Caption = 'Field Type';
            DataClassification = CustomerContent;
        }
        field(11; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
        }
        field(12; Trimming; enum lvnTextTrimmingMode)
        {
            Caption = 'Trim';
            DataClassification = CustomerContent;
        }
        field(13; "Field Size"; Integer)
        {
            Caption = 'Field Size';
            DataClassification = CustomerContent;
        }
        field(14; "Padding Character"; Text[1])
        {
            Caption = 'Padding Character';
            DataClassification = CustomerContent;
        }
        field(15; "Padding Side"; Enum lvnTextPaddingMode)
        {
            Caption = 'Padding Side';
            DataClassification = CustomerContent;
        }
        field(16; "Boolean Format"; enum lvnParseBooleanFormat)
        {
            Caption = 'Boolean Format';
            DataClassification = CustomerContent;
        }
        field(17; "Numeric Format"; enum lvnParseNumericFormat)
        {
            Caption = 'Numeric Format';
            DataClassification = CustomerContent;
        }
        field(18; "Value Type"; enum lvnLoanFieldValueType)
        {
            Caption = 'Value Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code, "Line No.") { Clustered = true; }
    }
}