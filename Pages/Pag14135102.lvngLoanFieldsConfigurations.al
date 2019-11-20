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
                field("Field No."; "Field No.") { ApplicationArea = All; }
                field("Field Name"; "Field Name") { ApplicationArea = All; }
                field("Value Type"; "Value Type") { ApplicationArea = All; }
            }
        }
    }
}