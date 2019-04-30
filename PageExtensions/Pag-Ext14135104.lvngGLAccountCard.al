pageextension 14135104 "lvngGLAccountCard" extends "G/L Account Card" //MyTargetPageId
{
    layout
    {
        addafter(General)
        {
            group(lvngLoanVision)
            {
                Caption = 'Loan Vision';

                field(lvngReportingAccountName; lvngReportingAccountName)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNoMandatory; lvngLoanNoMandatory)
                {
                    ApplicationArea = All;
                }
                field(lvngReconciliationFieldNo; lvngReconciliationFieldNo)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}