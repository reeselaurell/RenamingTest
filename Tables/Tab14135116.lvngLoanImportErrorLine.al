table 14135116 lvngLoanImportErrorLine
{
    DataClassification = CustomerContent;
    Caption = 'Loan Import Error Line';

    fields
    {
        field(1; lvngLoanJournalBatchCode; Code[20])
        {
            Caption = 'Batch Code';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanJournalBatch;
        }
        field(2; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanJournalLine.lvngLineNo where (lvngLoanJournalBatchCode = field (lvngLoanJournalBatchCode));
        }
        field(3; lvngErrorLineNo; Integer)
        {
            Caption = 'Error Line No.';
            DataClassification = CustomerContent;
        }
        field(10; lvngDescription; text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngLoanJournalBatchCode, lvngLineNo, lvngErrorLineNo)
        {
            Clustered = true;
        }
    }

}