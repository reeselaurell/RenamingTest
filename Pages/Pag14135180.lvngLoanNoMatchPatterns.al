page 14135180 "lvngLoanNoMatchPatterns"
{
    Caption = 'Loan No. Match Patterns';
    PageType = List;
    SourceTable = lvngLoanNoMatchPattern;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngCode; Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; Description)
                {
                    ApplicationArea = All;
                }
                field(lvngMinFieldLength; "Min. Field Length")
                {
                    ApplicationArea = All;
                }
                field(lvngMaxFieldLength; "Max. Field Length")
                {
                    ApplicationArea = All;
                }
                field(lvngMatchPattern; "Match Pattern")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}