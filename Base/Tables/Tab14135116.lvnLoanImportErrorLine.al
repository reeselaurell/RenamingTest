table 14135116 "lvnLoanImportErrorLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Import Error Line';

    fields
    {
        field(1; "Loan Journal Batch Code"; Code[20])
        {
            Caption = 'Batch Code';
            DataClassification = CustomerContent;
            TableRelation = lvnLoanJournalBatch;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoanJournalLine."Line No." where("Loan Journal Batch Code" = field("Loan Journal Batch Code"));
        }
        field(3; "Error Line No."; Integer)
        {
            Caption = 'Error Line No.';
            DataClassification = CustomerContent;
        }
        field(10; Description; text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Loan Journal Batch Code", "Line No.", "Error Line No.") { Clustered = true; }
    }
}