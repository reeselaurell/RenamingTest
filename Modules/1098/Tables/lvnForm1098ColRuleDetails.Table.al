table 14135140 "lvnForm1098ColRuleDetails"
{
    Caption = 'Form 1098 Collection Rule Details';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Box No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Box No.';
            TableRelation = lvnForm1098CollectionRule."Box No.";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(11; Type; Enum lvnForm1098ColRuleType)
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(12; "Condition Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Condition Code';
            TableRelation = lvnExpressionHeader.Code where(Type = const(Condition));

            trigger OnLookup()
            var
                ConditionsMgmt: Codeunit lvnConditionsMgmt;
                ExpressionList: Page lvnExpressionList;
                SelectedExpressionCode: Code[20];
                ExpressionType: Enum lvnExpressionType;
            begin
                Clear(ExpressionList);
                SelectedExpressionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'LOAN', "Condition Code", ExpressionType::Condition);
                if SelectedExpressionCode <> '' then
                    "Condition Code" := SelectedExpressionCode;
            end;
        }
        field(13; "Formula Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Formula Code';
            TableRelation = lvnExpressionHeader.Code where(Type = const(Formula));

            trigger OnLookup()
            var
                ConditionsMgmt: Codeunit lvnConditionsMgmt;
                ExpressionList: Page lvnExpressionList;
                SelectedExpressionCode: Code[20];
                ExpressionType: Enum lvnExpressionType;
            begin
                Clear(ExpressionList);
                SelectedExpressionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'LOAN', "Formula Code", ExpressionType::Condition);
                if SelectedExpressionCode <> '' then
                    "Formula Code" := SelectedExpressionCode;
            end;
        }
        field(14; "G/L Filter"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'G/L Filter';
        }
        field(15; "Document Paid"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Paid';
        }
        field(16; "Reverse Amount"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Reverse Amount';
        }
        field(17; "Paid Before Current Year"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Paid Before Current Year';
        }
    }

    keys
    {
        key(PK; "Box No.", "Line No.") { Clustered = true; }
    }
}