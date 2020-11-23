table 14135108 "lvnLoanJournalValue"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Value';

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
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoanFieldsConfiguration;
            NotBlank = true;
        }
        field(10; "Field Value"; Text[250])
        {
            Caption = 'Field Value';
            DataClassification = CustomerContent;
        }
        field(100; "Field Name"; Text[50])
        {
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnLoanFieldsConfiguration."Field Name" where("Field No." = field("Field No.")));
        }
    }

    keys
    {
        key(PK; "Loan Journal Batch Code", "Line No.", "Field No.") { Clustered = true; }
    }
}