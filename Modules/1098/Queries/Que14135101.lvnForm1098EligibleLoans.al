query 14135101 "lvnForm1098EligibleLoans"
{
    Caption = 'Form 1098 Eligible Loans';

    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            column(LoanNo; lvnLoanNo) { }
            column(Count) { Method = Count; }
            filter(DateFilter; "Posting Date") { }
            filter(GLAccountFilter; "G/L Account No.") { }
            filter(ReasonCodeFilter; "Reason Code") { }
            filter(ServicingTypeFilter; lvnServicingType) { }
            filter(Reversed; Reversed) { }
        }
    }
}