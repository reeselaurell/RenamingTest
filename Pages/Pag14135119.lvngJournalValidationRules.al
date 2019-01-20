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
                field(lvngLineNo; lvngLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngConditionCode; lvngConditionCode)
                {
                    ApplicationArea = All;
                }
                field(lvngErrorMessage; lvngErrorMessage)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}