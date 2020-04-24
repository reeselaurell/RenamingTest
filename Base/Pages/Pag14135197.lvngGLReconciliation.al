page 14135197 lvngGLReconciliation
{
    Caption = 'G/L Reconciliation';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngGenLedgerReconcile;
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    LinksAllowed = false;
    ShowFilter = false;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                field(GLAccountFilter; GLAccountNo) { Caption = 'G/L Account No.'; ApplicationArea = All; }
                field(DateFilter; DateFilter) { Caption = 'Date Filter'; ApplicationArea = All; }
            }

            repeater(Group)
            {
                field("Loan No."; "Loan No.") { ApplicationArea = All; }
                field("G/L Account No."; "G/L Account No.") { ApplicationArea = All; }
                field("Date Funded"; "Date Funded") { ApplicationArea = All; }
                field("Date Sold"; "Date Sold") { ApplicationArea = All; }
                field("Investor Name"; "Investor Name") { ApplicationArea = All; }
                field("Last Transaction Date"; "Last Transaction Date") { ApplicationArea = All; }
                field(Name; Name) { ApplicationArea = All; }
                field("Loan Card Value"; "Loan Card Value") { ApplicationArea = All; }
                field("Debit Amount"; "Debit Amount") { ApplicationArea = All; }
                field("Credit Amount"; "Credit Amount") { ApplicationArea = All; }
                field("Current Balance"; "Current Balance") { ApplicationArea = All; }
                field("Includes Multi-Payment"; "Includes Multi-Payment") { ApplicationArea = All; }
                field("Shortcut Dimension 1"; "Shortcut Dimension 1") { ApplicationArea = All; }
                field("Shortcut Dimension 2"; "Shortcut Dimension 2") { ApplicationArea = All; }
                field("Shortcut Dimension 3"; "Shortcut Dimension 3") { ApplicationArea = All; }
                field("Shortcut Dimension 4"; "Shortcut Dimension 4") { ApplicationArea = All; }
                field("Shortcut Dimension 5"; "Shortcut Dimension 5") { ApplicationArea = All; }
                field("Shortcut Dimension 6"; "Shortcut Dimension 6") { ApplicationArea = All; }
                field("Shortcut Dimension 7"; "Shortcut Dimension 7") { ApplicationArea = All; }
                field("Shortcut Dimension 8"; "Shortcut Dimension 8") { ApplicationArea = All; }
            }

            group(Lines)
            {
                part(lvngGLReconcilitationSubform; lvngGLReconcilitationSubform) { ApplicationArea = All; SubPageLink = lvngLoanNo = field("Loan No."), "Posting Date" = field(filter("Date Filter")), "G/L Account No." = field("G/L Account No."); Editable = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RetrieveLoanData)
            {
                Caption = 'Retrieve Loan Data';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Accounts;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RetrieveData: Report lvngGeneralLedgerRecGen;
                begin
                    Reset();
                    DeleteAll();
                    Clear(RetrieveData);
                    RetrieveData.RunModal();
                    RetrieveData.GetData(Rec);
                    GLAccountNo := RetrieveData.GetAccountNumber;
                    DateFilter := RetrieveData.GetDateFilter;
                    CurrPage.Update(false);
                end;
            }

            action(ShowDetails)
            {
                Caption = 'Show Details';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                Enabled = false;
                Image = EntriesList;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.SetCurrentKey(lvngLoanNo, "Posting Date");
                    GLEntry.SetRange(lvngLoanNo, "Loan No.");
                    GLEntry.SetFilter("G/L Account No.", GLAccountNo);
                    GLEntry.SetFilter("Posting Date", DateFilter);
                    Page.RunModal(Page::"General Ledger Entries", GLEntry);
                end;
            }

            action(LoanCard)
            {
                Caption = 'Loan Card';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Loaner;

                trigger OnAction()
                var
                    Loan: Record lvngLoan;
                begin
                    Loan.Get("Loan No.");
                    Page.RunModal(Page::lvngLoanCard, Loan);
                end;
            }

            action(QuickTrace)
            {
                Caption = 'Quick Trace';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Trace;

                trigger OnAction()
                var
                    QuickTrace: Page lvngQuickTrace;
                begin
                    Clear(QuickTrace);
                    QuickTrace.AssignLoanNo("Loan No.");
                    QuickTrace.RunModal();
                end;
            }

            action(ExportToExcel)
            {
                Caption = 'Export to Excel';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Excel;

                trigger OnAction()
                var
                    GLRecExcelExport: Report lvngGLReconExcelExport;
                begin
                    GLRecExcelExport.SetParam(Rec);
                    GLRecExcelExport.Run();
                end;
            }
        }
    }

    var
        GLAccountNo: Text;
        DateFilter: Text;

    trigger OnOpenPage()
    begin
        Reset();
        DeleteAll();
    end;

    trigger OnAfterGetRecord()
    var
        GLAccount: Record "G/L Account";
        LoanValue: Record lvngLoanValue;
    begin
        Clear("Loan Card Value");
        if "Loan No." <> '' then
            if GLAccount."No." <> "G/L Account No." then begin
                GLAccount.Get("G/L Account No.");
                if GLAccount.lvngReconciliationFieldNo <> 0 then
                    if LoanValue.Get("Loan No.", GLAccount.lvngReconciliationFieldNo) then
                        "Loan Card Value" := LoanValue."Decimal Value";
            end;
    end;
}