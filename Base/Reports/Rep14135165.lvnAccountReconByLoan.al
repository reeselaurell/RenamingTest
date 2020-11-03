report 14135165 "lvnAccountReconByLoan"
{
    Caption = 'Account Reconciliation by Loan';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135165.rdl';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type" = const(Posting));
            RequestFilterFields = "No.", "Date Filter";
            PrintOnlyIfDetail = true;

            column(CompanyName; CompanyInformation.Name) { }
            column(GLEntryFilters; GLEntryFilters) { }
            column(GLAccountFilters; GLAccountFilters) { }
            column(LoanCardFilters; LoanCardFilters) { }
            column(GLAccountNo; "No.") { }
            column(GLAccountName; Name) { }
            column(ShowDetails; ShowDetails) { }

            dataitem(Loop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(LoanNo; Loan."No.") { }
                column(BorrowerName; BorrowerName) { }
                column(DateFunded; Loan."Date Funded") { }
                column(DateSold; Loan."Date Sold") { }
                column(DebitAmount; DebitAmount) { }
                column(CreditAmount; CreditAmount) { }
                column(CurrentBalance; CurrentBalance) { }
                column(Dimension1Code; Loan."Global Dimension 1 Code") { }
                column(Dimension2Code; Loan."Global Dimension 2 Code") { }
                column(GLStartingBalanceLoan; GLStartingBalanceLoan) { }
                column(GLEndingBalanceLoan; GLEndingBalanceLoan) { }
                column(Dim1Caption; Loan.FieldCaption("Global Dimension 1 Code")) { }
                column(Dim2Caption; Loan.FieldCaption("Global Dimension 2 Code")) { }

                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemTableView = sorting("Entry No.");

                    column(TransactionDescription; Description) { }
                    column(PostingDate; "Posting Date") { }
                    column(TransactionDebitAmount; "Debit Amount") { }
                    column(TransactionCreditAmount; "Credit Amount") { }
                    column(GlobalDimension1CodeGL; "Global Dimension 1 Code") { }
                    column(GlobalDimension2CodeGL; "Global Dimension 2 Code") { }

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date", DateFilter);
                        SetRange(lvnLoanNo, Loan."No.");
                        SetRange("G/L Account No.", "G/L Account"."No.");
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if RecCounter = 0 then begin
                            CreditAmount := 0;
                            DebitAmount := 0;
                            CurrentBalance := 0;
                            GLEndingBalanceLoan := 0;
                            GLStartingBalanceLoan := 0;
                        end;
                        CreditAmountTtl[1] += CreditAmount;
                        DebitAmountTtl[1] += DebitAmount;
                        GLStartingTtl[1] += GLStartingBalanceLoan;
                        GLEndingTtl[1] += GLEndingBalanceLoan;
                        CurrentBalanceTtl[1] += CurrentBalance;
                        CreditAmountTtl[2] += CreditAmount;
                        DebitAmountTtl[2] += DebitAmount;
                        GLStartingTtl[2] += GLStartingBalanceLoan;
                        GLEndingTtl[2] += GLEndingBalanceLoan;
                        CurrentBalanceTtl[2] += CurrentBalance;
                        RecCounter += 1;
                        if ExcelToExport then
                            WriteExcelRow();
                        if not ShowDetails then
                            CurrReport.Break();
                    end;

                    trigger OnPostDataItem()
                    begin
                        WriteExcelTotals(1);
                    end;
                }

                trigger OnPreDataItem()
                begin
                    CreditAmountTtl[1] := 0;
                    DebitAmountTtl[1] := 0;
                    GLStartingTtl[1] := 0;
                    GLEndingTtl[1] := 0;
                    CurrentBalanceTtl[1] := 0;
                    TempLoan.Reset();
                    TempLoan.CopyFilters(LoanFilters);
                    SetRange(Number, 1, TempLoan.Count);
                end;

                trigger OnAfterGetRecord()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    if Number = 1 then
                        TempLoan.FindSet()
                    else
                        TempLoan.Next();
                    Loan.Get(TempLoan."No.");
                    BorrowerName := lvnLoanManagement.GetBorrowerName(Loan);
                    CurrentBalance := 0;
                    GLStartingBalanceLoan := 0;
                    GLEndingBalanceLoan := 0;
                    DebitAmount := 0;
                    CreditAmount := 0;
                    RecCounter := 0;
                    GLEntry.Reset();
                    GLEntry.SetCurrentKey("G/L Account No.", "Posting Date", lvnLoanNo);
                    //TODO: will not work, can't have composite key here from extension table and base, change to SetLoadFields, and repeat clause, should use buffer to get data from lvnGroupedLoanGLEntry

                    GLEntry.SetRange("G/L Account No.", "G/L Account"."No.");
                    GLEntry.SetFilter("Posting Date", DateFilter);
                    GLEntry.SetRange(lvnLoanNo, Loan."No.");
                    if not GLEntry.IsEmpty() then begin
                        DebitAmount := TempLoan."Monthly Escrow Amount";
                        CreditAmount := TempLoan."Monthly Payment Amount";
                        CurrentBalance := DebitAmount - CreditAmount;
                        if CurrentBalance = 0 then
                            CurrReport.Skip()
                        else begin
                            GLEntry.SetRange("Posting Date", 0D, MinDate - 1);
                            GLEntry.CalcSums(Amount);
                            GLStartingBalanceLoan := GLEntry.Amount;
                            GLEntry.SetRange("Posting Date", 0D, MaxDate);
                            GLEntry.CalcSums(Amount);
                            GLEndingBalanceLoan := GLEntry.Amount;
                        end;
                    end else begin
                        Clear(GLEntry);
                        CurrReport.Skip();
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                AccountReconByLoan: Query lvnAccountReconByLoan;
                EntryNo: Integer;
            begin
                AccountReconByLoan.SetFilter(PostingDateFilter, DateFilter);
                AccountReconByLoan.SetFilter(LoanNoFilter, LoanNoFilter);
                AccountReconByLoan.SetRange(GLAccountFilter, "No.");
                TempLoan.Reset();
                TempLoan.DeleteAll();
                AccountReconByLoan.Open();
                while AccountReconByLoan.Read() do
                    if AccountReconByLoan.LoanNo <> '' then
                        if Loan.Get(AccountReconByLoan.LoanNo) then begin
                            Clear(TempLoan);
                            TempLoan := Loan;
                            TempLoan."Monthly Escrow Amount" := AccountReconByLoan.DebitAmount;
                            TempLoan."Monthly Payment Amount" := AccountReconByLoan.CreditAmount;
                            TempLoan.Insert();
                            EntryNo += 1;
                        end;
                AccountReconByLoan.Close();
                TempLoan.Reset();
                if TempLoan.IsEmpty() then
                    CurrReport.Skip();
            end;
        }

        dataitem(LoanFilters; lvnLoan)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Date Funded", "Global Dimension 2 Code", "Borrower Customer No.", "Borrower Last Name";

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
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
                    field(ShowDetails; ShowDetails) { ApplicationArea = All; Caption = 'Show Details'; }
                    field(ExcelToExport; ExcelToExport) { ApplicationArea = All; Caption = 'Export to Excel'; }
                    field(NumberFormat; NumberFormat) { ApplicationArea = All; Caption = 'Currency Format'; Editable = ExcelToExport; TableRelation = lvnNumberFormat.Code; }
                }
            }
        }
    }

    var
        ColorCodeLbl: Label '#D2D2D2';
        NoDateFilterErr: Label 'Date Filter can''t be blank';
        NoLoanFiltersErr: Label 'Please prefilter Loan Card information';
        ExcelExportCaller: Label 'AccountReconByLoan';
        FileName: Label 'AccountReconExport.xlsx';
        CompanyInformation: Record "Company Information";
        Loan: Record lvnLoan;
        TempLoan: Record lvnLoan temporary;
        ExcelExport: Codeunit lvnExcelExport;
        lvnLoanManagement: Codeunit lvnLoanManagement;
        BorrowerName: Text;
        GLEntryFilters: Text;
        GLAccountFilters: Text;
        LoanCardFilters: Text;
        DateFilter: Text;
        ShowDetails: Boolean;
        [InDataSet]
        ExcelToExport: Boolean;
        LoanNoFilter: Text;
        NumberFormat: Code[20];
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        CurrentBalance: Decimal;
        GLStartingBalanceLoan: Decimal;
        GLEndingBalanceLoan: Decimal;
        RecCounter: Integer;
        MinDate: Date;
        MaxDate: Date;
        DebitAmountTtl: array[2] of Decimal;
        CreditAmountTtl: array[2] of Decimal;
        CurrentBalanceTtl: array[2] of Decimal;
        GLStartingTtl: array[2] of Decimal;
        GLEndingTtl: array[2] of Decimal;

    trigger OnPreReport()
    var
        OutputFormat: Enum lvnGridExportMode;
    begin
        if "G/L Account".GetFilter("Date Filter") = '' then
            Error(NoDateFilterErr);
        if LoanFilters.GetFilters() = '' then
            Error(NoLoanFiltersErr);
        CompanyInformation.Get();
        LoanCardFilters := LoanFilters.GetFilters();
        GLAccountFilters := "G/L Account".GetFilters();
        GLEntryFilters := "G/L Entry".GetFilters();
        DateFilter := "G/L Account".GetFilter("Date Filter");
        MinDate := "G/L Account".GetRangeMin("Date Filter");
        MaxDate := "G/L Account".GetRangeMax("Date Filter");
        LoanNoFilter := LoanFilters.GetFilter("No.");
        if ExcelToExport then begin
            ExcelExport.Init(ExcelExportCaller, OutputFormat::Xlsx);
            WriteExcelHeaders();
        end;
    end;

    trigger OnPostReport()
    begin
        WriteExcelTotals(2);
        if ExcelToExport then
            ExcelExport.Download(FileName);
    end;

    local procedure WriteExcelHeaders()
    begin
        ExcelExport.NewRow(0);
        WriteToExcel(CompanyInformation.Name, true, 2, false, '', false, false);
        ExcelExport.NewRow(1);
        WriteToExcel('Account Reconciliation by Loan', true, 11, true, '', true, false);
        ExcelExport.NewRow(2);
        WriteToExcel(LoanCardFilters, true, 3, false, '', false, false);
        ExcelExport.NewRow(3);
        WriteToExcel(GLAccountFilters, true, 3, false, '', false, false);
        ExcelExport.NewRow(4);
        WriteToExcel(GLEntryFilters, true, 3, false, '', false, false);
        ExcelExport.NewRow(5);
        WriteToExcel('Account No.', false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel('Loan No.', false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel('Date Funded', false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel('Date Sold', false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel('Name', false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel(Loan.FieldCaption("Global Dimension 1 Code"), false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel(Loan.FieldCaption("Global Dimension 2 Code"), false, 0, false, ColorCodeLbl, true, false);
        if ShowDetails then
            WriteToExcel('Trans. Date', false, 0, false, ColorCodeLbl, true, false)
        else
            WriteToExcel('', false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel('Starting Balance', false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel('Debit Amount', false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel('Credit Amount', false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel('Net Change', false, 0, false, ColorCodeLbl, true, false);
        WriteToExcel('Ending Balance', false, 0, false, ColorCodeLbl, true, false);
    end;

    local procedure WriteExcelRow()
    begin
        ExcelExport.NewRow(-10);
        WriteToExcel("G/L Account"."No.", false, 0, false, '', false, false);
        ExcelExport.SkipCells(3);
        WriteToExcel("G/L Account".Name, false, 0, false, '', false, false);
        ExcelExport.NewRow(-20);
        ExcelExport.SkipCells(1);
        WriteToExcel(Loan."No.", false, 0, false, '', false, false);
        WriteToExcel(Loan."Date Funded", false, 0, false, '', false, false);
        WriteToExcel(Loan."Date Sold", false, 0, false, '', false, false);
        WriteToExcel(BorrowerName, false, 0, false, '', false, false);
        WriteToExcel(Loan."Global Dimension 1 Code", false, 0, false, '', false, false);
        WriteToExcel(Loan."Global Dimension 2 Code", false, 0, false, '', false, false);
        WriteToExcel('', false, 0, false, '', false, false);
        WriteToExcel(GLStartingBalanceLoan, false, 0, false, '', false, true);
        WriteToExcel(DebitAmount, false, 0, false, '', false, true);
        WriteToExcel(CreditAmount, false, 0, false, '', false, true);
        WriteToExcel(CurrentBalance, false, 0, false, '', false, true);
        WriteToExcel(GLEndingBalanceLoan, false, 0, false, '', false, true);
        if ShowDetails then begin
            ExcelExport.NewRow(-30);
            ExcelExport.SkipCells(2);
            WriteToExcel("G/L Entry".Description, true, 1, false, '', false, false);
            WriteToExcel("G/L Entry"."Global Dimension 1 Code", false, 0, false, '', false, false);
            WriteToExcel("G/L Entry"."Global Dimension 2 Code", false, 0, false, '', false, false);
            WriteToExcel("G/L Entry"."Posting Date", false, 0, false, '', false, false);
            ExcelExport.SkipCells(1);
            WriteToExcel("G/L Entry"."Debit Amount", false, 0, false, '', false, true);
            WriteToExcel("G/L Entry"."Credit Amount", false, 0, false, '', false, true);
        end;
    end;

    local procedure WriteExcelTotals(Int: Integer)
    begin
        ExcelExport.NewRow(10);
        ExcelExport.SkipCells(7);
        if Int = 1 then
            WriteToExcel(StrSubstNo('Total for %1:', "G/L Account"."No."), false, 0, false, '', true, false)
        else
            WriteToExcel('Grand Totals:', false, 0, false, '', true, false);
        WriteToExcel(GLStartingTtl[Int], false, 0, false, '', true, true);
        WriteToExcel(DebitAmountTtl[Int], false, 0, false, '', true, true);
        WriteToExcel(CreditAmountTtl[Int], false, 0, false, '', true, true);
        WriteToExcel(CurrentBalanceTtl[Int], false, 0, false, '', true, true);
        WriteToExcel(GLEndingTtl[Int], false, 0, false, '', true, true);

    end;

    local procedure WriteToExcel(Output: Variant; CreateRange: Boolean; SkipCells: Integer; CenterText: Boolean; CellColor: Text; Bold: Boolean; Currency: Boolean)
    var
        DefaultBoolean: Enum lvnDefaultBoolean;
    begin
        if CreateRange then
            ExcelExport.BeginRange();
        if Bold then
            ExcelExport.StyleCell(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', CellColor)
        else
            ExcelExport.StyleCell(DefaultBoolean::No, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', CellColor);
        if Currency then
            ExcelExport.FormatCell(NumberFormat);
        if Output.IsCode() or Output.IsText() or Output.IsTextConstant() then
            ExcelExport.WriteString(Output);
        if Output.IsDecimal() or Output.IsInteger() then
            ExcelExport.WriteNumber(Output);
        if Output.IsDate() then
            ExcelExport.WriteDate(Output);
        if CreateRange then begin
            ExcelExport.SkipCells(SkipCells);
            ExcelExport.MergeRange(CenterText);
        end;
    end;
}