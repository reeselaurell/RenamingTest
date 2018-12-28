table 14135111 lvngLoanProcessingSchema
{
    Caption = 'Loan Processing Schema';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(10; lvngDescription; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(11; lvngNoSeries; Code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }


    }

    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }

}