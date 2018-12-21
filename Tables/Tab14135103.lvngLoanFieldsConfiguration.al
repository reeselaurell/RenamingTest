table 14135103 "lvngLoanFieldsConfiguration"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Fields Configuration';
    LookupPageId = lvngLoanFieldsConfiguration;

    fields
    {
        field(1; lvngFieldNo; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(10; lvngFieldName; Text[50])
        {
            Caption = 'Field Name';
            DataClassification = CustomerContent;
        }

        field(11; lvngValueType; Enum lvngLoanFieldValueType)
        {
            Caption = 'Value Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngFieldNo)
        {
            Clustered = true;
        }
    }

}