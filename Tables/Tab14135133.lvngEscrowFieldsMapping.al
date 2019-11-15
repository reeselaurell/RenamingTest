table 14135133 "lvngEscrowFieldsMapping"
{
    Caption = 'Escrow Fields Mapping';
    DataClassification = CustomerContent;
    LookupPageId = lvngEscrowFieldsMapping;

    fields
    {
        field(1; lvngFieldNo; Integer)
        {
            Caption = 'Field No.';
            TableRelation = lvngLoanFieldsConfiguration."Field No." where("Value Type" = const(Decimal));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
            begin
                lvngLoanFieldsConfiguration.Get(lvngFieldNo);
                lvngDescription := lvngLoanFieldsConfiguration."Field Name";
            end;
        }
        field(10; lvngDescription; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; lvngMapToGLAccountNo; Code[20])
        {
            Caption = 'Map-to G/L Account No.';
            TableRelation = "G/L Account"."No." where("Account Type" = const(Posting));
            DataClassification = CustomerContent;
        }
        field(12; lvngSwitchCode; Code[20])
        {
            Caption = 'G/L Account Switch Code';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                lvngSelectedExpressionCode: Code[20];
                lvngExpressionList: Page lvngExpressionList;
                ExpressionType: Enum lvngExpressionType;
            begin
                Clear(lvngExpressionList);
                lvngSelectedExpressionCode := lvngExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'LOAN', lvngSwitchCode, ExpressionType::Switch);
                if lvngSelectedExpressionCode <> '' then
                    lvngSwitchCode := lvngSelectedExpressionCode;
            end;
        }
    }

    keys
    {
        key(PK; lvngFieldNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; lvngFieldNo, lvngDescription, lvngMapToGLAccountNo, lvngSwitchCode) { }
    }

    var
        ConditionsMgmt: Codeunit lvngConditionsMgmt;

}