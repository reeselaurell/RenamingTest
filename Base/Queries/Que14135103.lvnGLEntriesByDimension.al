query 14135103 "lvnGLEntriesByDimension"
{
    QueryType = Normal;
    Caption = 'G/L Entries By Dimension';

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            column(SumAmount; Amount)
            {
                Method = Sum;
            }
            column(SumDebitAmount; "Debit Amount")
            {
                Method = Sum;
            }
            column(SumCreditAmount; "Credit Amount")
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
            filter(Dimension3Filter; lvnShortcutDimension3Code)
            {
            }
            filter(Dimension4Filter; lvnShortcutDimension4Code)
            {
            }
            filter(Dimension5Filter; lvnShortcutDimension5Code)
            {
            }
            filter(Dimension6Filter; lvnShortcutDimension6Code)
            {
            }
            filter(Dimension7Filter; lvnShortcutDimension7Code)
            {
            }
            filter(Dimension8Filter; lvnShortcutDimension8Code)
            {
            }
            filter(BusinessUnitFilter; "Business Unit Code")
            {
            }
            filter(LoanNoFilter; lvnLoanNo)
            {
            }
        }
    }
}