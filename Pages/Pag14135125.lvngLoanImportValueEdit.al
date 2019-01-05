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
                field(lvngFieldNo; lvngFieldNo)
                {
                    ApplicationArea = All;
                }
                field(lvngFieldName; lvngFieldName)
                {
                    ApplicationArea = All;
                }
                field(lvngFieldValue; lvngFieldValue)
                {
                    ApplicationArea = All;
                }


            }
        }
    }
}