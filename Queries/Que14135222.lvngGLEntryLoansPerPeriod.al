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
            filter(Dim3Filter; "Shortcut Dimension 3 Code") { }
            filter(Dim4Filter; "Shortcut Dimension 4 Code") { }
            filter(BUFilter; "Business Unit Code") { }
            dataitem(lvngLoan; lvngLoan)
            {
                DataItemLink = "No." = G_L_Entry."Loan No.";
                SqlJoinType = InnerJoin;

                column(LoanNo; "No.") { }
            }
            column(PostingDate; "Posting Date") { }
            column(Count) { Method = Count; }
        }
    }
}