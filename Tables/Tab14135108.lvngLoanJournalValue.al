table 14135108 "lvngLoanJournalValue"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Value';
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
            TableRelation = lvngLoanJournalLine.lvngLineNo where(lvngLoanJournalBatchCode = field(lvngLoanJournalBatchCode));
        }

        field(3; lvngFieldNo; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanFieldsConfiguration;
            NotBlank = true;
        }

        field(10; lvngFieldValue; Text[250])
        {
            Caption = 'Field Value';
            DataClassification = CustomerContent;
        }

        field(100; lvngFieldName; Text[50])
        {
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoanFieldsConfiguration."Field Name" where("Field No." = field(lvngFieldNo)));
        }

    }

    keys
    {
        key(PK; lvngLoanJournalBatchCode, lvngLineNo, lvngFieldNo)
        {
            Clustered = true;
        }
    }

}