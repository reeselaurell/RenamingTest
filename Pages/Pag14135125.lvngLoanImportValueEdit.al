page 14135125 "lvngLoanImportValueEdit"
{
    PageType = List;
    SourceTable = lvngLoanJournalValue;
    Caption = 'Edit Values';
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(lvngValues)
            {
                field(lvngFieldNo; "Field No.")
                {
                    ApplicationArea = All;
                }
                field(lvngFieldName; "Field Name")
                {
                    ApplicationArea = All;
                }
                field(lvngFieldValue; "Field Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}