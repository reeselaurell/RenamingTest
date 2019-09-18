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
            filter(Dimension3Filter; lvngShortcutDimension3Code)
            {

            }
            filter(Dimension4Filter; lvngShortcutDimension4Code)
            {

            }
            filter(Dimension5Filter; lvngShortcutDimension5Code)
            {

            }
            filter(Dimension6Filter; lvngShortcutDimension6Code)
            {

            }
            filter(Dimension7Filter; lvngShortcutDimension7Code)
            {

            }
            filter(Dimension8Filter; lvngShortcutDimension8Code)
            {

            }
            filter(BusinessUnitFilter; "Business Unit Code")
            {

            }
            filter(LoanNoFilter; lvngLoanNo)
            {

            }
        }
    }
}