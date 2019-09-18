query 14135101 "lvngGLEntriesByLoanSums"
{
    QueryType = Normal;
    Caption = 'G/L Entries by Loan Sums';
    elements
    {
        dataitem(lvngGLEntry; "G/L Entry")
        {
            filter(lvngGLAccountNoFilter; "G/L Account No.")
            {

            }
            filter(lvngPostingDateFilter; "Posting Date")
            {

            }
            column(lvngGLAccount; "G/L Account No.")
            {

            }
            column(lvngLoanNo; lvngLoanNo)
            {

            }
            column(lvngDebitAmount; "Debit Amount")
            {
                Method = Sum;
            }
            column(lvngCreditAmount; "Credit Amount")
            {
                Method = Sum;
            }
            dataitem(lvngLoan; lvngLoan)
            {
                DataItemLink = lvngLoanNo = lvngGLEntry.lvngLoanNo;
                column(lvngBorrowerFirstName; lvngBorrowerFirstName)
                {

                }
                column(lvngBorrowerMiddleName; lvngBorrowerMiddleName)
                {

                }
                column(lvngBorrowerLastName; lvngBorrowerLastName)
                {

                }
                column(lvngDateFunded; lvngDateFunded)
                {

                }
                column(lvngDateSold; lvngDateSold)
                {

                }
                column(lvngInvestorCustomerNo; lvngInvestorCustomerNo)
                {

                }
            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}