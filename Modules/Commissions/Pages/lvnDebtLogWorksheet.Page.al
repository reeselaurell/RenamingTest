page 14135334 "lvnDebtLogWorksheet"
{
    Caption = 'Debt Log Worksheet';
    PageType = Worksheet;
    SourceTable = lvnDebtLogWorksheet;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field("Profile Code"; Rec."Profile Code")
                {
                    ApplicationArea = All;
                }
                field(LoanOfficerName; LoanOfficerName)
                {
                    Caption = 'Loan Officer Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cost Center Code"; Rec."Cost Center Code")
                {
                    ApplicationArea = All;
                }
                field("Additional Code"; Rec."Additional Code")
                {
                    ApplicationArea = All;
                }
                field("Max. Advance Balance"; Rec."Max. Advance Balance")
                {
                    ApplicationArea = All;
                }
                field("Starting Balance"; Rec."Starting Balance")
                {
                    ApplicationArea = All;
                }
                field("Minimum Advance"; Rec."Minimum Advance")
                {
                    ApplicationArea = All;
                }
                field("Max. Reduction Cap"; Rec."Max. Reduction Cap")
                {
                    ApplicationArea = All;
                }
                field("Commission Earned"; Rec."Commission Earned")
                {
                    ApplicationArea = All;
                }
                field(Draws; Draws)
                {
                    Caption = 'Draws';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Recovery; Recovery)
                {
                    Caption = 'Recovery';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Other; Other)
                {
                    Caption = 'Other';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Draw/Recovery"; Rec."Total Draw/Recovery")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CommissionProfile: Record lvnCommissionProfile;
    begin
        CommissionProfile.Get(Rec."Profile Code");
        LoanOfficerName := CommissionProfile.Name;
    end;

    var
        LoanOfficerName: Text;
        Draws: Decimal;
        Recovery: Decimal;
        Other: Decimal;
}