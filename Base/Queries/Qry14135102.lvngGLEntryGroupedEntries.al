query 14135102 lvngGLEntryGroupedEntries
{
    Caption = 'G/L Entry Grouped Entries';
    QueryType = Normal;

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            column(Posting_Date; "Posting Date") { }
            column(GLAccountNo; "G/L Account No.") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(ShortcutDimension3Code; lvngShortcutDimension3Code) { }
            column(ShortcutDimension4Code; lvngShortcutDimension4Code) { }
            column(ShortcutDimension5Code; lvngShortcutDimension5Code) { }
            column(ShortcutDimension6Code; lvngShortcutDimension6Code) { }
            column(ShortcutDimension7Code; lvngShortcutDimension7Code) { }
            column(ShortcutDimension8Code; lvngShortcutDimension8Code) { }
            column(BusinessUnitCode; "Business Unit Code") { }
            column(lvngLoanNo; lvngLoanNo) { }
            column(Amount; Amount) { Method = Sum; }
            column(DebitAmount; "Debit Amount") { Method = Sum; }
            column(CreditAmount; "Credit Amount") { Method = Sum; }

            filter(EntryNo; "Entry No.")
            {

            }
        }
    }
}