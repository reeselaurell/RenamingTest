query 14135104 lvngGLEntriesByLoanSums
{
    Caption = 'G/L Entries By Loan Sums';
    QueryType = Normal;

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            filter(GLAccountNoFilter; "G/L Account No.") { }
            filter(PostingDateFilter; "Posting Date") { }
            filter(LoanNoFilter; lvngLoanNo) { }
            column(GLAccount; "G/L Account No.") { }
            column(LoanNo; lvngLoanNo) { }
            column(DebitAmount; "Debit Amount") { Method = Sum; }
            column(CreditAmount; "Credit Amount") { Method = Sum; }

            dataitem(Loan; lvngLoan)
            {
                DataItemLink = "No." = GLEntry.lvngLoanNo;

                column(BorrowerFirstName; "Borrower First Name") { }
                column(BorrowerMiddleName; "Borrower Middle Name") { }
                column(BorrowerLastName; "Borrower Last Name") { }
                column(DateFunded; "Date Funded") { }
                column(DateSold; "Date Sold") { }
                column(InvestorCustomerNo; "Investor Customer No.") { }
            }
        }
    }
}