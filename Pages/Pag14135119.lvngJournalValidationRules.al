page 14135119 "lvngJournalValidationRules"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
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