page 14135112 "lvngLoanImportValuePart"
{
    PageType = ListPart;
    SourceTable = lvngLoanJournalValue;
    Caption = 'Values';
    DeleteAllowed = false;
    Editable = false;

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