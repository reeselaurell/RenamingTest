page 14135119 "lvngJournalValidationRules"
{
    PageType = List;
    Caption = 'Loan Journal Validation Rules';
    SourceTable = lvngJournalValidationRule;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngLineNo; "Line No.")
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; Description)
                {
                    ApplicationArea = All;
                }
                field(lvngConditionCode; "Condition Code")
                {
                    ApplicationArea = All;
                }
                field(lvngErrorMessage; "Error Message")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}