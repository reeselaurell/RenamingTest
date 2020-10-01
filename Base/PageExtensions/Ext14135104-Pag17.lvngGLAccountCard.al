pageextension 14135104 lvngGLAccountCard extends "G/L Account Card"
{
    layout
    {
        addafter(General)
        {
            group(lvngLoanVision)
            {
                Caption = 'Loan Vision';

                field(lvngReportingAccountName; Rec.lvngReportingAccountName) { ApplicationArea = All; }
                field(lvngLoanNoMandatory; Rec.lvngLoanNoMandatory) { ApplicationArea = All; }
                field(lvngReconciliationFieldNo; Rec.lvngReconciliationFieldNo) { ApplicationArea = All; }
            }
        }
    }
}