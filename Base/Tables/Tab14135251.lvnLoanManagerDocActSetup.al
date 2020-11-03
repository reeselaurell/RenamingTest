table 14135251 "lvnLoanManagerDocActSetup"
{
    Caption = 'Loan Manager Document Activities Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; DataClassification = CustomerContent; }
        field(10; "Funded Clearing Bal. Account"; Text[250]) { Caption = 'Funded Clearing Bal. Account'; DataClassification = CustomerContent; TableRelation = "G/L Account Category"; }
        field(11; "Sold Clearing Bal. Account"; Text[250]) { Caption = 'Sold Clearing Bal. Account'; DataClassification = CustomerContent; TableRelation = "G/L Account Category"; }
        field(12; "Unprocessed Funding Jnl 1"; Code[10]) { Caption = 'Unprocessed Funding Journal 1'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
        field(13; "Unprocessed Funding Jnl 2"; Code[10]) { Caption = 'Unprocessed Funding Journal 2'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
        field(14; "Unprocessed Funding Jnl 3"; Code[10]) { Caption = 'Unprocessed Funding Journal 3'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
        field(15; "Unprocessed Funding Jnl 4"; Code[10]) { Caption = 'Unprocessed Funding Journal 4'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
        field(16; "Unprocessed Funding Jnl 5"; Code[10]) { Caption = 'Unprocessed Funding Journal 5'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
        field(17; "Unprocessed Sold Jnl 1"; Code[10]) { Caption = 'Unprocessed Sold Journal 1'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
        field(18; "Unprocessed Sold Jnl 2"; Code[10]) { Caption = 'Unprocessed Sold Journal 2'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
        field(19; "Unprocessed Sold Jnl 3"; Code[10]) { Caption = 'Unprocessed Sold Journal 3'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
        field(20; "Unprocessed Sold Jnl 4"; Code[10]) { Caption = 'Unprocessed Sold Journal 4'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
        field(21; "Unprocessed Sold Jnl 5"; Code[10]) { Caption = 'Unprocessed Sold Journal 5'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}