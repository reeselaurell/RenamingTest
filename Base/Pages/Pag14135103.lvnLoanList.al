page 14135103 "lvnLoanList"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnLoan;
    Caption = 'Loan List';
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    CardPageId = lvnLoanCard;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Alternative Loan No."; Rec."Alternative Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                    Width = 50;
                }
                field("Borrower First Name"; Rec."Borrower First Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Borrower Middle Name"; Rec."Borrower Middle Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Borrower Last Name"; Rec."Borrower Last Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Co-Borrower First Name"; Rec."Co-Borrower First Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Co-Borrower Middle Name"; Rec."Co-Borrower Middle Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Co-Borrower Last Name"; Rec."Co-Borrower Last Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("203K Contractor Name"; Rec."203K Contractor Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("203K Inspector Name"; Rec."203K Inspector Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Loan Amount"; Rec."Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Date Locked"; Rec."Date Locked")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Date Closed"; Rec."Date Closed")
                {
                    Visible = false;
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
                field("Servicing Finished"; Rec."Servicing Finished")
                {
                    ApplicationArea = All;
                }
                field("Loan Term (Months)"; Rec."Loan Term (Months)")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Constr. Interest Rate"; Rec."Constr. Interest Rate")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Monthly Escrow Amount"; Rec."Monthly Escrow Amount")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Monthly Payment Amount"; Rec."Monthly Payment Amount")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("First Payment Due"; Rec."First Payment Due")
                {
                    ApplicationArea = All;
                }
                field("Next Payment Date"; Rec."Next Payment Date")
                {
                    ApplicationArea = All;
                }
                field("First Payment Due To Investor"; Rec."First Payment Due To Investor")
                {
                    ApplicationArea = All;
                }
                field("Commission Date"; Rec."Commission Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Commission Base Amount"; Rec."Commission Base Amount")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Warehouse Line Code"; Rec."Warehouse Line Code")
                {
                    ApplicationArea = All;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Modified Date"; Rec."Modified Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
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
                RunObject = page lvnLoanCardValuesEdit;
                RunPageMode = Edit;
                RunPageLink = "Loan No." = field("No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

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
}