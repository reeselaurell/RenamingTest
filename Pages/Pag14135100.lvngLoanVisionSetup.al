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

                group(lvngReasonCodes)
                {
                    Caption = 'Reason Codes';

                    field(lvngFundedReasonCode; "Funded Reason Code") { ApplicationArea = All; }
                    field(lvngFundedVoidReasonCode; "Funded Void Reason Code") { ApplicationArea = All; }
                    field(lvngSoldReasonCode; "Sold Reason Code") { ApplicationArea = All; }
                    field(lvngSoldVoidReasonCode; "Sold Void Reason Code") { ApplicationArea = All; }
                }
                group(lvngSourceCodes)
                {
                    Caption = 'Source Codes';

                    field(lvngFundedSourceCode; "Funded Source Code") { ApplicationArea = All; }
                    field(lvngSoldSourceCode; "Sold Source Code") { ApplicationArea = All; }
                }
                group(lvngMisc)
                {
                    Caption = 'Miscellaneous';

                    field(lvngSearchNameTemplate; "Search Name Template") { ApplicationArea = All; ToolTip = '%1 - First Name, %2 - Last Name, %3 - Middle Name'; }
                    field(lvngLoanOfficerNameTemplate; "Loan Officer Name Template") { ApplicationArea = All; ToolTip = '%1 - First Name, %2 - Last Name, %3 - Middle Name'; }
                    field(MaintenanceMode; "Maintenance Mode") { ApplicationArea = All; }
                }
            }
            group(Dimensions)
            {
                group(GeneralDimensions)
                {
                    Caption = 'General';

                    field(CostCenter; "Cost Center Dimension Code") { ApplicationArea = All; }
                    field(PropertyStateCode; "Property State Dimension Code") { ApplicationArea = All; }
                    field(LoanTypeCode; "Loan Type Dimension Code") { ApplicationArea = All; }
                    field(LoanOfficerCode; "Loan Officer Dimension Code") { ApplicationArea = All; }
                    field(LoanPurposeCode; "Loan Purpose Dimension Code") { ApplicationArea = All; }
                }
                group(HierarchyLevelsGroup)
                {
                    Caption = 'Hierarchy Levels';

                    field(HierarchyLevels; "Hierarchy Levels") { ApplicationArea = All; }
                    field(HierarchyLevel1; "Level 1") { Editable = "Hierarchy Levels" > 0; ApplicationArea = All; }
                    field(HierarchyLevel2; "Level 2") { Editable = "Hierarchy Levels" > 1; ApplicationArea = All; }
                    field(HierarchyLevel3; "Level 3") { Editable = "Hierarchy Levels" > 2; ApplicationArea = All; }
                    field(HierarchyLevel4; "Level 4") { Editable = "Hierarchy Levels" > 3; ApplicationArea = All; }
                    field(HierarchyLevel5; "Level 5") { Editable = "Hierarchy Levels" > 4; ApplicationArea = All; }
                }
            }
            group(lvngNoSeries)
            {
                Caption = 'No. Series';

                field(lvngFundedNoSeries; "Funded No. Series") { ApplicationArea = All; }
                field(lvngVoidFundedNoSeries; "Void Funded No. Series") { ApplicationArea = All; }
                field(lvngSoldNoSeries; "Sold No. Series") { ApplicationArea = All; }
                field(lvngVoidSoldNoSeries; "Void Sold No. Series") { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(lvngLoanMatchingPatterns)
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
