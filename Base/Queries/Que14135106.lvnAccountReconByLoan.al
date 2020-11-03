query 14135106 "lvnAccountReconByLoan"
{
    QueryType = Normal;

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            column(LoanNo; lvnLoanNo) { }
            filter(PostingDateFilter; "Posting Date") { }
            filter(GLAccountFilter; "G/L Account No.") { }
            filter(LoanNoFilter; lvnLoanNo) { }
            column(DebitAmount; "Debit Amount") { Method = Sum; }
            column(CreditAmount; "Credit Amount") { Method = Sum; }
        }
    }
}