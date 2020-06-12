page 14135266 lvngLoanManagerDocActSetup
{
    Caption = 'Loan Manager Document Activities Setup';
    PageType = Card;
    SourceTable = lvngLoanManagerDocActSetup;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                Caption = 'Clearing Accounts';
                field("Funded Clearing Bal. Account"; "Funded Clearing Bal. Account") { ApplicationArea = All; }
                field("Sold Clearing Bal. Account"; "Sold Clearing Bal. Account") { ApplicationArea = All; }
            }

            group(Unprocessed)
            {
                Caption = 'Unprocessed Journals';

                field("Unprocessed Funding Jnl 1"; "Unprocessed Funding Jnl 1") { ApplicationArea = All; }
                field("Unprocessed Funding Jnl 2"; "Unprocessed Funding Jnl 2") { ApplicationArea = All; }
                field("Unprocessed Funding Jnl 3"; "Unprocessed Funding Jnl 3") { ApplicationArea = All; }
                field("Unprocessed Funding Jnl 4"; "Unprocessed Funding Jnl 4") { ApplicationArea = All; }
                field("Unprocessed Funding Jnl 5"; "Unprocessed Funding Jnl 5") { ApplicationArea = All; }
                field("Unprocessed Sold Jnl 1"; "Unprocessed Sold Jnl 1") { ApplicationArea = All; }
                field("Unprocessed Sold Jnl 2"; "Unprocessed Sold Jnl 2") { ApplicationArea = All; }
                field("Unprocessed Sold Jnl 3"; "Unprocessed Sold Jnl 3") { ApplicationArea = All; }
                field("Unprocessed Sold Jnl 4"; "Unprocessed Sold Jnl 4") { ApplicationArea = All; }
                field("Unprocessed Sold Jnl 5"; "Unprocessed Sold Jnl 5") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}