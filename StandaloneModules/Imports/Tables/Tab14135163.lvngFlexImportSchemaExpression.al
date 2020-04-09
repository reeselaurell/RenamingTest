table 14135163 lvngFlexImportSchemaExpression
{
    Caption = 'Flexible Import Schema Expression';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Schema Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngFlexibleImportSchema.Code; }
        field(2; "Amount Column No."; Integer) { DataClassification = CustomerContent; TableRelation = lvngFlexibleImportSchemaLine."Amount Column No." where("Schema Code" = field("Schema Code")); }
        field(3; "Condition Line No."; Integer) { DataClassification = CustomerContent; }
        field(10; "Assign Result To Field"; Enum lvngFlexImportAssignTarget) { DataClassification = CustomerContent; }
        field(11; "Expression Type"; Enum lvngExpressionType) { DataClassification = CustomerContent; }
        field(12; "Expression Code"; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ConditionsMgmt: Codeunit lvngConditionsMgmt;
                ExpressionList: page lvngExpressionList;
                SelectedExpressionCode: Code[20];
                ExpressionType: Enum lvngExpressionType;
            begin
                Clear(ExpressionList);
                SelectedExpressionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'LOAN', "Expression Code", "Expression Type");
                if SelectedExpressionCode <> '' then
                    "Expression Code" := SelectedExpressionCode;
            end;
        }
        field(13; Value; Code[20]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Schema Code", "Amount Column No.", "Condition Line No.") { Clustered = true; }
    }
}