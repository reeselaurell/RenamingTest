page 14135137 "lvnSoldJournalLines"
{
    PageType = List;
    Caption = 'Sold Journal Lines';
    SourceTable = lvnLoanJournalLine;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan No."; Rec."Loan No.") { ApplicationArea = All; Style = Unfavorable; StyleExpr = Rec."Error Exists"; }
                field("Alternative Loan No."; Rec."Alternative Loan No.") { ApplicationArea = All; }
                field("Investor Customer No."; Rec."Investor Customer No.") { ApplicationArea = All; }
                field("Search Name"; Rec."Search Name") { Width = 50; ApplicationArea = All; }
                field("Borrower First Name"; Rec."Borrower First Name") { Width = 30; ApplicationArea = All; }
                field("Borrower Middle Name"; Rec."Borrower Middle Name") { Width = 10; ApplicationArea = All; }
                field("Borrower Last Name"; Rec."Borrower Last Name") { Width = 30; ApplicationArea = All; }
                field("Co-Borrower First Name"; Rec."Co-Borrower First Name") { ApplicationArea = All; Visible = False; }
                field("Co-Borrower Middle Name"; Rec."Co-Borrower Middle Name") { ApplicationArea = All; Visible = False; }
                field("Co-Borrower Last Name"; Rec."Co-Borrower Last Name") { ApplicationArea = All; Visible = False; }
                field("203K Contractor Name"; Rec."203K Contractor Name") { ApplicationArea = All; Visible = False; }
                field("203K Inspector Name"; Rec."203K Inspector Name") { ApplicationArea = All; Visible = False; }
                field("Loan Amount"; Rec."Loan Amount") { ApplicationArea = All; }
                field("Application Date"; Rec."Application Date") { ApplicationArea = All; Visible = False; }
                field("Date Locked"; Rec."Date Locked") { ApplicationArea = All; Visible = False; }
                field("Date Closed"; Rec."Date Closed") { ApplicationArea = All; Visible = False; }
                field("Date Sold"; Rec."Date Sold") { ApplicationArea = All; }
                field("Loan Term (Months)"; Rec."Loan Term (Months)") { ApplicationArea = All; Visible = False; }
                field("Interest Rate"; Rec."Interest Rate") { ApplicationArea = All; Visible = False; }
                field("Constr. Interest Rate"; Rec."Constr. Interest Rate") { ApplicationArea = All; Visible = False; }
                field("Monthly Escrow Amount"; Rec."Monthly Escrow Amount") { ApplicationArea = All; Visible = False; }
                field("Monthly Payment Amount"; Rec."Monthly Payment Amount") { ApplicationArea = All; Visible = False; }
                field("First Payment Due"; Rec."First Payment Due") { ApplicationArea = All; Visible = False; }
                field("Next Payment Date"; Rec."Next Payment Date") { ApplicationArea = All; Visible = False; }
                field("Commission Date"; Rec."Commission Date") { ApplicationArea = All; Visible = False; }
                field("Commission Base Amount"; Rec."Commission Base Amount") { ApplicationArea = All; Visible = False; }
                field("Commission Bps"; Rec."Commission Bps") { ApplicationArea = All; }
                field("Commission Amount"; Rec."Commission Amount") { ApplicationArea = All; }
                field("Warehouse Line Code"; Rec."Warehouse Line Code") { ApplicationArea = All; }
                field("Business Unit Code"; Rec."Business Unit Code") { ApplicationArea = All; }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field("Processing Schema Code"; Rec."Processing Schema Code") { ApplicationArea = All; }
                field("Reason Code"; Rec."Reason Code") { ApplicationArea = All; }
                field("Calculated Document Amount"; Rec."Calculated Document Amount") { ApplicationArea = All; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; }
                field("First Payment Due To Investor"; Rec."First Payment Due To Investor") { ApplicationArea = All; }
            }
        }

        area(Factboxes)
        {
            part(Errors; lvnLoanJournalErrors)
            {
                Caption = 'Errors';
                ApplicationArea = All;
                SubPageLink = "Loan Journal Batch Code" = field("Loan Journal Batch Code"), "Line No." = field("Line No.");
            }

            part(Values; lvnLoanImportValuePart)
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
                    LoanJournalImport: Codeunit lvnLoanJournalImport;
                    ValidateSoldJournal: Codeunit lvnValidateSoldJournal;
                    LoanImportSchema: Record lvnLoanImportSchema;
                begin
                    LoanImportSchema.Reset();
                    LoanImportSchema.SetRange("Loan Journal Batch Type", LoanImportSchema."Loan Journal Batch Type"::Sold);
                    if Page.RunModal(0, LoanImportSchema) = Action::LookupOk then begin
                        Clear(LoanJournalImport);
                        LoanJournalImport.ReadCSVStream(Rec."Loan Journal Batch Code", LoanImportSchema);
                        Commit();
                        ValidateSoldJournal.ValidateSoldLines(Rec."Loan Journal Batch Code");
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
                    ValidateSoldJournal: Codeunit lvnValidateSoldJournal;
                begin
                    ValidateSoldJournal.ValidateSoldLines(Rec."Loan Journal Batch Code");
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
                    PreviewLoanDocument: Page lvnPreviewLoanDocument;
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
                    CreateSoldDocuments: Codeunit lvnCreateSoldDocuments;
                begin
                    CreateSoldDocuments.CreateDocuments(Rec."Loan Journal Batch Code");
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
                    LoanManagement: Codeunit lvnLoanManagement;
                begin
                    LoanManagement.UpdateLoans(Rec."Loan Journal Batch Code");
                end;
            }

            action(ShowLoanValues)
            {
                ApplicationArea = All;
                Caption = 'Edit Loan Values';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page lvnLoanImportValueEdit;
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
                    Rec.SetRange("Error Exists", true);
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
                    Rec.SetRange("Error Exists");
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
        Rec.CalcFields("Error Exists");
    end;
}