query 14135104 "lvnGLEntriesByLoanSums"
{
    Caption = 'G/L Entries By Loan Sums';
    QueryType = Normal;

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            filter(GLAccountNoFilter; "G/L Account No.") { }
            filter(PostingDateFilter; "Posting Date") { }
            filter(LoanNoFilter; lvnLoanNo) { }
            column(GLAccount; "G/L Account No.") { }
            column(LoanNo; lvnLoanNo) { }
            column(DebitAmount; "Debit Amount") { Method = Sum; }
            column(CreditAmount; "Credit Amount") { Method = Sum; }

            dataitem(Loan; lvnLoan)
            {
                DataItemLink = "No." = GLEntry.lvnLoanNo;

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