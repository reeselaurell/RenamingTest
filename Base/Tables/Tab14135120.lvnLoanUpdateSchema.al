table 14135120 "lvnLoanUpdateSchema"
{
    Caption = 'Loan Update Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvnLoanUpdateSchema;

    fields
    {
        field(1; "Journal Batch Code"; Code[20])
        {
            Caption = 'Import Journal Batch Code';
            DataClassification = CustomerContent;
        }
        field(2; "Import Field Type"; Enum lvnImportFieldType)
        {
            Caption = 'Field Type';
            DataClassification = CustomerContent;
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
        }
        field(10; "Field Update Option"; enum lvnFieldUpdateCondition)
        {
            Caption = 'Update Option';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Journal Batch Code", "Import Field Type", "Field No.") { Clustered = true; }
    }
}