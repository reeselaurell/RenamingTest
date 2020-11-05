page 14135197 "lvnGLReconciliation"
{
    Caption = 'G/L Reconciliation';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvnGenLedgerReconcile;
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
                field(GLAccountFilter; GLAccountNo)
                {
                    Caption = 'G/L Account No.';
                    ApplicationArea = All;
                }
                field(DateFilter; DateFilter)
                {
                    Caption = 'Date Filter';
                    ApplicationArea = All;
                }
            }
            repeater(Group)
            {
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
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
                field("Investor Name"; Rec."Investor Name")
                {
                    ApplicationArea = All;
                }
                field("Last Transaction Date"; Rec."Last Transaction Date")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Loan Card Value"; Rec."Loan Card Value")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                }
                field("Current Balance"; Rec."Current Balance")
                {
                    ApplicationArea = All;
                }
                field("Includes Multi-Payment"; Rec."Includes Multi-Payment")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1"; Rec."Shortcut Dimension 1")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2"; Rec."Shortcut Dimension 2")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4"; Rec."Shortcut Dimension 4")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5"; Rec."Shortcut Dimension 5")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6"; Rec."Shortcut Dimension 6")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7"; Rec."Shortcut Dimension 7")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8"; Rec."Shortcut Dimension 8")
                {
                    ApplicationArea = All;
                }
            }
            group(Lines)
            {
                part(lvnGLReconcilitationSubform; lvnGLReconcilitationSubform)
                {
                    ApplicationArea = All;
                    SubPageLink = lvnLoanNo = field("Loan No."), "Posting Date" = field(filter("Date Filter")), "G/L Account No." = field("G/L Account No.");
                    Editable = false;
                }
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
                    RetrieveData: Report lvnGeneralLedgerRecGen;
                begin
                    Rec.Reset();
                    Rec.DeleteAll();
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
                    GLEntry.SetCurrentKey(lvnLoanNo, "Posting Date");
                    GLEntry.SetRange(lvnLoanNo, Rec."Loan No.");
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
                    Loan: Record lvnLoan;
                begin
                    Loan.Get(Rec."Loan No.");
                    Page.RunModal(Page::lvnLoanCard, Loan);
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
                    QuickTrace: Page lvnQuickTrace;
                begin
                    Clear(QuickTrace);
                    QuickTrace.AssignLoanNo(Rec."Loan No.");
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
                    GLRecExcelExport: Report lvnGLReconExcelExport;
                begin
                    GLRecExcelExport.SetParam(Rec);
                    GLRecExcelExport.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        Rec.DeleteAll();
    end;

    trigger OnAfterGetRecord()
    var
        GLAccount: Record "G/L Account";
        LoanValue: Record lvnLoanValue;
    begin
        Clear(Rec."Loan Card Value");
        if Rec."Loan No." <> '' then
            if GLAccount."No." <> Rec."G/L Account No." then begin
                GLAccount.Get(Rec."G/L Account No.");
                if GLAccount.lvnReconciliationFieldNo <> 0 then
                    if LoanValue.Get(Rec."Loan No.", GLAccount.lvnReconciliationFieldNo) then
                        Rec."Loan Card Value" := LoanValue."Decimal Value";
            end;
    end;

    var
        GLAccountNo: Text;
        DateFilter: Text;
}