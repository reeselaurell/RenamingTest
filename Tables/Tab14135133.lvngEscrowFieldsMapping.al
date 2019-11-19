table 14135133 lvngEscrowFieldsMapping
{
    Caption = 'Escrow Fields Mapping';
    DataClassification = CustomerContent;
    LookupPageId = lvngEscrowFieldsMapping;

    fields
    {
        field(1; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = lvngLoanFieldsConfiguration."Field No." where("Value Type" = const(Decimal));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
            begin
                LoanFieldsConfiguration.Get("Field No.");
                Description := LoanFieldsConfiguration."Field Name";
            end;
        }
        field(10; Description; Text[100]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Map-To G/L Account No."; Code[20]) { Caption = 'Map-to G/L Account No.'; TableRelation = "G/L Account"."No." where("Account Type" = const(Posting)); DataClassification = CustomerContent; }
        field(12; "Switch Code"; Code[20])
        {
            Caption = 'G/L Account Switch Code';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ConditionsMgmt: Codeunit lvngConditionsMgmt;
                ExpressionList: Page lvngExpressionList;
                SelectedExpressionCode: Code[20];
                ExpressionType: Enum lvngExpressionType;
            begin
                Clear(ExpressionList);
                SelectedExpressionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'LOAN', "Switch Code", ExpressionType::Switch);
                if SelectedExpressionCode <> '' then
                    "Switch Code" := SelectedExpressionCode;
            end;
        }
    }

    keys
    {
        key(PK; "Field No.") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Field No.", Description, "Map-To G/L Account No.", "Switch Code") { }
    }
}