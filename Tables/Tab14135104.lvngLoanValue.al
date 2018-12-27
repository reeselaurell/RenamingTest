table 14135104 "lvngLoanValue"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Value';
    fields
    {
        field(1; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoan;
            NotBlank = true;
        }

        field(2; lvngFieldNo; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanFieldsConfiguration;
            NotBlank = true;
        }

        field(10; lvngFieldValue; Text[250])
        {
            Caption = 'Field Value';
            DataClassification = CustomerContent;
        }
        field(11; lvngDateValue; Date)
        {
            Caption = 'Date Value';
            DataClassification = CustomerContent;
        }
        field(12; lvngIntegerValue; Integer)
        {
            Caption = 'Integer Value';
            DataClassification = CustomerContent;
        }
        field(13; lvngDecimalValue; Decimal)
        {
            Caption = 'Decimal Value';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
        }
        field(14; lvngBooleanValue; Boolean)
        {
            Caption = 'Boolean Value';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngLoanNo, lvngFieldNo)
        {
            Clustered = true;
        }
    }

}