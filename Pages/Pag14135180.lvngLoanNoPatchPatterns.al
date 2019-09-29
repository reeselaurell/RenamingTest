page 14135180 "lvngLoanNoPatchPatterns"
{
    Caption = 'Loan No. Match Patterns';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngLoanNoMatchPattern;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngMinFieldLength; lvngMinFieldLength)
                {
                    ApplicationArea = All;
                }
                field(lvngMaxFieldLength; lvngMaxFieldLength)
                {
                    ApplicationArea = All;
                }
                field(lvngMatchPattern; lvngMatchPattern)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}