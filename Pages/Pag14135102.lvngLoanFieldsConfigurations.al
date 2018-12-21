page 14135102 lvngLoanFieldsConfiguration
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoanFieldsConfiguration;
    Caption = 'Loan Fields Configuration';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(FieldsNo; lvngFieldNo)
                {
                    ApplicationArea = All;
                }

                field(FieldName; lvngFieldName)
                {
                    ApplicationArea = All;
                }

                field(ValueType; lvngValueType)
                {
                    ApplicationArea = All;
                }



            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}