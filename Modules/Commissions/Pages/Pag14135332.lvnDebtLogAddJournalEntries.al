page 14135332 lvnDebtLogAddJournalEntries
{
    Caption = 'Debt Log Additional Journal Entries';
    PageType = List;
    SourceTable = lvnAdditionalDebtLogJournal;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(ProfileCode; Rec."Profile Code")
                {
                    ApplicationArea = All;
                }
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
            }
        }
    }
}