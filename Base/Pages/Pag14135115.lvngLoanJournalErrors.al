page 14135115 lvngLoanJournalErrors
{
    PageType = ListPart;
    SourceTable = lvngLoanImportErrorLine;
    Caption = 'Loan Journal Errors';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Description; Description) { ApplicationArea = All; }
            }
        }
    }
}