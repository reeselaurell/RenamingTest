page 14135314 "lvngCommissionProfileSubform"
{
    Caption = 'Profile Details';
    PageType = ListPart;
    SourceTable = lvngCommissionProfileLine;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngLineNo; lvngLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngPeriodIdentifierCode; lvngPeriodIdentifierCode)
                {
                    ApplicationArea = All;
                    Visible = lvngPeriodIdentifierVisible;
                }
                field(lvngLoanOfficerTypeCode; lvngLoanOfficerTypeCode)
                {
                    ApplicationArea = All;
                }
                field(lvngIdentifierCode; lvngIdentifierCode)
                {
                    ApplicationArea = All;
                }
                field(lvngSplitPercentage; lvngSplitPercentage)
                {
                    ApplicationArea = All;
                }
                field(lvngValidFromDate; lvngValidFromDate)
                {
                    ApplicationArea = All;
                }
                field(lvngValidToDate; lvngValidToDate)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanCalculationType; lvngLoanCalculationType)
                {
                    ApplicationArea = All;
                }
                field(lvngCalculationOnly; lvngCalculationOnly)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanLevelConditionCode; lvngLoanLevelConditionCode)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvngExpressionList;
                        ExpressiontType: Enum lvngExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(lvngCommissionSetup.GetCommissionId(), lvngCommissionSetup.GetLoanLevelExpressionCode(), lvngLoanLevelConditionCode, ExpressiontType::Condition);
                        if NewCode <> '' then
                            lvngLoanLevelConditionCode := NewCode;
                    end;
                }
                field(lvngPersonalProduction; lvngPersonalProduction)
                {
                    ApplicationArea = All;
                }
                field(lvngExtendedFilterCode; lvngExtendedFilterCode)
                {
                    ApplicationArea = All;
                }
                field(lvngMinCommissionAmount; lvngMinCommissionAmount)
                {
                    ApplicationArea = All;
                }
                field(lvngMaxCommissionAmount; lvngMaxCommissionAmount)
                {
                    ApplicationArea = All;
                }
                field(lvngParameter; lvngParameter)
                {
                    ApplicationArea = All;
                }
                field(lvngTierCode; lvngTierCode)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanLevelFunctionCode; lvngLoanLevelFunctionCode)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvngExpressionList;
                        ExpressiontType: Enum lvngExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(lvngCommissionSetup.GetCommissionId(), lvngCommissionSetup.GetLoanLevelExpressionCode(), lvngLoanLevelFunctionCode, ExpressiontType::Formula);
                        if NewCode <> '' then
                            lvngLoanLevelFunctionCode := NewCode;
                    end;
                }
                field(lvngTotalsBasedOnLineNo; lvngTotalsBasedOnLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngYTDStartingVolume; lvngYTDStartingVolume)
                {
                    ApplicationArea = All;
                }
                field(lvngYTDStartingUnits; lvngYTDStartingUnits)
                {
                    ApplicationArea = All;
                }
                field(lvngModificationTimestamp; lvngModificationTimestamp)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngUpdatedBy; lvngUpdatedBy)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

    var
        lvngCommissionSetup: Record lvngCommissionSetup;
        lvngPeriodIdentifierVisible: Boolean;
        lvngCommissionSetupRetrieved: Boolean;


    trigger OnInit()
    begin
        GetCommissionSetup();
        lvngPeriodIdentifierVisible := lvngCommissionSetup.lvngUsePeriodIdentifiers;
    end;

    trigger OnNewRecord(BelowRec: Boolean)
    begin
        if BelowRec then begin
            lvngLineNo := xRec.lvngLineNo + 100;
        end;
    end;

    local procedure GetCommissionSetup()
    begin
        if not lvngCommissionSetupRetrieved then begin
            lvngCommissionSetupRetrieved := true;
            lvngCommissionSetup.Get();
        end;
    end;

}