page 14135266 "lvnLoanManagerDocActSetup"
{
    Caption = 'Loan Manager Document Activities Setup';
    PageType = Card;
    SourceTable = lvnLoanManagerDocActSetup;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                Caption = 'Clearing Accounts';

                field("Funded Clearing Bal. Account"; Rec."Funded Clearing Bal. Account")
                {
                    ApplicationArea = All;
                }
                field("Sold Clearing Bal. Account"; Rec."Sold Clearing Bal. Account")
                {
                    ApplicationArea = All;
                }
            }
            group(Unprocessed)
            {
                Caption = 'Unprocessed Journals';

                field("Unprocessed Funding Jnl 1"; Rec."Unprocessed Funding Jnl 1")
                {
                    ApplicationArea = All;
                }
                field("Unprocessed Funding Jnl 2"; Rec."Unprocessed Funding Jnl 2")
                {
                    ApplicationArea = All;
                }
                field("Unprocessed Funding Jnl 3"; Rec."Unprocessed Funding Jnl 3")
                {
                    ApplicationArea = All;
                }
                field("Unprocessed Funding Jnl 4"; Rec."Unprocessed Funding Jnl 4")
                {
                    ApplicationArea = All;
                }
                field("Unprocessed Funding Jnl 5"; Rec."Unprocessed Funding Jnl 5")
                {
                    ApplicationArea = All;
                }
                field("Unprocessed Sold Jnl 1"; Rec."Unprocessed Sold Jnl 1")
                {
                    ApplicationArea = All;
                }
                field("Unprocessed Sold Jnl 2"; Rec."Unprocessed Sold Jnl 2")
                {
                    ApplicationArea = All;
                }
                field("Unprocessed Sold Jnl 3"; Rec."Unprocessed Sold Jnl 3")
                {
                    ApplicationArea = All;
                }
                field("Unprocessed Sold Jnl 4"; Rec."Unprocessed Sold Jnl 4")
                {
                    ApplicationArea = All;
                }
                field("Unprocessed Sold Jnl 5"; Rec."Unprocessed Sold Jnl 5")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}