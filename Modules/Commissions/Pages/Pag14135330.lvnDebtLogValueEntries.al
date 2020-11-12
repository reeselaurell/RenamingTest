page 14135330 lvnDebtLogValueEntries
{
    Caption = 'Debt Log Value Entries';
    PageType = List;
    SourceTable = lvnDebtLogValueEntry;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(ScheduleNo; Rec."Schedule No.")
                {
                    ApplicationArea = All;
                }
                field(EntryDate; Rec."Entry Date")
                {
                    ApplicationArea = All;
                }
                field(ProfileCode; Rec."Profile Code")
                {
                    ApplicationArea = All;
                }
                field(IdentifierCode; Rec."Identifier Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
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