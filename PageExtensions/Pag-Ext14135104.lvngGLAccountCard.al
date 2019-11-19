pageextension 14135104 "lvngGLAccountCard" extends "G/L Account Card" //MyTargetPageId
{
    layout
    {
        addafter(General)
        {
            group(lvngLoanVision)
            {
                Caption = 'Loan Vision';

                field(lvngReportingAccountName; "Reporting Account Name")
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNoMandatory; "Loan No. Mandatory")
                {
                    ApplicationArea = All;
                }
                field(lvngReconciliationFieldNo; "Reconciliation Field No.")
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