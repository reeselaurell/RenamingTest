page 14135406 lvngBranchDashboardRolecenter
{
    PageType = RoleCenter;
    Caption = 'Branch Dashboard Rolecenter';

    layout
    {
        area(RoleCenter)
        {
            part(Dashboard; lvngBranchDashboardPart) { ApplicationArea = All; }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ApprovalDocuments)
            {
                Caption = 'Approval Documents';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page "Requests to Approve";
                ApplicationArea = All;
            }
        }
    }
}