table 14135113 "lvnLoanProcessingSchemaLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Processing Schema Line';

    fields
    {
        field(1; "Processing Code"; Code[20])
        {
            Caption = 'Processing Code';
            DataClassification = CustomerContent;
            TableRelation = lvnLoanProcessingSchema;
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "Processing Source Type"; Enum lvnProcessingSourceType)
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
        }
        field(11; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
        }
        field(12; "Function Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Function Code';

            trigger OnLookup()
            var
                SelectedFunctionCode: Code[20];
                ExpressionType: Enum lvnExpressionType;
            begin
                Clear(ExpressionList);
                SelectedFunctionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'JOURNAL', "Function Code", ExpressionType::Formula);
                if SelectedFunctionCode <> '' then
                    "Function Code" := SelectedFunctionCode;
            end;
        }
        field(13; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(14; "Account Type"; enum lvnLoanAccountType)
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(15; "Account No."; code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(16; "Account No. Switch Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Account No. Switch Code';

            trigger OnLookup()
            var
                SelectedSwitchCode: Code[20];
                ExpressionType: Enum lvnExpressionType;
            begin
                Clear(ExpressionList);
                SelectedSwitchCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'JOURNAL', "Account No. Switch Code", ExpressionType::Switch);
                if SelectedSwitchCode <> '' then
                    "Account No. Switch Code" := SelectedSwitchCode;
            end;
        }
        field(17; "Condition Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Condition Code';

            trigger OnLookup()
            var
                SelectedConditionCode: Code[20];
                ExpressionType: Enum lvnExpressionType;
            begin
                Clear(ExpressionList);
                SelectedConditionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'JOURNAL', "Condition Code", ExpressionType::Condition);
                if SelectedConditionCode <> '' then
                    "Condition Code" := SelectedConditionCode;
            end;
        }
        field(18; "Tag Code"; Code[10])
        {
            Caption = 'Tag Code';
            DataClassification = CustomerContent;
        }
        field(20; "Reverse Sign"; Boolean)
        {
            Caption = 'Reverse Sign';
            DataClassification = CustomerContent;
        }
        field(21; "Balancing Entry"; Boolean)
        {
            Caption = 'Balancing Entry';
            DataClassification = CustomerContent;
        }
        field(22; "Override Reason Code"; Code[10])
        {
            Caption = 'Override Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(23; "Calculation Parameter"; Decimal)
        {
            Caption = 'Calculation Parameter';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
        }
        field(24; "Processing Parameter"; Text[250])
        {
            Caption = 'Processing Parameter';
            DataClassification = CustomerContent;
        }
        field(80; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(81; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(82; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(83; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(84; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
        }
        field(85; "Shortcut Dimension 6 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
        }
        field(86; "Shortcut Dimension 7 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
        }
        field(87; "Shortcut Dimension 8 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
        }
        field(88; "Business Unit Code"; Code[20])
        {
            Caption = 'Business Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Business Unit";
        }
        field(200; "Servicing Type"; enum lvnServicingType)
        {
            Caption = 'Servicing Type';
            DataClassification = CustomerContent;
        }
        field(1000; "Dimension 1 Rule"; enum lvnProcessingDimensionRule)
        {
            Caption = 'Dimension 1 Rule';
            CaptionClass = GetRuleCaptionString(1);
            DataClassification = CustomerContent;
        }
        field(1001; "Dimension 2 Rule"; enum lvnProcessingDimensionRule)
        {
            Caption = 'Dimension 2 Rule';
            CaptionClass = GetRuleCaptionString(2);
            DataClassification = CustomerContent;
        }
        field(1002; "Dimension 3 Rule"; enum lvnProcessingDimensionRule)
        {
            Caption = 'Dimension 3 Rule';
            CaptionClass = GetRuleCaptionString(3);
            DataClassification = CustomerContent;
        }
        field(1003; "Dimension 4 Rule"; enum lvnProcessingDimensionRule)
        {
            Caption = 'Dimension 4 Rule';
            CaptionClass = GetRuleCaptionString(4);
            DataClassification = CustomerContent;
        }
        field(1004; "Dimension 5 Rule"; enum lvnProcessingDimensionRule)
        {
            Caption = 'Dimension 5 Rule';
            CaptionClass = GetRuleCaptionString(5);
            DataClassification = CustomerContent;
        }
        field(1005; "Dimension 6 Rule"; enum lvnProcessingDimensionRule)
        {
            Caption = 'Dimension 6 Rule';
            CaptionClass = GetRuleCaptionString(6);
            DataClassification = CustomerContent;
        }
        field(1006; "Dimension 7 Rule"; enum lvnProcessingDimensionRule)
        {
            Caption = 'Dimension 7 Rule';
            CaptionClass = GetRuleCaptionString(7);
            DataClassification = CustomerContent;
        }
        field(1007; "Dimension 8 Rule"; enum lvnProcessingDimensionRule)
        {
            Caption = 'Dimension 8 Rule';
            CaptionClass = GetRuleCaptionString(8);
            DataClassification = CustomerContent;
        }
        field(1008; "Business Unit Rule"; enum lvnProcessingDimensionRule)
        {
            Caption = 'Business Unit Rule';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Processing Code", "Line No.") { Clustered = true; }
    }

    var
        DimensionsManagement: Codeunit lvnDimensionsManagement;
        ConditionsMgmt: Codeunit lvnConditionsMgmt;
        ExpressionList: Page lvnExpressionList;
        DimensionNamesRetrieved: Boolean;
        DimensionNames: array[8] of Text;
        lvnRuleLabel: Label '%1 Rule';

    local procedure GetRuleCaptionString(Index: Integer): Text
    begin
        if (Index in [1 .. 8]) then begin
            if not DimensionNamesRetrieved then begin
                DimensionsManagement.GetDimensionNames(DimensionNames);
                DimensionNamesRetrieved := true;
            end;
            exit(StrSubstNo(lvnRuleLabel, DimensionNames[Index]));
        end;
        exit('')
    end;
}