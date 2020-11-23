pageextension 14135104 "lvnGLAccountCard" extends "G/L Account Card"
{
    layout
    {
        addafter(General)
        {
            group(lvnLoanVision)
            {
                Caption = 'Loan Vision';

                field(lvnReportingAccountName; Rec.lvnReportingAccountName)
                {
                    ApplicationArea = All;
                }
                field(lvnLoanNoMandatory; Rec.lvnLoanNoMandatory)
                {
                    ApplicationArea = All;
                }
                field(lvnReconciliationFieldNo; Rec.lvnReconciliationFieldNo)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}