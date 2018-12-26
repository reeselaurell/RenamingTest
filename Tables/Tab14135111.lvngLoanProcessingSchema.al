table 14135111 "lvngLoanProcessingSchema"
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

    }

    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }

}