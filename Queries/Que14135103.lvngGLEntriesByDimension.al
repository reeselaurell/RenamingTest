query 14135103 lvngGLEntriesByDimension
{
    QueryType = Normal;
    Caption = 'G/L Entries By Dimension';

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            column(SumAmount; Amount) { Method = Sum; }
            column(SumDebitAmount; "Debit Amount") { Method = Sum; }
            column(SumCreditAmount; "Credit Amount") { Method = Sum; }
            filter(GLAccountNoFilter; "G/L Account No.") { }
            filter(PostingDateFilter; "Posting Date") { }
            filter(Dimension1Filter; "Global Dimension 1 Code") { }
            filter(Dimension2Filter; "Global Dimension 2 Code") { }
            filter(Dimension3Filter; lvngShortcutDimension3Code) { }
            filter(Dimension4Filter; lvngShortcutDimension4Code) { }
            filter(Dimension5Filter; lvngShortcutDimension5Code) { }
            filter(Dimension6Filter; lvngShortcutDimension6Code) { }
            filter(Dimension7Filter; lvngShortcutDimension7Code) { }
            filter(Dimension8Filter; lvngShortcutDimension8Code) { }
            filter(BusinessUnitFilter; "Business Unit Code") { }
            filter(LoanNoFilter; lvngLoanNo) { }
        }
    }
}