table 14135116 lvngLoanImportErrorLine
{
    DataClassification = CustomerContent;
    Caption = 'Loan Import Error Line';

    fields
    {
        field(1; "Loan Journal Batch Code"; Code[20]) { Caption = 'Batch Code'; DataClassification = CustomerContent; TableRelation = lvngLoanJournalBatch; }
        field(2; "Line No."; Integer) { DataClassification = CustomerContent; TableRelation = lvngLoanJournalLine."Line No." where("Loan Journal Batch Code" = field("Loan Journal Batch Code")); }
        field(3; "Error Line No."; Integer) { DataClassification = CustomerContent; }
        field(10; Description; text[250]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Loan Journal Batch Code", "Line No.", "Error Line No.") { Clustered = true; }
    }

}