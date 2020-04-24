page 14135170 lvngLoanNoMatchPatterns
{
    Caption = 'Loan No. Match Patterns';
    PageType = List;
    SourceTable = lvngLoanNoMatchPattern;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Min. Field Length"; "Min. Field Length") { ApplicationArea = All; }
                field("Max. Field Length"; "Max. Field Length") { ApplicationArea = All; }
                field("Match Pattern"; "Match Pattern") { ApplicationArea = All; }
            }
        }
    }
}