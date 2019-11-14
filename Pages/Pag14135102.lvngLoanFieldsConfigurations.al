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
                field(FieldsNo; "Field No.")
                {
                    ApplicationArea = All;
                }

                field(FieldName; "Field Name")
                {
                    ApplicationArea = All;
                }

                field(ValueType; "Value Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}