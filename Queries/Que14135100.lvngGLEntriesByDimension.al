query 14135100 lvngGLEntriesByDimension
{
    QueryType = Normal;
    Caption = 'G/L Entries By Dimension';

    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            column(SumAmount; Amount)
            {
                Method = Sum;
            }
            column(Sum_Debit_Amount; "Debit Amount")
            {
                Method = Sum;
            }
            column(Sum_Credit_Amount; "Credit Amount")
            {
                Method = Sum;
            }
            filter(GLAccountNoFilter; "G/L Account No.")
            {

            }
            filter(PostingDateFilter; "Posting Date")
            {

            }
            filter(Dimension1Filter; "Global Dimension 1 Code")
            {

            }
            filter(Dimension2Filter; "Global Dimension 2 Code")
            {

            }
            filter(Dimension3Filter; "Shortcut Dimension 3 Code")
            {

            }
            filter(Dimension4Filter; "Shortcut Dimension 4 Code")
            {

            }
            filter(Dimension5Filter; "Shortcut Dimension 5 Code")
            {

            }
            filter(Dimension6Filter; "Shortcut Dimension 6 Code")
            {

            }
            filter(Dimension7Filter; "Shortcut Dimension 7 Code")
            {

            }
            filter(Dimension8Filter; "Shortcut Dimension 8 Code")
            {

            }
            filter(BusinessUnitFilter; "Business Unit Code")
            {

            }
            filter(LoanNoFilter; "Loan No.")
            {

            }
        }
    }
}