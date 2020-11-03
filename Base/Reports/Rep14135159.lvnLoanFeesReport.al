report 14135159 "lvnLoanFeesReport"
{
    Caption = 'Loan Fees Report';
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135159.rdl';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Date Filter";

            trigger OnAfterGetRecord()
            var
                GLAccount: Record "G/L Account";
            begin
                if "G/L Account".lvnRevenueGLAccountNo <> '' then begin
                    Clear(TempExpenseGLAccount);
                    TempExpenseGLAccount := "G/L Account";
                    TempExpenseGLAccount.Insert();
                    if GLAccount.Get(lvnRevenueGLAccountNo) then begin
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

        dataitem(Loan; lvnLoan)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Date Funded";

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
                    SetRange(Number, 1, TempExpenses.Count());
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
            var
                DimMgmt: Codeunit lvnDimensionsManagement;
                TotalAmount: Decimal;
            begin
                TotalAmount := 0;
                TempExpenses.Reset();
                TempExpenses.DeleteAll();
                TempRevenue.Reset();
                TempRevenue.DeleteAll();
                CostCenterCode := '';
                LoanTypeCode := '';
                LoanOfficerCode := '';
                DimMgmt.FillDimensionsFromTable(Loan, Dimensions);
                CostCenterCode := Dimensions[DimensionNo];
                LoanTypeCode := Dimensions[LoanTypeDimensionNo];
                LoanOfficerCode := Dimensions[LoanOfficerDimensionNo];
                GLEntry.Reset();
                GLEntry.SetRange(lvnLoanNo, "No.");
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
        TempExpenseGLAccount: Record "G/L Account" temporary;
        TempRevenueGLAccount: Record "G/L Account" temporary;
        GLEntry: Record "G/L Entry";
        TempExpenses: Record lvnGLEntryBuffer temporary;
        TempRevenue: Record lvnGLEntryBuffer temporary;
        CostCenterCode: Code[20];
        LoanTypeCode: Code[20];
        LoanOfficerCode: Code[20];
        Dimensions: array[8] of Code[20];
        DimensionNo: Integer;
        LoanTypeDimensionNo: Integer;
        LoanOfficerDimensionNo: Integer;
        DateFilter: Text;
        RevenueSection: Boolean;
        ExpenseSection: Boolean;
        SkipZeroBalance: Boolean;

    trigger OnPreReport()
    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        DimMgmt: Codeunit lvnDimensionsManagement;
    begin
        LoanVisionSetup.Get();
        if LoanVisionSetup."Cost Center Dimension Code" <> '' then
            DimensionNo := DimMgmt.GetDimensionNo(LoanVisionSetup."Cost Center Dimension Code");
        if LoanVisionSetup."Loan Type Dimension Code" <> '' then
            LoanTypeDimensionNo := DimMgmt.GetDimensionNo(LoanVisionSetup."Loan Type Dimension Code");
        if LoanVisionSetup."Loan Officer Dimension Code" <> '' then
            LoanOfficerDimensionNo := DimMgmt.GetDimensionNo(LoanVisionSetup."Loan Officer Dimension Code");
        DateFilter := "G/L Account".GetFilter("Date Filter");
    end;
}