page 14135100 lvngLoanVisionSetup
{

    PageType = Card;
    SourceTable = lvngLoanVisionSetup;
    Caption = 'Loan Vision Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                group(ReasonCodes)
                {
                    Caption = 'Reason Codes';

                    field("Funded Reason Code"; "Funded Reason Code") { ApplicationArea = All; }
                    field("Funded Void Reason Code"; "Funded Void Reason Code") { ApplicationArea = All; }
                    field("Sold Reason Code"; "Sold Reason Code") { ApplicationArea = All; }
                    field("Sold Void Reason Code"; "Sold Void Reason Code") { ApplicationArea = All; }
                }
                group(SourceCodes)
                {
                    Caption = 'Source Codes';

                    field("Funded Source Code"; "Funded Source Code") { ApplicationArea = All; }
                    field("Sold Source Code"; "Sold Source Code") { ApplicationArea = All; }
                }
                group(Misc)
                {
                    Caption = 'Miscellaneous';

                    field("Search Name Template"; "Search Name Template") { ApplicationArea = All; ToolTip = '%1 - First Name, %2 - Last Name, %3 - Middle Name'; }
                    field("Loan Officer Name Template"; "Loan Officer Name Template") { ApplicationArea = All; ToolTip = '%1 - First Name, %2 - Last Name, %3 - Middle Name'; }
                    field("Maintenance Mode"; "Maintenance Mode") { ApplicationArea = All; }
                }
            }
            group(Dimensions)
            {
                group(GeneralDimensions)
                {
                    Caption = 'General';

                    field("Cost Center Dimension Code"; "Cost Center Dimension Code") { ApplicationArea = All; }
                    field("Property State Dimension Code"; "Property State Dimension Code") { ApplicationArea = All; }
                    field("Loan Type Dimension Code"; "Loan Type Dimension Code") { ApplicationArea = All; }
                    field("Loan Officer Dimension Code"; "Loan Officer Dimension Code") { ApplicationArea = All; }
                    field("Loan Purpose Dimension Code"; "Loan Purpose Dimension Code") { ApplicationArea = All; }
                }
                group(HierarchyLevelsGroup)
                {
                    Caption = 'Hierarchy Levels';

                    field("Hierarchy Levels"; "Hierarchy Levels") { ApplicationArea = All; }
                    field("Level 1"; "Level 1") { Editable = "Hierarchy Levels" > 0; ApplicationArea = All; }
                    field("Level 2"; "Level 2") { Editable = "Hierarchy Levels" > 1; ApplicationArea = All; }
                    field("Level 3"; "Level 3") { Editable = "Hierarchy Levels" > 2; ApplicationArea = All; }
                    field("Level 4"; "Level 4") { Editable = "Hierarchy Levels" > 3; ApplicationArea = All; }
                    field("Level 5"; "Level 5") { Editable = "Hierarchy Levels" > 4; ApplicationArea = All; }
                }
            }
            group(NoSeries)
            {
                Caption = 'No. Series';

                field("Funded No. Series"; "Funded No. Series") { ApplicationArea = All; }
                field("Void Funded No. Series"; "Void Funded No. Series") { ApplicationArea = All; }
                field("Sold No. Series"; "Sold No. Series") { ApplicationArea = All; }
                field("Void Sold No. Series"; "Void Sold No. Series") { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(LoanMatchingPatterns)
            {
                Caption = 'Loan No. Match Patterns';
                ApplicationArea = All;
                Image = CheckRulesSyntax;
                RunObject = page lvngLoanNoMatchPatterns;
                RunPageMode = Edit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}
