page 14135163 "lvnLoanInfoBox"
{
    PageType = CardPart;
    SourceTable = lvnLoan;

    layout
    {
        area(Content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
            }
            field("Borrower Customer No."; Rec."Borrower Customer No.")
            {
                ApplicationArea = All;
            }
            field("Investor Customer No."; Rec."Investor Customer No.")
            {
                ApplicationArea = All;
            }
            field("Title Customer No."; Rec."Title Customer No.")
            {
                ApplicationArea = All;
            }
            field("Date Funded"; Rec."Date Funded")
            {
                ApplicationArea = All;
            }
            field("Date Sold"; Rec."Date Sold")
            {
                ApplicationArea = All;
            }
            field("Search Name"; Rec."Search Name")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Application Date"; Rec."Application Date")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Date Locked"; Rec."Date Locked")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(CoBorrowerName; CoBorrowerName)
            {
                Caption = 'Co-Borrower Name';
                ApplicationArea = All;
                Visible = false;
            }
            field(BorrowerName; BorrowerName)
            {
                Caption = 'Borrower Name';
                ApplicationArea = All;
            }
            field("Warehouse Line Code"; Rec."Warehouse Line Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Loan Amount"; Rec."Loan Amount")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Business Unit Code"; Rec."Business Unit Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Loan Term (Months)"; Rec."Loan Term (Months)")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("First Payment Due"; Rec."First Payment Due")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("First Payment Due To Investor"; Rec."First Payment Due To Investor")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Next Payment Date"; Rec."Next Payment Date")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Monthly Escrow Amount"; Rec."Monthly Escrow Amount")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Borrower SSN"; Rec."Borrower SSN")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Co-Borrower SSN"; Rec."Co-Borrower SSN")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        BorrowerName := lvnLoanManagement.GetBorrowerName(Rec);
        CoBorrowerName := lvnLoanManagement.GetCoBorrowerName(Rec);
    end;

    var
        lvnLoanManagement: Codeunit lvnLoanManagement;
        BorrowerName: Text;
        CoBorrowerName: Text;
}