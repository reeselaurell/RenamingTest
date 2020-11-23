page 14135115 "lvnLoanJournalErrors"
{
    PageType = ListPart;
    SourceTable = lvnLoanImportErrorLine;
    Caption = 'Loan Journal Errors';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}