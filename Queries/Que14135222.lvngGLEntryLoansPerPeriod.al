query 14135222 lvngGLEntryLoansPerPeriod
{
    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            filter(AccountNoFilter; "G/L Account No.") { }
            filter(Dim1Filter; "Global Dimension 1 Code") { }
            filter(Dim2Filter; "Global Dimension 2 Code") { }
            filter(PostingDateFilter; "Posting Date") { }
            filter(Dim3Filter; lvngShortcutDimension3Code) { }
            filter(Dim4Filter; lvngShortcutDimension4Code) { }
            filter(BUFilter; "Business Unit Code") { }
            dataitem(lvngLoan; lvngLoan)
            {
                DataItemLink = "Loan No." = G_L_Entry.lvngLoanNo;
                SqlJoinType = InnerJoin;

                column(LoanNo; "Loan No.") { }
            }
            column(PostingDate; "Posting Date") { }
            column(Count) { Method = Count; }
        }
    }
}