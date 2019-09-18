report 14135158 "lvngGeneralLedgerRecSimplified"
{
    Caption = 'General Ledger Rec Simplified';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135158.rdl';

    dataset
    {
        dataitem(lvngGLAccount; "G/L Account")
        {
            DataItemTableView = Sorting("No.") Where("Account Type" = const(Posting));
            RequestFilterFields = "No.", "Date Filter";
            PrintOnlyIfDetail = true;

            column(lvngCompanyName; CompanyInformation.Name)
            {

            }
            column(lvngGLEntryFilters; GLEntryFilters)
            {

            }
            column(lvngGLAccountFilters; GLAccountFilters)
            {

            }
            column(lvngLoanCardFilters; LoanCardFilters)
            {

            }
            column(lvngGLAccountNo; lvngGLAccount."No.")
            {

            }
            column(lvngGLAccountName; lvngGLAccount.Name)
            {

            }
            column(lvngShowDetails; ShowDetails)
            {

            }
            dataitem(lvngCycle; Integer)
            {
                DataItemTableView = sorting(Number);

                column(lvngLoanNo; LoanNo)
                {

                }
                column(lvngBorrowerName; TempLoan.lvngBorrowerName)
                {

                }
                column(lvngDateFunded; TempLoan.lvngDateFunded)
                {

                }
                column(lvngDebitAmount; TempLoan.lvngFee1Amount)
                {

                }
                column(lvngCreditAmount; TempLoan.lvngFee2Amount)
                {

                }
                column(lvngCurrentBalance; TempLoan.lvngFee3Amount)
                {

                }
                column(lvngLoanType; DefaultDimension."Dimension Value Code")
                {

                }
                dataitem(lvngGLEntry; "G/L Entry")
                {
                    DataItemTableView = SORTING("G/L Account No.", "Posting Date");
                    column(lvngTransactionDescription; lvngGLEntry.Description)
                    {

                    }
                    column(lvngPostingDate; lvngGLEntry."Posting Date")
                    {

                    }
                    column(lvngTransactionDebitAmount; lvngGLEntry."Debit Amount")
                    {

                    }
                    column(lvngTransactionCreditAmount; lvngGLEntry."Credit Amount")
                    {

                    }
                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date", DateFilter);
                        SetRange(lvngLoanNo, TempLoan.lvngLoanNo);
                        Setrange("G/L Account No.", lvngGLAccount."No.");
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if not ShowDetails then
                            CurrReport.Break();
                        if i <> 0 then begin
                            Clear(TempLoan.lvngFee1Amount);
                            Clear(TempLoan.lvngFee2Amount);
                            Clear(TempLoan.lvngFee3Amount);
                        end;
                        i := i + 1;
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
                    Clear(LoanNo);
                    Clear(DefaultDimension);
                    LoanNo := TempLoan.lvngLoanNo;
                    if LoanNo = '' then
                        LoanNo := 'BLANK';

                    if Loan.Get(TempLoan.lvngLoanNo) then begin
                        if not DefaultDimension.Get(DATABASE::lvngLoan, TempLoan.lvngLoanNo, LoanSetup.lvngLoanTypeDimensionCode) then
                            Clear(DefaultDimension);
                    end;
                    Clear(i);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                TempLoan.Reset();
                TempLoan.DeleteAll;
                Q.SetFilter(lvngGLAccountNoFilter, "No.");
                Q.SetFilter(lvngPostingDateFilter, DateFilter);
                Q.Open();
                while Q.Read() do begin
                    if (Q.lvngDebitAmount <> 0) OR (Q.lvngCreditAmount <> 0) then begin
                        if HideZeroBalance then begin
                            if Q.lvngDebitAmount - Q.lvngCreditAmount <> 0 then begin
                                Clear(TempLoan);
                                TempLoan.lvngLoanNo := Q.lvngLoanNo;
                                TempLoan.lvngFee1Amount := Q.lvngDebitAmount; //UPB
                                TempLoan.lvngFee2Amount := Q.lvngCreditAmount; //Note Rate
                                TempLoan.lvngBorrowerName := Q.lvngBorrowerFirstName + ' ' + Q.lvngBorrowerMiddleName + ' ' + Q.lvngBorrowerLastName;
                                TempLoan.lvngDateFunded := Q.lvngDateFunded;
                                TempLoan.lvngFee3Amount := Q.lvngDebitAmount - Q.lvngCreditAmount; //extension fee
                                TempLoan.Insert();
                            end;
                        end else begin
                            Clear(TempLoan);
                            TempLoan.lvngLoanNo := Q.lvngLoanNo;
                            TempLoan.lvngFee1Amount := Q.lvngDebitAmount; //UPB
                            TempLoan.lvngFee2Amount := Q.lvngCreditAmount; //Note Rate
                            TempLoan.lvngBorrowerName := Q.lvngBorrowerFirstName + ' ' + Q.lvngBorrowerMiddleName + ' ' + Q.lvngBorrowerLastName;
                            TempLoan.lvngDateFunded := Q.lvngDateFunded;
                            TempLoan.lvngFee3Amount := Q.lvngDebitAmount - Q.lvngCreditAmount; //extension fee
                            TempLoan.Insert();
                        end;
                    end;
                end;
                Q.Close();
                Clear(Q);
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
                    field(ShowDetails; ShowDetails)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Details';
                    }
                    field(HideZeroBalance; HideZeroBalance)
                    {
                        ApplicationArea = All;
                        Caption = 'Hide Zero Balance Entries';
                    }
                }
            }
        }

        actions
        {

        }
    }
    trigger OnPreReport()
    begin
        if lvngGLAccount.GetFilter("Date Filter") = '' then begin
            Error(Text001);
        end;
        CompanyInformation.Get();
        LoanCardFilters := Loan.GetFilters();
        GLAccountFilters := lvngGLAccount.GetFilters();
        GLEntryFilters := lvngGLAccount.GetFilters();

        DateFilter := lvngGLAccount.GetFilter("Date Filter");
        LoanSetup.Get();
        LoanSetup.TestField(LoanSetup.lvngLoanTypeDimensionCode);
    end;

    var
        loanSetup: Record lvngLoanVisionSetup;
        DefaultDimension: Record "Default Dimension";
        CompanyInformation: Record "Company Information";
        GLEntry: Record "G/L Entry";
        TempLoan: Record lvngCommissionBuffer temporary;
        Loan: Record lvngLoan;
        Q: Query lvngGLEntriesByLoanSums;
        DateFilter: Text;
        LoanCardFilters: Text;
        GLEntryFilters: Text;
        GLAccountFilters: Text;
        ShowDetails: Boolean;
        HideZeroBalance: Boolean;
        I: Integer;
        LoanNo: Code[20];
        Text001: TextConst ENU = 'Date Filter cannot be Blank';
}