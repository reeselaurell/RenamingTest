table 14135133 "lvnEscrowFieldsMapping"
{
    Caption = 'Escrow Fields Mapping';
    DataClassification = CustomerContent;
    LookupPageId = lvnEscrowFieldsMapping;

    fields
    {
        field(1; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = lvnLoanFieldsConfiguration."Field No." where("Value Type" = const(Decimal));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
            begin
                LoanFieldsConfiguration.Get("Field No.");
                Description := LoanFieldsConfiguration."Field Name";
            end;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Map-To G/L Account No."; Code[20])
        {
            Caption = 'Map-to G/L Account No.';
            TableRelation = "G/L Account"."No." where("Account Type" = const(Posting));
            DataClassification = CustomerContent;
        }
        field(12; "Switch Code"; Code[20])
        {
            Caption = 'G/L Account Switch Code';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ConditionsMgmt: Codeunit lvnConditionsMgmt;
                ExpressionList: Page lvnExpressionList;
                SelectedExpressionCode: Code[20];
                ExpressionType: Enum lvnExpressionType;
            begin
                Clear(ExpressionList);
                SelectedExpressionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'LOAN', "Switch Code", ExpressionType::Switch);
                if SelectedExpressionCode <> '' then
                    "Switch Code" := SelectedExpressionCode;
            end;
        }
        field(30; "Cost Center Option"; enum lvnServDimSelectionType)
        {
            Caption = 'Cost Center Option';
            DataClassification = CustomerContent;
        }
        field(31; "Cost Center"; Code[20])
        {
            Caption = 'Cost Center';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                DimensionsManagement: Codeunit lvnDimensionsManagement;
            begin
                DimensionsManagement.LookupCostCenter("Cost Center");
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