page 14135331 "lvnDebtLogJournalEntries"
{
    Caption = 'Debt Log Journal Entries';
    PageType = List;
    SourceTable = lvnDebtLogJournalLine;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(IdentifierCode; Rec."Identifier Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(LoanNo; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field(DebtLogOnlyPosting; Rec."Debt Log Only Posting")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}