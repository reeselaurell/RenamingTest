page 14135102 lvngLoanFieldsConfiguration
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoanFieldsConfiguration;
    Caption = 'Loan Fields Configuration';
    DelayedInsert = true;

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
    }
}