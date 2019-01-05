page 14135116 "lvngLoanJournalErrors"
{
    PageType = ListPart;
    SourceTable = lvngLoanImportErrorLine;
    Caption = 'Loan Journal Errors';
    Editable = false;

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