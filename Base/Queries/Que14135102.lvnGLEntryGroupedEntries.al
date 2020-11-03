query 14135102 "lvnGLEntryGroupedEntries"
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
            column(ShortcutDimension3Code; lvnShortcutDimension3Code) { }
            column(ShortcutDimension4Code; lvnShortcutDimension4Code) { }
            column(ShortcutDimension5Code; lvnShortcutDimension5Code) { }
            column(ShortcutDimension6Code; lvnShortcutDimension6Code) { }
            column(ShortcutDimension7Code; lvnShortcutDimension7Code) { }
            column(ShortcutDimension8Code; lvnShortcutDimension8Code) { }
            column(BusinessUnitCode; "Business Unit Code") { }
            column(lvnLoanNo; lvnLoanNo) { }
            column(Amount; Amount) { Method = Sum; }
            column(DebitAmount; "Debit Amount") { Method = Sum; }
            column(CreditAmount; "Credit Amount") { Method = Sum; }

            filter(EntryNoFilter; "Entry No.")
            {

            }
        }
    }
}