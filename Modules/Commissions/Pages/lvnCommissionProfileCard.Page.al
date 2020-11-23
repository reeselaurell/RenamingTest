page 14135313 "lvnCommissionProfileCard"
{
    Caption = 'Commission Profile Card';
    PageType = Card;
    SourceTable = lvnCommissionProfile;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Additional Code"; Rec."Additional Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(CostCenterCode; Rec."Cost Center Code")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field(CreationDateTime; Rec."Creation DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
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
            group(DebtLog)
            {
                Caption = 'Debt Log';

                field(DebtLogCalculation; Rec."Debt Log Calculation")
                {
                    ApplicationArea = All;
                }
                field(DebtLogLOType; Rec."Debt Log LO Type")
                {
                    ApplicationArea = All;
                }
                field(MinimumAdvance; Rec."Minimum Advance")
                {
                    ApplicationArea = All;
                }
                field(MaxAdvanceBalance; Rec."Max. Advance Balance")
                {
                    ApplicationArea = All;
                }
                field(MaxReductionCap; Rec."Max. Reduction Cap")
                {
                    ApplicationArea = All;
                }
                field(CommissionIdentifierFilter; Rec."Commission Identifier Filter")
                {
                    ApplicationArea = All;
                }
                field(CurrentBalance; Rec."Current Balance")
                {
                    ApplicationArea = All;
                }
            }
            part(CommissionLoanLevelSubform; lvnCommissionLoanLevelSubform)
            {
                Caption = 'Loan Level Details';
                ApplicationArea = All;
                SubPageLink = "Profile Code" = field(Code), "Profile Line Type" = const("Loan Level");
            }
            part(CommissionPeriodLvlSubform; lvnCommissionPeriodLvlSubform)
            {
                Caption = 'Period Level Details';
                ApplicationArea = All;
                SubPageLink = "Profile Code" = field(Code), "Profile Line Type" = const("Period Level");
            }
        }
    }
}