report 14135156 lvngGeneralLedgerRecSimplified
{
    Caption = 'General Ledger Rec. Simplified';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135156.rdl';

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
            column(GLAccountNo; "G/L Account"."No.") { }
            column(GLAccountName; "G/L Account".Name) { }
            column(ShowDetails; ShowDetails) { }

            dataitem(Cycle; Integer)
            {
                DataItemTableView = sorting(Number);

                column(LoanNo; LoanNo) { }
                column(BorrowerFirstName; TempLoan."Borrower First Name") { }
                column(BorrowerMiddleName; TempLoan."Borrower Middle Name") { }
                column(BorrowerLastName; TempLoan."Borrower Last Name") { }
                column(DateFunded; TempLoan."Date Funded") { }
                column(DebitAmount; TempLoan."Fee 1 Amount") { }
                column(CreditAmount; TempLoan."Fee 2 Amount") { }
                column(CurrentBalance; TempLoan."Fee 3 Amount") { }
                column(LoanType; DefaultDimension."Dimension Value Code") { }

                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemTableView = sorting("G/L Account No.", "Posting Date");

                    column(TransactionDescription; "G/L Entry".Description) { }
                    column(PostingDate; "Posting Date") { }
                    column(TransactionDebitAmount; "G/L Entry"."Debit Amount") { }
                    column(TransactionCreditAmount; "G/L Entry"."Credit Amount") { }

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date", DateFilter);
                        SetRange("Loan No.", TempLoan."Loan No.");
                        SetRange("G/L Account No.", "G/L Account"."No.");
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if not ShowDetails then
                            CurrReport.Break();
                        if Counter <> 0 then begin
                            TempLoan."Fee 1 Amount" := 0;
                            TempLoan."Fee 2 Amount" := 0;
                            TempLoan."Fee 3 Amount" := 0;
                        end;
                        Counter := Counter + 1;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    TempLoan.Reset();
                    SetRange(Number, 1, TempLoan.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempLoan.FindSet()
                    else
                        TempLoan.Next();
                    Clear(Loan);
                    LoanNo := '';
                    Clear(DefaultDimension);
                    LoanNo := TempLoan."Loan No.";
                    if LoanNo = '' then
                        LoanNo := 'BLANK';
                    if Loan.Get(TempLoan."Loan No.") then
                        if not DefaultDimension.Get(Database::lvngLoan, TempLoan."Loan No.", LoanSetup."Loan Type Dimension Code") then
                            Clear(DefaultDimension);
                    Counter := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TempLoan.Reset();
                TempLoan.DeleteAll();
                LoanSumsQue.SetFilter(GLAccountNoFilter, "No.");
                LoanSumsQue.SetFilter(PostingDateFilter, DateFilter);
                LoanSumsQue.Open();
                while LoanSumsQue.Read() do begin
                    if (LoanSumsQue.DebitAmount <> 0) or (LoanSumsQue.CreditAmount <> 0) then
                        if HideZeroBalance then begin
                            if LoanSumsQue.DebitAmount - LoanSumsQue.CreditAmount <> 0 then begin
                                Clear(TempLoan);
                                TempLoan."Loan No." := LoanSumsQue.LoanNo;
                                TempLoan."Fee 1 Amount" := LoanSumsQue.DebitAmount; //UPB
                                TempLoan."Fee 2 Amount" := LoanSumsQue.CreditAmount; //Note Rate
                                TempLoan."Borrower First Name" := LoanSumsQue.BorrowerFirstName;
                                TempLoan."Borrower Middle Name" := LoanSumsQue.BorrowerMiddleName;
                                TempLoan."Borrower Last Name" := LoanSumsQue.BorrowerLastName;
                                TempLoan."Date Funded" := LoanSumsQue.DateFunded;
                                TempLoan."Fee 3 Amount" := LoanSumsQue.DebitAmount - LoanSumsQue.CreditAmount; //extension fee
                                TempLoan.Insert();
                            end;
                        end else begin
                            Clear(TempLoan);
                            TempLoan."Loan No." := LoanSumsQue.LoanNo;
                            TempLoan."Fee 1 Amount" := LoanSumsQue.DebitAmount; //UPB
                            TempLoan."Fee 2 Amount" := LoanSumsQue.CreditAmount; //Note Rate
                            TempLoan."Borrower First Name" := LoanSumsQue.BorrowerFirstName;
                            TempLoan."Borrower Middle Name" := LoanSumsQue.BorrowerMiddleName;
                            TempLoan."Borrower Last Name" := LoanSumsQue.BorrowerLastName;
                            TempLoan."Date Funded" := LoanSumsQue.DateFunded;
                            TempLoan."Fee 3 Amount" := LoanSumsQue.DebitAmount - LoanSumsQue.CreditAmount; //extension fee
                            TempLoan.Insert();
                        end;
                end;
                LoanSumsQue.Close();
                Clear(LoanSumsQue);
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
                    field(ShowDetails; ShowDetails) { Caption = 'Show Details'; ApplicationArea = All; }
                    field(HideZeroBalance; HideZeroBalance) { Caption = 'Hide Zero Balance'; ApplicationArea = All; }
                }
            }
        }
    }

    var
        DateFilterBlankErr: Label 'Date Filter can''t be blank.';
        LoanSetup: Record lvngLoanVisionSetup;
        DefaultDimension: Record "Default Dimension";
        CompanyInformation: Record "Company Information";
        GLEntry: Record "G/L Entry";
        TempLoan: Record lvngCommissionBuffer temporary;
        Loan: Record lvngLoan;
        LoanSumsQue: Query lvngGLEntriesByLoanSums;
        DateFilter: Text;
        GLEntryFilters: Text;
        LoanCardFilters: Text;
        GLAccountFilters: Text;
        ShowDetails: Boolean;
        HideZeroBalance: Boolean;
        Counter: Integer;
        LoanNo: Code[20];

    trigger OnPreReport()
    begin
        if "G/L Account".GetFilter("Date Filter") = '' then
            Error(DateFilterBlankErr);
        CompanyInformation.Get();
        LoanCardFilters := Loan.GetFilters;
        GLAccountFilters := "G/L Account".GetFilters;
        GLEntryFilters := "G/L Entry".GetFilters;
        DateFilter := "G/L Account".GetFilter("Date Filter");
        LoanSetup.Get();
        LoanSetup.TestField(LoanSetup."Loan Type Dimension Code");
    end;
}