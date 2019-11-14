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