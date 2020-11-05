page 14135176 "lvnForm1098Details"
{
    Caption = 'Form 1098 Details';
    PageType = List;
    SourceTable = lvnForm1098Details;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                }
                field("Rule Description"; Rec."Rule Description")
                {
                    ApplicationArea = All;
                    Caption = 'Rule Description';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                }
                field("Closed at Date"; Rec."Closed at Date")
                {
                    ApplicationArea = All;
                    Caption = 'Closed at Date';
                }
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
                Enabled = Rec.Type = Rec.Type::"G/L Entry";
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