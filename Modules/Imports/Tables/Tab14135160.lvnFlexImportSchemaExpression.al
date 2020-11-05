table 14135160 "lvnFlexImportSchemaExpression"
{
    Caption = 'Flexible Import Schema Expression';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Schema Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = lvnFlexibleImportSchema.Code;
        }
        field(2; "Amount Column No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = lvnFlexibleImportSchemaLine."Amount Column No." where("Schema Code" = field("Schema Code"));
        }
        field(3; "Condition Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Assign Result To Field"; Enum lvnFlexImportAssignTarget)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Expression Type"; Enum lvnExpressionType)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Expression Code"; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ConditionsMgmt: Codeunit lvnConditionsMgmt;
                ExpressionList: Page lvnExpressionList;
                SelectedExpressionCode: Code[20];
                ExpressionType: Enum lvnExpressionType;
            begin
                Clear(ExpressionList);
                SelectedExpressionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'LOAN', "Expression Code", "Expression Type");
                if SelectedExpressionCode <> '' then
                    "Expression Code" := SelectedExpressionCode;
            end;
        }
        field(13; Value; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Schema Code", "Amount Column No.", "Condition Line No.") { Clustered = true; }
    }
}