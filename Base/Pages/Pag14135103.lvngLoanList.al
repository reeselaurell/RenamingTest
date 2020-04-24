page 14135103 lvngLoanList
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoan;
    Caption = 'Loan List';
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    CardPageId = lvngLoanCard;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.") { ApplicationArea = All; }
                field("Alternative Loan No."; "Alternative Loan No.") { ApplicationArea = All; }
                field("Search Name"; "Search Name") { ApplicationArea = All; Width = 50; }
                field("Borrower First Name"; "Borrower First Name") { Visible = false; ApplicationArea = All; }
                field("Borrower Middle Name"; "Borrower Middle Name") { Visible = false; ApplicationArea = All; }
                field("Borrower Last Name"; "Borrower Last Name") { Visible = false; ApplicationArea = All; }
                field("Co-Borrower First Name"; "Co-Borrower First Name") { Visible = false; ApplicationArea = All; }
                field("Co-Borrower Middle Name"; "Co-Borrower Middle Name") { Visible = false; ApplicationArea = All; }
                field("Co-Borrower Last Name"; "Co-Borrower Last Name") { Visible = false; ApplicationArea = All; }
                field("203K Contractor Name"; "203K Contractor Name") { Visible = false; ApplicationArea = All; }
                field("203K Inspector Name"; "203K Inspector Name") { Visible = false; ApplicationArea = All; }
                field("Loan Amount"; "Loan Amount") { ApplicationArea = All; }
                field("Application Date"; "Application Date") { Visible = false; ApplicationArea = All; }
                field("Date Locked"; "Date Locked") { Visible = false; ApplicationArea = All; }
                field("Date Closed"; "Date Closed") { Visible = false; ApplicationArea = All; }
                field("Date Funded"; "Date Funded") { ApplicationArea = All; }
                field("Date Sold"; "Date Sold") { ApplicationArea = All; }
                field("Servicing Finished"; "Servicing Finished") { ApplicationArea = All; }
                field("Loan Term (Months)"; "Loan Term (Months)") { ApplicationArea = All; }
                field("Interest Rate"; "Interest Rate") { ApplicationArea = All; }
                field("Constr. Interest Rate"; "Constr. Interest Rate") { Visible = false; ApplicationArea = All; }
                field("Monthly Escrow Amount"; "Monthly Escrow Amount") { Visible = false; ApplicationArea = All; }
                field("Monthly Payment Amount"; "Monthly Payment Amount") { Visible = false; ApplicationArea = All; }
                field("First Payment Due"; "First Payment Due") { ApplicationArea = All; }
                field("Next Payment Date"; "Next Payment Date") { ApplicationArea = All; }
                field("First Payment Due To Investor"; "First Payment Due To Investor") { ApplicationArea = All; }
                field("Commission Date"; "Commission Date") { Visible = false; ApplicationArea = All; }
                field("Commission Base Amount"; "Commission Base Amount") { Visible = false; ApplicationArea = All; }
                field(Blocked; Blocked) { ApplicationArea = All; }
                field("Warehouse Line Code"; "Warehouse Line Code") { ApplicationArea = All; }
                field("Business Unit Code"; "Business Unit Code") { Visible = false; ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                field("Creation Date"; "Creation Date") { Visible = false; ApplicationArea = All; }
                field("Modified Date"; "Modified Date") { Visible = false; ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowLoanValues)
            {
                ApplicationArea = All;
                Caption = 'Edit Loan Values';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page lvngLoanCardValuesEdit;
                RunPageMode = Edit;
                RunPageLink = "Loan No." = field("No.");
            }
        }
    }

    var
        DimensionManagement: Codeunit DimensionManagement;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;
}