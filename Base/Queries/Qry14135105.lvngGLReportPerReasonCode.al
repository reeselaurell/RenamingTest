query 14135105 lvngGLReportPerReasonCode
{
    Caption = 'G/L Report Per Reason Code';
    QueryType = Normal;

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            column(GLAccountNo; "G/L Account No.") { }
            column(ReasonCode; "Reason Code") { }
            column(Amount; Amount) { Method = Sum; }
            column(DebitAmount; "Debit Amount") { Method = Sum; }
            column(CreditAmount; "Credit Amount") { Method = Sum; }
            column(DocumentType; "Document Type") { }
            column(SourceCode; "Source Code") { }
            filter(PostingDateFilter; "Posting Date") { }
            filter(EntryDateFilter; lvngEntryDate) { }
            filter(GLAccountNoFilter; "G/L Account No.") { }
            filter(ReasonCodeFilter; "Reason Code") { }
        }
    }
}