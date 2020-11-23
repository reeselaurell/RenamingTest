page 14135323 "lvnLoanCommissionerRolecenter"
{
    PageType = RoleCenter;
    Caption = 'Loan Commissions';

    actions
    {
        area(Processing)
        {
            action(LoanList)
            {
                ApplicationArea = All;
                Caption = 'Loan List';
                RunObject = page lvnLoanList;
            }
            action(Profiles)
            {
                ApplicationArea = All;
                Caption = 'Profiles';
                RunObject = page lvnCommissionProfiles;
            }
            action(Commissions)
            {
                ApplicationArea = All;
                Caption = 'Commission Schedule';
                RunObject = page lvnCommissionSchedules;
            }
        }
        area(Sections)
        {
            group(Setup)
            {
                Caption = 'Setup';

                action(LoanVisionSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Loan Vision Setup';
                    RunObject = page lvnLoanVisionSetup;
                }
                action(CommissionSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Commissions Setup';
                    RunObject = page lvnCommissionSetup;
                }
            }
        }
    }
}