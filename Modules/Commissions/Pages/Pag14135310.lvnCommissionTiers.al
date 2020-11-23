page 14135310 lvnCommissionTiers
{
    Caption = 'Commission Tiers';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnCommissionTierHeader;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(TierReturnValue; Rec."Tier Return Value")
                {
                    ApplicationArea = All;
                }
                field(TierType; Rec."Tier Type")
                {
                    ApplicationArea = All;
                }
                field(TierPayoutType; Rec."Tier Payout Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CheckEditablePayout();
                    end;
                }
                field(PayoutConditionCode; Rec."Payout Condition Code")
                {
                    ApplicationArea = All;
                    Editable = ConditionEditable;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvnExpressionList;
                        ExpressiontType: Enum lvnExpressionType;
                        NewCode: Code[20];
                    begin
                        if not ConditionEditable then
                            exit;
                        NewCode := ExpressionList.SelectExpression(CommissionHelper.GetCommissionConsumerId(), CommissionHelper.GetLoanLevelExpressionCode(), Rec."Payout Condition Code", ExpressiontType::Condition);
                        if NewCode <> '' then
                            Rec."Payout Condition Code" := NewCode;
                    end;
                }
                field(PayoutFieldNo; Rec."Payout Field No.")
                {
                    Editable = FieldsLookupEditable;
                    ApplicationArea = All;
                }
                field(PayoutCompareValue; Rec."Payout Compare Value")
                {
                    Editable = FieldsLookupEditable;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Tiers)
            {
                Caption = 'Tiers';
                ApplicationArea = All;
                RunObject = page lvnCommissionTiersBreakdown;
                RunPageLink = "Tier Code" = field(Code);
                Image = Percentage;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CheckEditablePayout();
    end;

    var
        CommissionHelper: Codeunit lvnCommissionCalcHelper;
        ConditionEditable: Boolean;
        FieldsLookupEditable: Boolean;

    local procedure CheckEditablePayout()
    begin
        ConditionEditable := Rec."Tier Payout Type" = Rec."Tier Payout Type"::Condition;
        FieldsLookupEditable := Rec."Tier Payout Type" = Rec."Tier Payout Type"::"Loan Value";
    end;
}