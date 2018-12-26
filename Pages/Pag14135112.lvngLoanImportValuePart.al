page 14135112 "lvngLoanImportValuePart"
{
    PageType = ListPart;
    SourceTable = lvngLoanJournalValue;
    Caption = 'Values';

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

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}