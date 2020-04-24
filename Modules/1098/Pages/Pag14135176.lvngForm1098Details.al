page 14135176 lvngForm1098Details
{
    Caption = 'Form 1098 Details';
    PageType = List;
    SourceTable = lvngForm1098Details;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Type) { ApplicationArea = All; Caption = 'Type'; }
                field(Description; Description) { ApplicationArea = All; Caption = 'Description'; }
                field(Amount; Amount) { ApplicationArea = All; Caption = 'Amount'; }
                field("Rule Description"; "Rule Description") { ApplicationArea = All; Caption = 'Rule Description'; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; Caption = 'Posting Date'; }
                field("Closed at Date"; "Closed at Date") { ApplicationArea = All; Caption = 'Closed at Date'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Entries)
            {
                ApplicationArea = All;
                Caption = 'General Ledger Entries';
                Enabled = Type = Type::"G/L Entry";
                Image = GeneralLedger;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page "General Ledger Entries";
                RunPageLink = "Entry No." = field("G/L Entry No.");
            }
        }
    }
}