table 14135105 lvngLoanJournalBatch
{
    DataClassification = CustomerContent;
    Caption = 'Loan Journal Batch';
    LookupPageId = lvngLoanJournalBatches;

    fields
    {
        field(1; lvngCode; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(10; lvngDescription; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(11; lvngLoanJournalType; enum lvngLoanJournalBatchType)
        {
            Caption = 'Journal Type';
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

