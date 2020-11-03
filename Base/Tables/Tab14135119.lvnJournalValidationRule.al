table 14135119 "lvnJournalValidationRule"
{
    DataClassification = CustomerContent;
    Caption = 'Journal Validation Rule';
    LookupPageId = lvnJournalValidationRules;

    fields
    {
        field(1; "Journal Batch Code"; Code[20]) { Caption = 'Batch Code'; DataClassification = CustomerContent; TableRelation = lvnLoanJournalBatch.Code; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Condition Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Condition Code';

            trigger OnLookup()
            var
                ConditionsMgmt: Codeunit lvnConditionsMgmt;
                ExpressionList: Page lvnExpressionList;
                SelectedConditionCode: Code[20];
                ExpressionType: Enum lvnExpressionType;
            begin
                Clear(ExpressionList);
                SelectedConditionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'JOURNAL', "Condition Code", ExpressionType::Condition);
                if SelectedConditionCode <> '' then
                    "Condition Code" := SelectedConditionCode;
            end;
        }
        field(12; "Error Message"; Text[250]) { Caption = 'Error Message'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Journal Batch Code", "Line No.")
        {
            Clustered = true;
        }
    }
}