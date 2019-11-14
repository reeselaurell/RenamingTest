table 14135109 "lvngLoanImportSchema"
{
    Caption = 'Loan Import Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvngLoanImportSchemaList;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
        field(11; "Field Separator Character"; Text[10]) { DataClassification = CustomerContent; }
        field(13; "Skip Lines"; Integer) { DataClassification = CustomerContent; }
        field(14; "Loan Journal Batch Type"; enum lvngLoanJournalBatchType) { Caption = 'Journal Batch Type'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

}