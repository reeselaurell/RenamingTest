report 14135169 lvngLoanFeesReport
{
    Caption = 'Loan Fees Report';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135169.rdl';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Date Filter";

            trigger OnAfterGetRecord()
            begin
                if "G/L Account"."Revenue G/L Account No." <> '' then begin
                    Clear(TempExpenseGLAccount);
                    TempExpenseGLAccount := "G/L Account";
                    TempExpenseGLAccount.Insert();
                    if GLAccount.Get("Revenue G/L Account No.") then begin
                        Clear(TempRevenueGLAccount);
                        TempRevenueGLAccount := GLAccount;
                        if TempRevenueGLAccount.Insert() then;
                    end;
                end;
                TempExpenseGLAccount.Reset();
                if TempExpenseGLAccount.FindSet() then
                    repeat
                        if TempRevenueGLAccount.Get(TempExpenseGLAccount."No.") then
                            TempRevenueGLAccount.Delete();
                    until TempExpenseGLAccount.Next() = 0;
            end;
        }

        dataitem(Loan; lvngLoan)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Date Funded";
            RequestFilterHeading = 'Loan';

            column(Filters; "G/L Account".GetFilters) { }
            column(LoanFilters; GetFilters) { }
            column(LoanNo; Loan."No.") { }
            column(DateFunded; Loan."Date Funded") { }
            column(DateSold; Loan."Date Sold") { }
            column(BorrowerFirstName; Loan."Borrower First Name") { }
            column(BorrowerMiddleName; Loan."Borrower Middle Name") { }
            column(BorrowerLastName; Loan."Borrower Last Name") { }
            column(LoanAmount; Loan."Loan Amount") { }
            column(CostCenter; CostCenterCode) { }
            column(LoanTypeCode; LoanTypeCode) { }
            column(LoanOfficerCode; LoanOfficerCode) { }

            dataitem(ExpenseLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(ExpensePostingDate; TempExpenses."Date Funded") { }
                column(ExpenseDescription; TempExpenses.Name) { }
                column(ExpenseGLAccountNo; TempExpenses."G/L Account No.") { }
                column(ExpenseGLAccountName; TempExpenseGLAccount.Name) { }
                column(ExpenseAmount; TempExpenses."Current Balance") { }
                column(ExpenseSection; ExpenseSection) { }

                trigger OnPreDataItem()
                begin
                    TempExpenses.Reset();
                    SetRange(Number, 1, TempExpenses.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempExpenses.FindSet()
                    else
                        TempExpenses.Next();
                    TempExpenseGLAccount.Get(TempExpenses."G/L Account No.");
                    RevenueSection := false;
                    ExpenseSection := true;
                end;
            }

            dataitem(RevenueLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(RevenuePostingDate; TempRevenue."Date Funded") { }
                column(RevenueDescription; TempRevenue.Name) { }
                column(RevenueGLAccountNo; TempRevenue."G/L Account No.") { }
                column(RevenueGLAccountName; TempRevenueGLAccount.Name) { }
                column(RevenueAmount; TempRevenue."Current Balance") { }
                column(RevenueSection; RevenueSection) { }

                trigger OnPreDataItem()
                begin
                    TempRevenue.Reset();
                    SetRange(Number, 1, TempRevenue.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempRevenue.FindSet()
                    else
                        TempRevenue.Next();
                    TempRevenueGLAccount.Get(TempRevenue."G/L Account No.");
                    RevenueSection := true;
                    ExpenseSection := false;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotalAmount := 0;
                TempExpenses.Reset();
                TempExpenses.DeleteAll();
                TempRevenue.Reset();
                TempRevenue.DeleteAll();
                CostCenterCode := '';
                LoanTypeCode := '';
                LoanOfficerCode := '';
                case DimensionNo of
                    1:
                        CostCenterCode := "Global Dimension 1 Code";
                    2:
                        CostCenterCode := "Global Dimension 2 Code";
                    3:
                        CostCenterCode := "Shortcut Dimension 3 Code";
                    4:
                        CostCenterCode := "Shortcut Dimension 4 Code";
                end;
                case LoanTypeDimensionNo of
                    1:
                        LoanTypeCode := "Global Dimension 1 Code";
                    2:
                        LoanTypeCode := "Global Dimension 2 Code";
                    3:
                        LoanTypeCode := "Shortcut Dimension 3 Code";
                    4:
                        LoanTypeCode := "Shortcut Dimension 4 Code";
                    5:
                        LoanTypeCode := "Shortcut Dimension 5 Code";
                    6:
                        LoanTypeCode := "Shortcut Dimension 6 Code";
                    7:
                        LoanTypeCode := "Shortcut Dimension 7 Code";
                    8:
                        LoanTypeCode := "Shortcut Dimension 8 Code";
                end;
                case LoanOfficerDimensionNo of
                    1:
                        LoanOfficerCode := "Global Dimension 1 Code";
                    2:
                        LoanOfficerCode := "Global Dimension 2 Code";
                    3:
                        LoanOfficerCode := "Shortcut Dimension 3 Code";
                    4:
                        LoanOfficerCode := "Shortcut Dimension 4 Code";
                    5:
                        LoanOfficerCode := "Shortcut Dimension 5 Code";
                    6:
                        LoanOfficerCode := "Shortcut Dimension 6 Code";
                    7:
                        LoanOfficerCode := "Shortcut Dimension 7 Code";
                    8:
                        LoanOfficerCode := "Shortcut Dimension 8 Code";
                end;
                GLEntry.Reset();
                GLEntry.SetRange("Loan No.", "No.");
                if DateFilter <> '' then
                    GLEntry.SetFilter("Posting Date", DateFilter);
                if GLEntry.FindSet() then
                    repeat
                        if TempExpenseGLAccount.Get(GLEntry."G/L Account No.") then begin
                            Clear(TempExpenses);
                            TempExpenses."G/L Account No." := GLEntry."G/L Account No.";
                            TempExpenses."Entry No." := GLEntry."Entry No.";
                            TempExpenses."Date Funded" := GLEntry."Posting Date";
                            TempExpenses."Current Balance" := GLEntry.Amount;
                            TotalAmount := TotalAmount + GLEntry.Amount;
                            TempExpenses.Name := GLEntry.Description;
                            TempExpenses.Insert();
                        end;
                        if TempRevenueGLAccount.Get(GLEntry."G/L Account No.") then begin
                            Clear(TempRevenue);
                            TempRevenue."G/L Account No." := GLEntry."G/L Account No.";
                            TempRevenue."Entry No." := GLEntry."Entry No.";
                            TempRevenue."Date Funded" := GLEntry."Posting Date";
                            TempRevenue."Current Balance" := GLEntry.Amount;
                            TempRevenue.Name := GLEntry.Description;
                            TempRevenue.Insert();
                            TotalAmount := TotalAmount + GLEntry.Amount;
                        end;
                    until GLEntry.Next() = 0;
                if SkipZeroBalance then
                    if TotalAmount = 0 then
                        CurrReport.Skip();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(SkipZeroBalanceLoans; SkipZeroBalance) { Caption = 'Skip Zero Balance Loans'; ApplicationArea = All; }
                }
            }
        }

        trigger OnOpenPage()
        begin
            SkipZeroBalance := true;
        end;
    }

    var
        GLSetup: Record "General Ledger Setup";
        LoanVisionSetup: Record lvngLoanVisionSetup;
        GLAccount: Record "G/L Account";
        TempExpenseGLAccount: Record "G/L Account" temporary;
        TempRevenueGLAccount: Record "G/L Account" temporary;
        GLEntry: Record "G/L Entry";
        TempExpenses: Record lvngGLEntryBuffer temporary;
        TempRevenue: Record lvngGLEntryBuffer temporary;
        CostCenterCode: Code[20];
        LoanTypeCode: Code[20];
        LoanOfficerCode: Code[20];
        DimensionNo: Integer;
        LoanTypeDimensionNo: Integer;
        LoanOfficerDimensionNo: Integer;
        DateFilter: Text;
        RevenueSection: Boolean;
        ExpenseSection: Boolean;
        SkipZeroBalance: Boolean;
        TotalAmount: Decimal;

    trigger OnPreReport()
    begin
        GLSetup.Get();
        LoanVisionSetup.Get();
        if LoanVisionSetup."Cost Center Dimension Code" <> '' then
            case LoanVisionSetup."Cost Center Dimension Code" of
                GLSetup."Shortcut Dimension 1 Code":
                    DimensionNo := 1;
                GLSetup."Shortcut Dimension 2 Code":
                    DimensionNo := 2;
                GLSetup."Shortcut Dimension 3 Code":
                    DimensionNo := 3;
                GLSetup."Shortcut Dimension 4 Code":
                    DimensionNo := 4;
                GLSetup."Shortcut Dimension 5 Code":
                    DimensionNo := 5;
                GLSetup."Shortcut Dimension 6 Code":
                    DimensionNo := 6;
                GLSetup."Shortcut Dimension 7 Code":
                    DimensionNo := 7;
                GLSetup."Shortcut Dimension 8 Code":
                    DimensionNo := 8;
            end;
        if LoanVisionSetup."Loan Type Dimension Code" <> '' then
            case LoanVisionSetup."Loan Type Dimension Code" of
                GLSetup."Shortcut Dimension 1 Code":
                    LoanTypeDimensionNo := 1;
                GLSetup."Shortcut Dimension 2 Code":
                    LoanTypeDimensionNo := 2;
                GLSetup."Shortcut Dimension 3 Code":
                    LoanTypeDimensionNo := 3;
                GLSetup."Shortcut Dimension 4 Code":
                    LoanTypeDimensionNo := 4;
                GLSetup."Shortcut Dimension 5 Code":
                    LoanTypeDimensionNo := 5;
                GLSetup."Shortcut Dimension 6 Code":
                    LoanTypeDimensionNo := 6;
                GLSetup."Shortcut Dimension 7 Code":
                    LoanTypeDimensionNo := 7;
                GLSetup."Shortcut Dimension 8 Code":
                    LoanTypeDimensionNo := 8;
            end;
        if LoanVisionSetup."Loan Officer Dimension Code" <> '' then
            case LoanVisionSetup."Loan Officer Dimension Code" of
                GLSetup."Shortcut Dimension 1 Code":
                    LoanOfficerDimensionNo := 1;
                GLSetup."Shortcut Dimension 2 Code":
                    LoanOfficerDimensionNo := 2;
                GLSetup."Shortcut Dimension 3 Code":
                    LoanOfficerDimensionNo := 3;
                GLSetup."Shortcut Dimension 4 Code":
                    LoanOfficerDimensionNo := 4;
                GLSetup."Shortcut Dimension 5 Code":
                    LoanOfficerDimensionNo := 5;
                GLSetup."Shortcut Dimension 6 Code":
                    LoanOfficerDimensionNo := 6;
                GLSetup."Shortcut Dimension 7 Code":
                    LoanOfficerDimensionNo := 7;
                GLSetup."Shortcut Dimension 8 Code":
                    LoanOfficerDimensionNo := 8;
            end;
        DateFilter := "G/L Account".GetFilter("Date Filter");
    end;
}