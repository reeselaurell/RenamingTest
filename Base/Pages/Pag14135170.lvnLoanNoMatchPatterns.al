page 14135170 "lvnLoanNoMatchPatterns"
{
    Caption = 'Loan No. Match Patterns';
    PageType = List;
    SourceTable = lvnLoanNoMatchPattern;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Min. Field Length"; Rec."Min. Field Length") { ApplicationArea = All; }
                field("Max. Field Length"; Rec."Max. Field Length") { ApplicationArea = All; }
                field("Match Pattern"; Rec."Match Pattern") { ApplicationArea = All; }
            }
        }
    }
}