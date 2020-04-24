query 14135106 lvngAccountReconByLoan
{
    QueryType = Normal;

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            column(LoanNo; lvngLoanNo) { }
            filter(PostingDateFilter; "Posting Date") { }
            filter(GLAccountFilter; "G/L Account No.") { }
            filter(LoanNoFilter; lvngLoanNo) { }
            column(DebitAmount; "Debit Amount") { Method = Sum; }
            column(CreditAmount; "Credit Amount") { Method = Sum; }
        }
    }
}