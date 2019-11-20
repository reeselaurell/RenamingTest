page 14135138 lvngSoldJournalLines
{
    PageType = List;
    Caption = 'Sold Journal Lines';
    SourceTable = lvngLoanJournalLine;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan No."; "Loan No.") { ApplicationArea = All; Style = Unfavorable; StyleExpr = "Error Exists"; }
                field("Investor Customer No."; "Investor Customer No.") { ApplicationArea = All; }
                field("Search Name"; "Search Name") { Width = 50; ApplicationArea = All; }
                field("Borrower First Name"; "Borrower First Name") { Width = 30; ApplicationArea = All; }
                field("Borrower Middle Name"; "Borrower Middle Name") { Width = 10; ApplicationArea = All; }
                field("Borrower Last Name"; "Borrower Last Name") { Width = 30; ApplicationArea = All; }
                field("Co-Borrower First Name"; "Co-Borrower First Name") { ApplicationArea = All; Visible = False; }
                field("Co-Borrower Middle Name"; "Co-Borrower Middle Name") { ApplicationArea = All; Visible = False; }
                field("Co-Borrower Last Name"; "Co-Borrower Last Name") { ApplicationArea = All; Visible = False; }
                field("203K Contractor Name"; "203K Contractor Name") { ApplicationArea = All; Visible = False; }
                field("203K Inspector Name"; "203K Inspector Name") { ApplicationArea = All; Visible = False; }
                field("Loan Amount"; "Loan Amount") { ApplicationArea = All; }
                field("Application Date"; "Application Date") { ApplicationArea = All; Visible = False; }
                field("Date Locked"; "Date Locked") { ApplicationArea = All; Visible = False; }
                field("Date Closed"; "Date Closed") { ApplicationArea = All; Visible = False; }
                field("Date Sold"; "Date Sold") { ApplicationArea = All; }
                field("Loan Term (Months)"; "Loan Term (Months)") { ApplicationArea = All; Visible = False; }
                field("Interest Rate"; "Interest Rate") { ApplicationArea = All; Visible = False; }
                field("Constr. Interest Rate"; "Constr. Interest Rate") { ApplicationArea = All; Visible = False; }
                field("Monthly Escrow Amount"; "Monthly Escrow Amount") { ApplicationArea = All; Visible = False; }
                field("Monthly Payment Amount"; "Monthly Payment Amount") { ApplicationArea = All; Visible = False; }
                field("First Payment Due"; "First Payment Due") { ApplicationArea = All; Visible = False; }
                field("Next Payment Date"; "Next Payment Date") { ApplicationArea = All; Visible = False; }
                field("Commission Date"; "Commission Date") { ApplicationArea = All; Visible = False; }
                field("Commission Base Amount"; "Commission Base Amount") { ApplicationArea = All; Visible = False; }
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
            action(Import)
            {
                Caption = 'Import';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Import;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    LoanJournalImport: Codeunit lvngLoanJournalImport;
                    ValidateSoldJournal: Codeunit lvngValidateSoldJournal;
                    LoanImportSchema: Record lvngLoanImportSchema;
                begin
                    LoanImportSchema.Reset();
                    LoanImportSchema.SetRange("Loan Journal Batch Type", LoanImportSchema."Loan Journal Batch Type"::Sold);
                    if Page.RunModal(0, LoanImportSchema) = Action::LookupOk then begin
                        Clear(LoanJournalImport);
                        LoanJournalImport.ReadCSVStream("Loan Journal Batch Code", LoanImportSchema);
                        Commit();
                        ValidateSoldJournal.ValidateSoldLines("Loan Journal Batch Code");
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
                    ValidateSoldJournal: Codeunit lvngValidateSoldJournal;
                begin
                    ValidateSoldJournal.ValidateSoldLines("Loan Journal Batch Code");
                    CurrPage.Update(false);
                end;
            }

            action(PreviewDocument)
            {
                Caption = 'Preview Document';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PreviewChecks;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PreviewLoanDocument: Page lvngPreviewLoanDocument;
                begin
                    PreviewLoanDocument.SetJournalLine(Rec);
                    PreviewLoanDocument.Run();
                end;
            }

            action(CreateDocuments)
            {
                Caption = 'Create Documents';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = CreateDocuments;

                trigger OnAction()
                var
                    CreateSoldDocuments: Codeunit lvngCreateSoldDocuments;
                begin
                    CreateSoldDocuments.CreateDocuments("Loan Journal Batch Code");
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

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Error Exists");
    end;
}