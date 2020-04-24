query 14135109 lvngGLEntryLoansPerPeriod
{
    elements
    {
        dataitem(GroupedLoanGLEntry; lvngGroupedLoanGLEntry)
        {
            filter(AccountNoFilter; "G/L Account No.") { }
            filter(Dim1Filter; "Global Dimension 1 Code") { }
            filter(Dim2Filter; "Global Dimension 2 Code") { }
            filter(PostingDateFilter; "Posting Date") { }
            filter(Dim3Filter; "Shortcut Dimension 3 Code") { }
            filter(Dim4Filter; "Shortcut Dimension 4 Code") { }
            filter(BUFilter; "Business Unit Code") { }
            dataitem(Loan; lvngLoan)
            {
                DataItemLink = "No." = GroupedLoanGLEntry."Loan No.";
                SqlJoinType = InnerJoin;

                column(LoanNo; "No.") { }
            }
            column(PostingDate; "Posting Date") { }
            column(Count) { Method = Count; }
        }
    }
}