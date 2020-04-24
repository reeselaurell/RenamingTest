table 14135150 lvngImportJobSchedulerTask
{
    Caption = 'Import Job Scheduler Task';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(10; Type; Enum lvngImportSchedulerTaskType) { Caption = 'Type'; DataClassification = CustomerContent; }
        field(11; "Import Folder"; Text[63]) { Caption = 'Import Folder'; DataClassification = CustomerContent; }
        field(12; "Archive Folder"; Text[63]) { Caption = 'Archive Folder'; DataClassification = CustomerContent; }
        field(13; "Error Folder"; Text[63]) { Caption = 'Error Folder'; DataClassification = CustomerContent; }
        field(14; "Data Import Schema Code"; Code[20]) { Caption = 'Data Import Schema Code'; DataClassification = CustomerContent; TableRelation = if (Type = const("General Journal")) lvngFileImportSchema.Code where("File Import Type" = const("General Journal")) else if (Type = const("Loan Journal")) lvngLoanImportSchema.Code; }
        field(15; "Loan Journal Type"; Enum lvngLoanJournalBatchType) { Caption = 'Loan Journal Type'; DataClassification = CustomerContent; }
        field(16; "Loan Journal Batch"; Code[20]) { Caption = 'Loan Journal Batch'; DataClassification = CustomerContent; TableRelation = lvngLoanJournalBatch.Code where("Loan Journal Type" = field("Loan Journal Type")); }
        field(17; "Gen. Journal Template"; Code[20]) { Caption = 'Gen. Journal Template'; DataClassification = CustomerContent; TableRelation = "Gen. Journal Template".Name; }
        field(18; "Gen. Journal Batch"; Code[20]) { Caption = 'Gen. Journal Batch'; DataClassification = CustomerContent; TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Gen. Journal Template")); }
        field(19; Post; Boolean) { Caption = 'Post'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}