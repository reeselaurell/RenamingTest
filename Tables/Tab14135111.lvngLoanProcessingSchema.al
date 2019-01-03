table 14135111 lvngLoanProcessingSchema
{
    Caption = 'Loan Processing Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvngLoanProcessingSchema;

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

        field(12; lvngGlobalSchema; Boolean)
        {
            Caption = 'Global Schema';
            DataClassification = CustomerContent;
        }

        field(13; lvngUseGlobalSchemaCode; Code[20])
        {
            Caption = 'Use Global Schema Code';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanProcessingSchema.lvngCode where (lvngGlobalSchema = const (true));
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