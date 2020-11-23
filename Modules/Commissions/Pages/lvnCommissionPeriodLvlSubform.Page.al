page 14135319 "lvnCommissionPeriodLvlSubform"
{
    Caption = 'Period Level Details';
    PageType = ListPart;
    SourceTable = lvnCommissionProfileLine;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(PeriodIdentifierCode; Rec."Period Identifier Code")
                {
                    ApplicationArea = All;
                    Visible = PeriodIdentifierVisible;
                }
                field(LoanOfficerTypeCode; Rec."Loan Officer Type Code")
                {
                    ApplicationArea = All;
                }
                field(IdentifierCode; Rec."Identifier Code")
                {
                    ApplicationArea = All;
                }
                field(SplitPercentage; Rec."Split Percentage")
                {
                    ApplicationArea = All;
                }
                field(ValidFromDate; Rec."Valid From Date")
                {
                    ApplicationArea = All;
                }
                field(ValidToDate; Rec."Valid To Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(PeriodCalculationType; Rec."Period Calculation Type")
                {
                    ApplicationArea = All;
                }
                field(PeriodLevelConditionCode; Rec."Period Level Condition Code")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvnExpressionList;
                        ExpressiontType: Enum lvnExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(CommissionHelper.GetCommissionConsumerId(), CommissionHelper.GetPeriodLevelExpressionCode(), Rec."Period Level Condition Code", ExpressiontType::Condition);
                        if NewCode <> '' then
                            Rec."Period Level Condition Code" := NewCode;
                    end;
                }
                field(Parameter; Rec.Parameter)
                {
                    ApplicationArea = All;
                }
                field(TierCode; Rec."Tier Code")
                {
                    ApplicationArea = All;
                }
                field(PeriodLevelFunctionCode; Rec."Period Level Function Code")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvnExpressionList;
                        ExpressiontType: Enum lvnExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(CommissionHelper.GetCommissionConsumerId(), CommissionHelper.GetPeriodLevelExpressionCode(), Rec."Period Level Function Code", ExpressiontType::Formula);
                        if NewCode <> '' then
                            Rec."Period Level Function Code" := NewCode;
                    end;
                }
                field(TotalsBasedOnLineNo; Rec."Totals Based On Line No.")
                {
                    ApplicationArea = All;
                }
                field(ModificationDateTime; Rec."Modification DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(UpdatedBy; Rec."Updated By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(PeriodType; Rec."Period Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CommissionSetup.Get();
        PeriodIdentifierVisible := CommissionSetup."Use Period Identifiers";
    end;

    trigger OnNewRecord(BelowRec: Boolean)
    begin
        Rec."Profile Line Type" := Rec."Profile Line Type"::"Period Level";
    end;

    var
        CommissionSetup: Record lvnCommissionSetup;
        CommissionHelper: Codeunit lvnCommissionCalcHelper;
        PeriodIdentifierVisible: Boolean;
}