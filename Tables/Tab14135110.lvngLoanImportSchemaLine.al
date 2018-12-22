table 14135110 "lvngLoanImportSchemaLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Import Schema Line';
    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(5; lvngName; Text[50])
        {
            Caption = 'Field Name';
            DataClassification = CustomerContent;
        }
        field(10; lvngFieldType; enum lvngImportFieldType)
        {
            Caption = 'Field Type';
            DataClassification = CustomerContent;
        }
        field(11; lvngFieldNo; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
        }
        field(12; lvngTrimOption; enum lvngTrimOption)
        {
            Caption = 'Trim';
            DataClassification = CustomerContent;
        }
        field(13; lvngFieldSize; Integer)
        {
            Caption = 'Field Size';
            DataClassification = CustomerContent;
        }
        field(14; lvngPaddingCharacter; Text[1])
        {
            Caption = 'Padding Character';
            DataClassification = CustomerContent;
        }

        field(15; lvngPaddingSide; Enum lvngPaddingSide)
        {
            Caption = 'Padding Side';
            DataClassification = CustomerContent;
        }

        field(16; lvngBooleanFormat; enum lvngBooleanFormat)
        {
            Caption = 'Boolean Format';
            DataClassification = CustomerContent;
        }

        field(17; lvngNumbericalFormatting; enum lvngNumericalFormatting)
        {
            Caption = 'Numerical Formatting';
            DataClassification = CustomerContent;
        }
        field(18; lvngValueType; enum lvngLoanFieldValueType)
        {
            Caption = 'Value Type';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngCode, lvngLineNo)
        {
            Clustered = true;
        }


    }

}