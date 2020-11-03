report 14135161 "lvnGeneralLedgerRecSimplified"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'General Ledger Reconciliation';
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135161.rdl';

    dataset
    {
        dataitem(GLAccount; "G/L Account")
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

            dataitem(Cycle; Integer)
            {
                DataItemTableView = sorting(Number);

                column(LoanNo; LoanNo) { }
                column(BorrowerName; BorrowerName) { }
                column(DateFunded; TempGLEntryBuffer."Date Funded") { }
                column(DebitAmount; TempGLEntryBuffer."Debit Amount") { }
                column(CreditAmount; TempGLEntryBuffer."Credit Amount") { }
                column(CurrentBalance; TempGLEntryBuffer."Current Balance") { }
                column(LoanType; DefaultDimension."Dimension Value Code") { }

                dataitem(GLEntry; "G/L Entry")
                {
                    DataItemTableView = sorting("G/L Account No.", "Posting Date");

                    column(TransactionDescription; Description) { }
                    column(PostingDate; "Posting Date") { }
                    column(TransactionDebitAmount; "Debit Amount") { }
                    column(TransactionCreditAmount; "Credit Amount") { }

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date", DateFilter);
                        SetRange(lvnLoanNo, TempGLEntryBuffer."Loan No.");
                        SetRange("G/L Account No.", GLAccount."No.");
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if not ShowDetails then
                            CurrReport.Break();
                        if Counter <> 0 then begin
                            TempGLEntryBuffer."Debit Amount" := 0;
                            TempGLEntryBuffer."Credit Amount" := 0;
                            TempGLEntryBuffer."Current Balance" := 0;
                        end;
                        Counter += 1;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    TempGLEntryBuffer.Reset();
                    SetRange(Number, 1, TempGLEntryBuffer.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempGLEntryBuffer.FindFirst()
                    else
                        TempGLEntryBuffer.Next();
                    Clear(Loan);
                    LoanNo := '';
                    Clear(DefaultDimension);
                    LoanNo := TempGLEntryBuffer."Loan No.";
                    if LoanNo = '' then
                        LoanNo := 'BLANK';
                    if Loan.Get(TempGLEntryBuffer."Loan No.") then
                        if not DefaultDimension.Get(Database::lvnLoan, TempGLEntryBuffer."Loan No.", LoanVisionSetup."Loan Type Dimension Code") then
                            Clear(DefaultDimension);
                    Counter := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                EntriesByLoanSums: Query lvnGLEntriesByLoanSums;
                LineNo: Integer;
            begin
                TempGLEntryBuffer.Reset();
                TempGLEntryBuffer.DeleteAll();
                EntriesByLoanSums.SetFilter(GLAccountNoFilter, "No.");
                EntriesByLoanSums.SetFilter(PostingDateFilter, DateFilter);
                EntriesByLoanSums.Open();
                while EntriesByLoanSums.Read() do begin
                    if (EntriesByLoanSums.DebitAmount <> 0) or (EntriesByLoanSums.CreditAmount <> 0) then
                        if HideZeroBalance then begin
                            if EntriesByLoanSums.DebitAmount - EntriesByLoanSums.CreditAmount <> 0 then begin
                                Clear(TempGLEntryBuffer);
                                TempGLEntryBuffer."Entry No." := LineNo;
                                TempGLEntryBuffer."Loan No." := EntriesByLoanSums.LoanNo;
                                TempGLEntryBuffer."Debit Amount" := EntriesByLoanSums.DebitAmount; //UPB
                                TempGLEntryBuffer."Credit Amount" := EntriesByLoanSums.CreditAmount; //Note Rate
                                BorrowerName := EntriesByLoanSums.BorrowerFirstName + ' ' + EntriesByLoanSums.BorrowerMiddleName + ' ' + EntriesByLoanSums.BorrowerLastName;
                                TempGLEntryBuffer."Date Funded" := EntriesByLoanSums.DateFunded;
                                TempGLEntryBuffer."Current Balance" := EntriesByLoanSums.DebitAmount - EntriesByLoanSums.CreditAmount; //extension fee
                                TempGLEntryBuffer.Insert();
                            end;
                        end else begin
                            Clear(TempGLEntryBuffer);
                            TempGLEntryBuffer."Entry No." := LineNo;
                            TempGLEntryBuffer."Loan No." := EntriesByLoanSums.LoanNo;
                            TempGLEntryBuffer."Debit Amount" := EntriesByLoanSums.DebitAmount; //UPB
                            TempGLEntryBuffer."Credit Amount" := EntriesByLoanSums.CreditAmount; //Note Rate
                            BorrowerName := EntriesByLoanSums.BorrowerFirstName + ' ' + EntriesByLoanSums.BorrowerMiddleName + ' ' + EntriesByLoanSums.BorrowerLastName;
                            TempGLEntryBuffer."Date Funded" := EntriesByLoanSums.DateFunded;
                            TempGLEntryBuffer."Current Balance" := EntriesByLoanSums.DebitAmount - EntriesByLoanSums.CreditAmount; //extension fee
                            TempGLEntryBuffer.Insert();
                        end;
                    LineNo += 1;
                end;
                EntriesByLoanSums.Close();
                Clear(EntriesByLoanSums);
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
                    field(HideZeroBalance; HideZeroBalance) { ApplicationArea = All; Caption = 'Hide Zero Balance'; }
                }
            }
        }
    }

    var
        DateFilterErr: Label 'Date Filter can''t be blank';
        CompanyInformation: Record "Company Information";
        LoanVisionSetup: Record lvnLoanVisionSetup;
        TempGLEntryBuffer: Record lvnGLEntryBuffer temporary;
        DefaultDimension: Record "Default Dimension";
        Loan: Record lvnLoan;
        BorrowerName: Text;
        DateFunded: Date;
        DateFilter: Text;
        LoanCardFilters: Text;
        GLEntryFilters: Text;
        GLAccountFilters: Text;
        ShowDetails: Boolean;
        HideZeroBalance: Boolean;
        LoanNo: Code[20];
        Counter: Integer;

    trigger OnPreReport()
    begin
        LoanVisionSetup.Get();
        if GLAccount.GetFilter("Date Filter") = '' then
            Error(DateFilterErr);
        LoanVisionSetup.TestField("Loan Type Dimension Code");
        CompanyInformation.Get();
        LoanCardFilters := Loan.GetFilters();
        GLAccountFilters := GLAccount.GetFilters();
        GLEntryFilters := GLEntry.GetFilters();
        DateFilter := GLAccount.GetFilter("Date Filter");
        LoanVisionSetup.Get();
    end;
}