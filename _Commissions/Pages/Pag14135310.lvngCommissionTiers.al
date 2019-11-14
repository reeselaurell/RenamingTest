page 14135310 "lvngCommissionTiers"
{
    Caption = 'Commission Tiers';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngCommissionTierHeader;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngTierReturnValue; lvngTierReturnValue)
                {
                    ApplicationArea = All;
                }
                field(lvngTierType; lvngTierType)
                {
                    ApplicationArea = All;
                }
                field(lvngPayoutOption; lvngPayoutOption)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CheckEditablePayout();
                    end;
                }
                field(lvngPayoutConditionCode; lvngPayoutConditionCode)
                {
                    ApplicationArea = All;
                    Editable = lvngConditionEditable;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvngExpressionList;
                        ExpressiontType: Enum lvngExpressionType;
                        NewCode: Code[20];
                    begin
                        if not lvngConditionEditable then
                            exit;
                        NewCode := ExpressionList.SelectExpression(lvngCommissionSetup.GetCommissionId(), lvngCommissionSetup.GetLoanLevelExpressionCode(), lvngPayoutConditionCode, ExpressiontType::Condition);
                        if NewCode <> '' then
                            lvngPayoutConditionCode := NewCode;
                    end;
                }
                field(lvngPayoutFieldNo; lvngPayoutFieldNo)
                {
                    Editable = lvngFieldsLookupEditable;
                    ApplicationArea = All;
                }
                field(lvngPayoutCompareValue; lvngPayoutCompareValue)
                {
                    Editable = lvngFieldsLookupEditable;
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngTiers)
            {
                Caption = 'Tiers';
                ApplicationArea = All;
                RunObject = page lvngCommissionTiersBreakdown;
                RunPageLink = lvngCode = field(lvngCode);
                Image = Percentage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

            }
        }
    }

    local procedure CheckEditablePayout()
    begin
        lvngConditionEditable := false;
        lvngFieldsLookupEditable := false;
        if lvngPayoutOption = lvngPayoutOption::lvngCondition then
            lvngConditionEditable := true;
        if lvngPayoutOption = lvngPayoutOption::lvngLoanValue then
            lvngFieldsLookupEditable := true;
    end;

    trigger OnOpenPage()
    begin
        lvngCommissionSetup.Get();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CheckEditablePayout();
    end;

    var
        lvngCommissionSetup: Record lvngCommissionSetup;
        lvngConditionEditable: Boolean;
        lvngFieldsLookupEditable: Boolean;
}