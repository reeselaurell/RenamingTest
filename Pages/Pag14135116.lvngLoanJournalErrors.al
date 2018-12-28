page 14135116 "lvngLoanJournalErrors"
{
    PageType = ListPart;
    SourceTable = lvngLoanImportErrorLine;
    Caption = 'Loan Journal Errors';
    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}