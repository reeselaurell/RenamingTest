page 14135164 lvngLoanInfoBox
{
    PageType = CardPart;
    SourceTable = lvngLoan;

    layout
    {
        area(Content)
        {
            field("No."; "No.") { ApplicationArea = All; }
            field("Borrower Customer No"; "Borrower Customer No") { ApplicationArea = All; }
            field("Investor Customer No."; "Investor Customer No.") { ApplicationArea = All; }
            field("Title Customer No."; "Title Customer No.") { ApplicationArea = All; }
            field("Date Funded"; "Date Funded") { ApplicationArea = All; }
            field("Date Sold"; "Date Sold") { ApplicationArea = All; }
            field("Search Name"; "Search Name") { ApplicationArea = All; Visible = false; }
            field("Application Date"; "Application Date") { ApplicationArea = All; Visible = false; }
            field("Date Locked"; "Date Locked") { ApplicationArea = All; Visible = false; }
            field(CoBorrowerName; CoBorrowerName) { Caption = 'Co-Borrower Name'; ApplicationArea = All; Visible = false; }
            field(BorrowerName; BorrowerName) { Caption = 'Borrower Name'; ApplicationArea = All; }
            field("Warehouse Line Code"; "Warehouse Line Code") { ApplicationArea = All; Visible = false; }
            field("Loan Amount"; "Loan Amount") { ApplicationArea = All; }
            field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = false; }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = false; }
            field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = false; }
            field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = false; }
            field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = false; }
            field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = false; }
            field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = false; }
            field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = false; }
            field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; Visible = false; }
            field("Loan Term (Months)"; "Loan Term (Months)") { ApplicationArea = All; Visible = false; }
            field("First Payment Due"; "First Payment Due") { ApplicationArea = All; Visible = false; }
            field("First Payment Due To Investor"; "First Payment Due To Investor") { ApplicationArea = All; Visible = false; }
            field("Next Payment Date"; "Next Payment Date") { ApplicationArea = All; Visible = false; }
            field("Monthly Escrow Amount"; "Monthly Escrow Amount") { ApplicationArea = All; Visible = false; }
            field("Borrower SSN"; "Borrower SSN") { ApplicationArea = All; Visible = false; }
            field("Co-Borrower SSN"; "Co-Borrower SSN") { ApplicationArea = All; Visible = false; }
            field(Blocked; Blocked) { ApplicationArea = All; }
        }
    }

    var
        BorrowerName: Text;
        CoBorrowerName: Text;

    trigger OnAfterGetCurrRecord()
    var
    begin
        BorrowerName := '';
        CoBorrowerName := '';
        BorrowerName := "Borrower First Name" + ' ' + "Borrower Middle Name" + ' ' + "Borrower Last Name";
        CoBorrowerName := "Co-Borrower First Name" + ' ' + "Co-Borrower Middle Name" + ' ' + "Co-Borrower Last Name";
    end;
}