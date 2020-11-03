page 14135106 "lvnFundedJournalLines"
{
    PageType = List;
    Caption = 'Funded Journal Lines';
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
                field("Title Customer No."; Rec."Title Customer No.") { ApplicationArea = All; }
                field("Search Name"; Rec."Search Name") { Width = 50; ApplicationArea = All; }
                field("Borrower First Name"; Rec."Borrower First Name") { Width = 30; ApplicationArea = All; }
                field("Borrower Middle Name"; Rec."Borrower Middle Name") { Width = 10; ApplicationArea = All; }
                field("Borrower Last Name"; Rec."Borrower Last Name") { Width = 30; ApplicationArea = All; }
                field("Co-Borrower First Name"; Rec."Co-Borrower First Name") { ApplicationArea = All; }
                field("Co-Borrower Middle Name"; Rec."Co-Borrower Middle Name") { ApplicationArea = All; }
                field("Co-Borrower Last Name"; Rec."Co-Borrower Last Name") { ApplicationArea = All; }
                field("Borrower Address"; Rec."Borrower Address") { ApplicationArea = All; }
                field("Borrower Address 2"; Rec."Borrower Address 2") { ApplicationArea = All; }
                field("Borrower City"; Rec."Borrower City") { ApplicationArea = All; }
                field("Borrower State"; Rec."Borrower State") { ApplicationArea = All; }
                field("Borrower ZIP Code"; Rec."Borrower ZIP Code") { ApplicationArea = All; }
                field("Co-Borrower Address"; Rec."Co-Borrower Address") { ApplicationArea = All; }
                field("Co-Borrower Address 2"; Rec."Co-Borrower Address 2") { ApplicationArea = All; }
                field("Co-Borrower City"; Rec."Co-Borrower City") { ApplicationArea = All; }
                field("Co-Borrower State"; Rec."Co-Borrower State") { ApplicationArea = All; }
                field("Co-Borrower ZIP Code"; Rec."Co-Borrower ZIP Code") { ApplicationArea = All; }
                field("Mailing Address"; Rec."Mailing Address") { ApplicationArea = All; }
                field("Mailing Address 2"; Rec."Mailing Address 2") { ApplicationArea = All; }
                field("Mailing City"; Rec."Mailing City") { ApplicationArea = All; }
                field("Mailing State"; Rec."Mailing State") { ApplicationArea = All; }
                field("Mailing ZIP Code"; Rec."Mailing ZIP Code") { ApplicationArea = All; }
                field("Property Address"; Rec."Property Address") { ApplicationArea = All; }
                field("Property Address 2"; Rec."Property Address 2") { ApplicationArea = All; }
                field("Property City"; Rec."Property City") { ApplicationArea = All; }
                field("Property State"; Rec."Property State") { ApplicationArea = All; }
                field("Property ZIP Code"; Rec."Property ZIP Code") { ApplicationArea = All; }
                field("203K Contractor Name"; Rec."203K Contractor Name") { ApplicationArea = All; }
                field("203K Inspector Name"; Rec."203K Inspector Name") { ApplicationArea = All; }
                field("Loan Amount"; Rec."Loan Amount") { ApplicationArea = All; }
                field("Application Date"; Rec."Application Date") { ApplicationArea = All; }
                field("Date Locked"; Rec."Date Locked") { ApplicationArea = All; }
                field("Date Closed"; Rec."Date Closed") { ApplicationArea = All; }
                field("Date Funded"; Rec."Date Funded") { ApplicationArea = All; }
                field("Loan Term (Months)"; Rec."Loan Term (Months)") { ApplicationArea = All; }
                field("Interest Rate"; Rec."Interest Rate") { ApplicationArea = All; }
                field("Constr. Interest Rate"; Rec."Constr. Interest Rate") { ApplicationArea = All; }
                field("Monthly Escrow Amount"; Rec."Monthly Escrow Amount") { ApplicationArea = All; }
                field("Monthly Payment Amount"; Rec."Monthly Payment Amount") { ApplicationArea = All; }
                field("First Payment Due"; Rec."First Payment Due") { ApplicationArea = All; }
                field("Next Payment Date"; Rec."Next Payment Date") { ApplicationArea = All; }
                field("Late Fee"; Rec."Late Fee") { ApplicationArea = All; }
                field("Commission Date"; Rec."Commission Date") { ApplicationArea = All; }
                field("Commission Base Amount"; Rec."Commission Base Amount") { ApplicationArea = All; }
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
                field(Blocked; Rec.Blocked) { Visible = false; ApplicationArea = All; }
                field("First Payment Due To Investor"; Rec."First Payment Due To Investor") { Visible = false; ApplicationArea = All; }
                field("Date Sold"; Rec."Date Sold") { Visible = false; ApplicationArea = All; }
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
                    ValidateFundedJournal: Codeunit lvnValidateFundedJournal;
                    LoanImportSchema: Record lvnLoanImportSchema;
                begin
                    LoanImportSchema.Reset();
                    LoanImportSchema.SetRange("Loan Journal Batch Type", LoanImportSchema."Loan Journal Batch Type"::Funded);
                    if Page.RunModal(0, LoanImportSchema) = Action::LookupOk then begin
                        Clear(LoanJournalImport);
                        LoanJournalImport.ReadCSVStream(Rec."Loan Journal Batch Code", LoanImportSchema);
                        Commit();
                        ValidateFundedJournal.ValidateFundedLines(Rec."Loan Journal Batch Code");
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
                    ValidateFundedJournal: Codeunit lvnValidateFundedJournal;
                begin
                    ValidateFundedJournal.ValidateFundedLines(Rec."Loan Journal Batch Code");
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
                    CreateFundedDocuments: Codeunit lvnCreateFundedDocuments;
                begin
                    CreateFundedDocuments.CreateDocuments(Rec."Loan Journal Batch Code");
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

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Error Exists");
    end;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;
}