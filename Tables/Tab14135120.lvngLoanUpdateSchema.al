table 14135120 "lvngLoanUpdateSchema"
{
    Caption = 'Loan Update Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvngLoanUpdateSchema;

    fields
    {
        field(1; lvngJournalBatchCode; Code[20])
        {
            Caption = 'Import Journal Batch Code';
            DataClassification = CustomerContent;
        }
        field(2; lvngImportFieldType; Enum lvngImportFieldType)
        {
            Caption = 'Field Type';
            DataClassification = CustomerContent;
        }
        field(3; lvngFieldNo; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
        }

        field(10; lvngFieldUpdateOption; enum lvngFieldUpdateOption)
        {
            Caption = 'Update Option';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngJournalBatchCode, lvngImportFieldType, lvngFieldNo)
        {
            Clustered = true;
        }
    }

}