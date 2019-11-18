table 14135113 "lvngLoanProcessingSchemaLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Processing Schema Line';
    fields
    {
        field(1; "Processing Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngLoanProcessingSchema; NotBlank = true; }
        field(2; "Line No."; Integer) { DataClassification = CustomerContent; }
        field(10; "Processing Source Type"; Enum lvngProcessingSourceType) { Caption = 'Source Type'; DataClassification = CustomerContent; }
        field(11; "Field No."; Integer) { DataClassification = CustomerContent; }
        field(12; "Function Code"; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                SelectedFunctionCode: Code[20];
                ExpressionType: Enum lvngExpressionType;
            begin
                Clear(ExpressionList);
                SelectedFunctionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'JOURNAL', "Function Code", ExpressionType::Formula);
                if SelectedFunctionCode <> '' then
                    "Function Code" := SelectedFunctionCode;
            end;
        }
        field(13; Description; Text[50]) { DataClassification = CustomerContent; }
        field(14; "Account Type"; enum lvngLoanAccountType) { DataClassification = CustomerContent; }
        field(15; "Account No."; code[20]) { DataClassification = CustomerContent; }
        field(16; "Account No. Switch Code"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                SelectedSwitchCode: Code[20];
                ExpressionType: Enum lvngExpressionType;
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
            trigger OnLookup()
            var
                SelectedConditionCode: Code[20];
                ExpressionType: Enum lvngExpressionType;
            begin
                Clear(ExpressionList);
                SelectedConditionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), 'JOURNAL', "Condition Code", ExpressionType::Condition);
                if SelectedConditionCode <> '' then
                    "Condition Code" := SelectedConditionCode;
            end;
        }
        field(18; "Tag Code"; Code[10]) { DataClassification = CustomerContent; }
        field(20; "Reverse Sign"; Boolean) { DataClassification = CustomerContent; }
        field(21; "Balancing Entry"; Boolean) { DataClassification = CustomerContent; }
        field(22; "Override Reason Code"; Code[10]) { DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(80; "Global Dimension 1 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,1,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(81; "Global Dimension 2 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,1,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(82; "Shortcut Dimension 3 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(83; "Shortcut Dimension 4 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(84; "Shortcut Dimension 5 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(85; "Shortcut Dimension 6 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(86; "Shortcut Dimension 7 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(87; "Shortcut Dimension 8 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(88; "Business Unit Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Business Unit"; }
        field(200; "Servicing Type"; enum lvngServicingType) { DataClassification = CustomerContent; }
        field(1000; "Dimension 1 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(1); DataClassification = CustomerContent; }
        field(1001; "Dimension 2 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(2); DataClassification = CustomerContent; }
        field(1002; "Dimension 3 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(3); DataClassification = CustomerContent; }
        field(1003; "Dimension 4 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(4); DataClassification = CustomerContent; }
        field(1004; "Dimension 5 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(5); DataClassification = CustomerContent; }
        field(1005; "Dimension 6 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(6); DataClassification = CustomerContent; }
        field(1006; "Dimension 7 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(7); DataClassification = CustomerContent; }
        field(1007; "Dimension 8 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(8); DataClassification = CustomerContent; }
        field(1008; "Business Unit Rule"; enum lvngProcessingDimensionRule) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Processing Code", "Line No.") { Clustered = true; }
    }


    local procedure GetRuleCaptionString(Index: Integer): Text
    begin
        if (Index in [1 .. 8]) then begin
            if not DimensionNamesRetrieved then begin
                DimensionsManagement.GetDimensionNames(DimensionNames);
                DimensionNamesRetrieved := true;
            end;
            exit(StrSubstNo(lvngRuleLabel, DimensionNames[Index]));
        end;
        exit('')
    end;

    var
        ExpressionList: Page lvngExpressionList;
        DimensionsManagement: Codeunit lvngDimensionsManagement;
        DimensionNamesRetrieved: Boolean;
        DimensionNames: array[8] of Text;
        ConditionsMgmt: Codeunit lvngConditionsMgmt;
        lvngRuleLabel: Label '%1 Rule';
}