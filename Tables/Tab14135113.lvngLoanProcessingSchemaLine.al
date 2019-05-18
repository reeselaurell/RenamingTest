table 14135113 "lvngLoanProcessingSchemaLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Processing Schema Line';
    fields
    {
        field(1; lvngProcessingCode; Code[20])
        {
            Caption = 'Processing Code';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanProcessingSchema;
        }
        field(2; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }

        field(10; lvngProcessingSourceType; Enum lvngProcessingSourceType)
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
        }


        field(11; lvngFieldNo; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
        }

        field(12; lvngFunctionCode; Code[20])
        {
            Caption = 'Function Code';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                lvngSelectedFunctionCode: Code[20];
            begin
                Clear(lvngExpressionList);
                lvngSelectedFunctionCode := lvngExpressionList.SelectExpression('JOURNAL');
                if lvngSelectedFunctionCode <> '' then
                    lvngFunctionCode := lvngSelectedFunctionCode;
            end;
        }

        field(13; lvngDescription; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(14; lvngAccountType; enum lvngAccountType)
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(15; lvngAccountNo; code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(16; lvngAccountNoSwitchCode; Code[20])
        {
            Caption = 'Account No. Switch Code';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                lvngSelectedSwitchCode: Code[20];
            begin
                Clear(lvngExpressionList);
                lvngSelectedSwitchCode := lvngExpressionList.SelectExpression('JOURNAL');
                if lvngSelectedSwitchCode <> '' then
                    lvngAccountNoSwitchCode := lvngSelectedSwitchCode;
            end;
        }
        field(17; lvngConditionCode; Code[20])
        {
            Caption = 'Condition Code';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                lvngSelectedConditionCode: Code[20];
            begin
                Clear(lvngExpressionList);
                lvngSelectedConditionCode := lvngExpressionList.SelectExpression('JOURNAL');
                if lvngSelectedConditionCode <> '' then
                    lvngConditionCode := lvngSelectedConditionCode;
            end;
        }

        field(18; lvngTagCode; Code[10])
        {
            Caption = 'Tag Code';
            DataClassification = CustomerContent;
        }
        field(20; "lvngReverseSign"; Boolean)
        {
            Caption = 'Reverse Sign';
            DataClassification = CustomerContent;
        }

        field(21; lvngBalancingEntry; Boolean)
        {
            Caption = 'Balancing Entry';
            DataClassification = CustomerContent;
        }

        field(22; lvngOverrideReasonCode; Code[10])
        {
            Caption = 'Override Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }

        field(80; lvngGlobalDimension1Code; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (1));
        }
        field(81; lvngGlobalDimension2Code; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (2));
        }
        field(82; lvngShortcutDimension3Code; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (3));
        }
        field(83; lvngShortcutDimension4Code; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (4));
        }
        field(84; lvngShortcutDimension5Code; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (5));
        }
        field(85; lvngShortcutDimension6Code; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (6));
        }
        field(86; lvngShortcutDimension7Code; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (7));
        }
        field(87; lvngShortcutDimension8Code; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (8));
        }

        field(88; lvngBusinessUnitCode; Code[10])
        {
            Caption = 'Business Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Business Unit";
        }
        field(200; lvngServicingType; enum lvngServicingType)
        {
            Caption = 'Servicing Type';
            DataClassification = CustomerContent;
        }
        field(1000; lvngDimension1Rule; enum lvngProcessingDimensionRule)
        {
            Caption = 'Dimension 1 Rule';
            CaptionClass = GetRuleCaptionString(1);
            DataClassification = CustomerContent;
        }
        field(1001; lvngDimension2Rule; enum lvngProcessingDimensionRule)
        {
            Caption = 'Dimension 2 Rule';
            CaptionClass = GetRuleCaptionString(2);
            DataClassification = CustomerContent;
        }
        field(1002; lvngDimension3Rule; enum lvngProcessingDimensionRule)
        {
            Caption = 'Dimension 3 Rule';
            CaptionClass = GetRuleCaptionString(3);
            DataClassification = CustomerContent;
        }
        field(1003; lvngDimension4Rule; enum lvngProcessingDimensionRule)
        {
            Caption = 'Dimension 4 Rule';
            CaptionClass = GetRuleCaptionString(4);
            DataClassification = CustomerContent;
        }
        field(1004; lvngDimension5Rule; enum lvngProcessingDimensionRule)
        {
            Caption = 'Dimension 5 Rule';
            CaptionClass = GetRuleCaptionString(5);
            DataClassification = CustomerContent;
        }
        field(1005; lvngDimension6Rule; enum lvngProcessingDimensionRule)
        {
            Caption = 'Dimension 6 Rule';
            CaptionClass = GetRuleCaptionString(6);
            DataClassification = CustomerContent;
        }
        field(1006; lvngDimension7Rule; enum lvngProcessingDimensionRule)
        {
            Caption = 'Dimension 7 Rule';
            CaptionClass = GetRuleCaptionString(7);
            DataClassification = CustomerContent;
        }
        field(1007; lvngDimension8Rule; enum lvngProcessingDimensionRule)
        {
            Caption = 'Dimension 8 Rule';
            CaptionClass = GetRuleCaptionString(8);
            DataClassification = CustomerContent;
        }
        field(1008; lvngBusinessUnitRule; enum lvngProcessingDimensionRule)
        {
            Caption = 'Business Unit Rule';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngProcessingCode, lvngLineNo)
        {
            Clustered = true;
        }
    }


    local procedure GetRuleCaptionString(lvngIndex: Integer): Text
    var
        lvngRuleLabel: Label '%1 Rule';

    begin
        if (lvngIndex in [1 .. 8]) then begin
            if not lvngDimensionNamesRetrieved then begin
                lvngDimensionsManagement.GetDimensionNames(DimensionNames);
                lvngDimensionNamesRetrieved := true;
            end;
            exit(StrSubstNo(lvngRuleLabel, DimensionNames[lvngIndex]));
        end;
        exit('')
    end;

    var

        lvngExpressionList: page lvngExpressionList;
        lvngDimensionsManagement: Codeunit lvngDimensionsManagement;
        lvngDimensionNamesRetrieved: Boolean;
        DimensionNames: array[8] of Text;



}