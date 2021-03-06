table 14135109 "lvnLoanImportSchema"
{
    Caption = 'Loan Import Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvnLoanImportSchemaList;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Field Separator Character"; Text[10])
        {
            Caption = 'Field Separator Character';
            DataClassification = CustomerContent;
        }
        field(13; "Skip Lines"; Integer)
        {
            Caption = 'Skip Lines';
            DataClassification = CustomerContent;
        }
        field(14; "Loan Journal Batch Type"; enum lvnLoanJournalBatchType)
        {
            Caption = 'Journal Batch Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}