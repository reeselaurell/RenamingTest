table 14135315 "lvngCommReportTemplateLine"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';

        }
        field(2; lvngColumnNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Column No.';
        }
        field(10; lvngDescription; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(11; lvngType; Enum lvngCommissionTemplateLineType)
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(12; lvngFieldNo; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
        }
        field(13; lvngFormulaCode; Code[20])
        {
            Caption = 'Formula Code';
            DataClassification = CustomerContent;
        }
        field(14; lvngDataType; enum lvngLoanFieldValueType)
        {
            Caption = 'Data Type';
            DataClassification = CustomerContent;
        }
        field(15; lvngDecimalRounding; Decimal)
        {
            Caption = 'Decimal Rounding';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        field(16; lvngExcelExportFormat; Text[50])
        {
            Caption = 'Excel Export Format';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngCode, lvngColumnNo)
        {
            Clustered = true;
        }
    }
}