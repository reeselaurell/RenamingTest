page 14135314 "lvnCommissionLoanLevelSubform"
{
    Caption = 'Loan Level Details';
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
                field(LoanCalculationType; Rec."Loan Calculation Type")
                {
                    ApplicationArea = All;
                }
                field(CalculationOnly; Rec."Calculation Only")
                {
                    ApplicationArea = All;
                }
                field(LoanLevelConditionCode; Rec."Loan Level Condition Code")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvnExpressionList;
                        ExpressiontType: Enum lvnExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(CommissionHelper.GetCommissionConsumerId(), CommissionHelper.GetLoanLevelExpressionCode(), Rec."Loan Level Condition Code", ExpressiontType::Condition);
                        if NewCode <> '' then
                            Rec."Loan Level Condition Code" := NewCode;
                    end;
                }
                field(PersonalProduction; Rec."Personal Production")
                {
                    ApplicationArea = All;
                }
                field(ExtendedFilterCode; Rec."Extended Filter Code")
                {
                    ApplicationArea = All;
                }
                field(MinCommissionAmount; Rec."Min. Commission Amount")
                {
                    ApplicationArea = All;
                }
                field(MaxCommissionAmount; Rec."Max. Commission Amount")
                {
                    ApplicationArea = All;
                }
                field(Parameter; Rec.Parameter)
                {
                    ApplicationArea = All;
                }
                field(TierCode; Rec."Tier Code")
                {
                    ApplicationArea = All;
                }
                field(LoanLevelFunctionCode; Rec."Loan Level Function Code")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvnExpressionList;
                        ExpressiontType: Enum lvnExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(CommissionHelper.GetCommissionConsumerId(), CommissionHelper.GetLoanLevelExpressionCode(), Rec."Loan Level Function Code", ExpressiontType::Formula);
                        if NewCode <> '' then
                            Rec."Loan Level Function Code" := NewCode;
                    end;
                }
                field(TotalsBasedOnLineNo; Rec."Totals Based On Line No.")
                {
                    ApplicationArea = All;
                }
                field(YTDStartingVolume; Rec."YTD Starting Volume")
                {
                    ApplicationArea = All;
                }
                field(YTDStartingUnits; Rec."YTD Starting Units")
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
        Rec."Profile Line Type" := Rec."Profile Line Type"::"Loan Level";
    end;

    var
        CommissionSetup: Record lvnCommissionSetup;
        CommissionHelper: Codeunit lvnCommissionCalcHelper;
        PeriodIdentifierVisible: Boolean;
}