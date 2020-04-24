page 14135138 lvngLoanJournalLines
{
    PageType = List;
    Caption = 'Loan Update Journal';
    SourceTable = lvngLoanJournalLine;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan No."; "Loan No.") { ApplicationArea = All; Style = Unfavorable; StyleExpr = "Error Exists"; }
                field("Alternative Loan No."; "Alternative Loan No.") { ApplicationArea = All; }
                field("Title Customer No."; "Title Customer No.") { ApplicationArea = All; }
                field("Investor Customer No."; "Investor Customer No.") { ApplicationArea = All; }
                field("Search Name"; "Search Name") { Width = 50; ApplicationArea = All; }
                field("Borrower First Name"; "Borrower First Name") { Width = 30; ApplicationArea = All; }
                field("Borrower Middle Name"; "Borrower Middle Name") { Width = 10; ApplicationArea = All; }
                field("Borrower Last Name"; "Borrower Last Name") { Width = 30; ApplicationArea = All; }
                field("Co-Borrower First Name"; "Co-Borrower First Name") { ApplicationArea = All; }
                field("Co-Borrower Middle Name"; "Co-Borrower Middle Name") { ApplicationArea = All; }
                field("Co-Borrower Last Name"; "Co-Borrower Last Name") { ApplicationArea = All; }
                field("Borrower Address"; "Borrower Address") { ApplicationArea = All; }
                field("Borrower Address 2"; "Borrower Address 2") { ApplicationArea = All; }
                field("Borrower City"; "Borrower City") { ApplicationArea = All; }
                field("Borrower State"; "Borrower State") { ApplicationArea = All; }
                field("Borrower ZIP Code"; "Borrower ZIP Code") { ApplicationArea = All; }
                field("Co-Borrower Address"; "Co-Borrower Address") { ApplicationArea = All; }
                field("Co-Borrower Address 2"; "Co-Borrower Address 2") { ApplicationArea = All; }
                field("Co-Borrower City"; "Co-Borrower City") { ApplicationArea = All; }
                field("Co-Borrower State"; "Co-Borrower State") { ApplicationArea = All; }
                field("Co-Borrower ZIP Code"; "Co-Borrower ZIP Code") { ApplicationArea = All; }
                field("Mailing Address"; "Mailing Address") { ApplicationArea = All; }
                field("Mailing Address 2"; "Mailing Address 2") { ApplicationArea = All; }
                field("Mailing City"; "Mailing City") { ApplicationArea = All; }
                field("Mailing State"; "Mailing State") { ApplicationArea = All; }
                field("Mailing ZIP Code"; "Mailing ZIP Code") { ApplicationArea = All; }
                field("Property Address"; "Property Address") { ApplicationArea = All; }
                field("Property Address 2"; "Property Address 2") { ApplicationArea = All; }
                field("Property City"; "Property City") { ApplicationArea = All; }
                field("Property State"; "Property State") { ApplicationArea = All; }
                field("Property ZIP Code"; "Property ZIP Code") { ApplicationArea = All; }
                field("203K Contractor Name"; "203K Contractor Name") { ApplicationArea = All; }
                field("203K Inspector Name"; "203K Inspector Name") { ApplicationArea = All; }
                field("Loan Amount"; "Loan Amount") { ApplicationArea = All; }
                field("Application Date"; "Application Date") { ApplicationArea = All; }
                field("Date Locked"; "Date Locked") { ApplicationArea = All; }
                field("Date Closed"; "Date Closed") { ApplicationArea = All; }
                field("Date Funded"; "Date Funded") { ApplicationArea = All; }
                field("Loan Term (Months)"; "Loan Term (Months)") { ApplicationArea = All; }
                field("Interest Rate"; "Interest Rate") { ApplicationArea = All; }
                field("Constr. Interest Rate"; "Constr. Interest Rate") { ApplicationArea = All; }
                field("Monthly Escrow Amount"; "Monthly Escrow Amount") { ApplicationArea = All; }
                field("Monthly Payment Amount"; "Monthly Payment Amount") { ApplicationArea = All; }
                field("First Payment Due"; "First Payment Due") { ApplicationArea = All; }
                field("Next Payment Date"; "Next Payment Date") { ApplicationArea = All; }
                field("Late Fee"; "Late Fee") { ApplicationArea = All; }
                field("Commission Date"; "Commission Date") { ApplicationArea = All; }
                field("Commission Base Amount"; "Commission Base Amount") { ApplicationArea = All; }
                field("Commission Bps"; "Commission Bps") { ApplicationArea = All; }
                field("Commission Amount"; "Commission Amount") { ApplicationArea = All; }
                field("Warehouse Line Code"; "Warehouse Line Code") { ApplicationArea = All; }
                field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                field("Line No."; "Line No.") { ApplicationArea = All; }
                field("Processing Schema Code"; "Processing Schema Code") { ApplicationArea = All; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; }
                field("Calculated Document Amount"; "Calculated Document Amount") { ApplicationArea = All; }
                field(Blocked; Blocked) { ApplicationArea = All; }
                field("First Payment Due To Investor"; "First Payment Due To Investor") { ApplicationArea = All; }
                field("Date Sold"; "Date Sold") { ApplicationArea = All; }
            }
        }
        area(Factboxes)
        {
            part(Errors; lvngLoanJournalErrors)
            {
                Caption = 'Errors';
                ApplicationArea = All;
                SubPageLink = "Loan Journal Batch Code" = field("Loan Journal Batch Code"), "Line No." = field("Line No.");
            }

            part(Values; lvngLoanImportValuePart)
            {
                Caption = 'Values';
                ApplicationArea = All;
                SubPageLink = "Loan Journal Batch Code" = field("Loan Journal Batch Code"), "Line No." = field("Line No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngImport)
            {
                Caption = 'Import';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Import;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    LoanImportSchema: Record lvngLoanImportSchema;
                    LoanJournalImport: Codeunit lvngLoanJournalImport;
                    ValidateLoanJournal: Codeunit lvngValidateLoanJournal;
                begin
                    LoanImportSchema.Reset();
                    LoanImportSchema.SetRange("Loan Journal Batch Type", LoanImportSchema."Loan Journal Batch Type"::Loan);
                    if Page.RunModal(0, LoanImportSchema) = Action::LookupOk then begin
                        Clear(LoanJournalImport);
                        LoanJournalImport.ReadCSVStream("Loan Journal Batch Code", LoanImportSchema);
                        Commit();
                        ValidateLoanJournal.ValidateLoanLines("Loan Journal Batch Code");
                        CurrPage.Update(false);
                    end;
                end;
            }

            action(ValidateLines)
            {
                Caption = 'Validate Lines';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Approve;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    ValidateLoanJournal: Codeunit lvngValidateLoanJournal;
                begin
                    ValidateLoanJournal.ValidateLoanLines("Loan Journal Batch Code");
                    CurrPage.Update(false);
                end;
            }

            action(CreateLoanCards)
            {
                Caption = 'Create Loan Cards';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = CreateForm;

                trigger OnAction()
                var
                    LoanManagement: Codeunit lvngLoanManagement;
                begin
                    LoanManagement.UpdateLoans("Loan Journal Batch Code");
                end;
            }

            action(ShowLoanValues)
            {
                ApplicationArea = All;
                Caption = 'Edit Loan Values';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page lvngLoanImportValueEdit;
                RunPageMode = Edit;
                RunPageLink = "Loan Journal Batch Code" = field("Loan Journal Batch Code"), "Line No." = field("Line No.");
            }

            action(ShowErrorLinesOnly)
            {
                ApplicationArea = All;
                Caption = 'Show Error Lines';
                Image = ErrorLog;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SetRange("Error Exists", true);
                    CurrPage.Update(false);
                end;
            }

            action(ShowAllLines)
            {
                ApplicationArea = All;
                Caption = 'Show All Lines';
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SetRange("Error Exists");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Error Exists");
    end;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;
}