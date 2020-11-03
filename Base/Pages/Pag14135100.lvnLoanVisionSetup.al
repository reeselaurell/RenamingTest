page 14135100 "lvnLoanVisionSetup"
{

    PageType = Card;
    SourceTable = lvnLoanVisionSetup;
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

                    field("Funded Reason Code"; Rec."Funded Reason Code") { ApplicationArea = All; }
                    field("Funded Void Reason Code"; Rec."Funded Void Reason Code") { ApplicationArea = All; }
                    field("Sold Reason Code"; Rec."Sold Reason Code") { ApplicationArea = All; }
                    field("Sold Void Reason Code"; Rec."Sold Void Reason Code") { ApplicationArea = All; }
                }
                group(SourceCodes)
                {
                    Caption = 'Source Codes';

                    field("Funded Source Code"; Rec."Funded Source Code") { ApplicationArea = All; }
                    field("Sold Source Code"; Rec."Sold Source Code") { ApplicationArea = All; }
                }
                group(Misc)
                {
                    Caption = 'Miscellaneous';

                    field("Search Name Template"; Rec."Search Name Template") { ApplicationArea = All; ToolTip = '%1 - First Name, %2 - Last Name, %3 - Middle Name'; }
                    field("Loan Officer Name Template"; Rec."Loan Officer Name Template") { ApplicationArea = All; ToolTip = '%1 - First Name, %2 - Last Name, %3 - Middle Name'; }
                    field("Maintenance Mode"; Rec."Maintenance Mode") { ApplicationArea = All; }
                }
            }
            group(Dimensions)
            {
                group(GeneralDimensions)
                {
                    Caption = 'General';

                    field("Cost Center Dimension Code"; Rec."Cost Center Dimension Code") { ApplicationArea = All; }
                    field("Property State Dimension Code"; Rec."Property State Dimension Code") { ApplicationArea = All; }
                    field("Loan Type Dimension Code"; Rec."Loan Type Dimension Code") { ApplicationArea = All; }
                    field("Loan Officer Dimension Code"; Rec."Loan Officer Dimension Code") { ApplicationArea = All; }
                    field("Loan Purpose Dimension Code"; Rec."Loan Purpose Dimension Code") { ApplicationArea = All; }
                }
                group(HierarchyLevelsGroup)
                {
                    Caption = 'Hierarchy Levels';

                    field("Hierarchy Levels"; Rec."Hierarchy Levels") { ApplicationArea = All; }
                    field("Level 1"; Rec."Level 1") { Editable = Rec."Hierarchy Levels" > 0; ApplicationArea = All; }
                    field("Level 2"; Rec."Level 2") { Editable = Rec."Hierarchy Levels" > 1; ApplicationArea = All; }
                    field("Level 3"; Rec."Level 3") { Editable = Rec."Hierarchy Levels" > 2; ApplicationArea = All; }
                    field("Level 4"; Rec."Level 4") { Editable = Rec."Hierarchy Levels" > 3; ApplicationArea = All; }
                    field("Level 5"; Rec."Level 5") { Editable = Rec."Hierarchy Levels" > 4; ApplicationArea = All; }
                }
            }
            group(NoSeries)
            {
                Caption = 'No. Series';

                field("Funded No. Series"; Rec."Funded No. Series") { ApplicationArea = All; }
                field("Void Funded No. Series"; Rec."Void Funded No. Series") { ApplicationArea = All; }
                field("Sold No. Series"; Rec."Sold No. Series") { ApplicationArea = All; }
                field("Void Sold No. Series"; Rec."Void Sold No. Series") { ApplicationArea = All; }
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
                RunObject = page lvnLoanNoMatchPatterns;
                RunPageMode = Edit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
