table 14135315 lvnCommReportTemplateLine
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            DataClassification = CustomerContent;
        }
        field(2; "Column No."; Integer)
        {
            Caption = 'Column No.';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Template Line Type"; Enum lvnCommissionTemplateLineType)
        {
            Caption = 'Template Line Type';
            DataClassification = CustomerContent;
        }
        field(12; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
        }
        field(13; "Formula Code"; Code[20])
        {
            Caption = 'Formula Code';
            DataClassification = CustomerContent;
        }
        field(14; "Value Data Type"; enum lvnLoanFieldValueType)
        {
            Caption = 'Value Data Type';
            DataClassification = CustomerContent;
        }
        field(15; "Decimal Rounding"; Decimal)
        {
            Caption = 'Decimal Rounding';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        field(16; "Excel Export Format"; Text[50])
        {
            Caption = 'Excel Export Format';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Template Code", "Column No.") { Clustered = true; }
    }
}