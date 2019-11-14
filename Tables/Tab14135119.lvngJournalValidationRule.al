table 14135119 "lvngJournalValidationRule"
{
    DataClassification = CustomerContent;
    Caption = 'Journal Validation Rule';
    LookupPageId = lvngJournalValidationRules;

    fields
    {
        field(1; "Journal Batch Code"; Code[20]) { Caption = 'Batch Code'; DataClassification = CustomerContent; TableRelation = lvngLoanJournalBatch.Code; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
        field(11; "Condition Code"; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ConditionsMgmt: Codeunit lvngConditionsMgmt;
                ExpressionList: Page lvngExpressionList;
                SelectedConditionCode: Code[20];
                ExpressionType: Enum lvngExpressionType;
            begin
                Clear(ExpressionList);
                SelectedConditionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'JOURNAL', "Condition Code", ExpressionType::Condition);
                if SelectedConditionCode <> '' then
                    "Condition Code" := SelectedConditionCode;
            end;
        }
        field(12; "Error Message"; Text[250]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Journal Batch Code", "Line No.")
        {
            Clustered = true;
        }
    }
}