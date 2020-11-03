report 14135158 "lvnAverageDailyTrialBalance"
{
    Caption = 'Average Daily Trial Balance';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135158.rdl';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter", lvnShortcutDimension3Filter, lvnShortcutDimension4Filter, "Income/Balance";

            column(GLAccountNo; "No.") { }
            column(Name; Name) { }
            column(NetChange; "Net Change") { }
            column(BeginningBalance; BeginningBalance) { }
            column(EndingBalance; EndingBalance) { }
            column(DebitAmount; "Debit Amount") { }
            column(CreditAmount; "Credit Amount") { }
            column(AverageDailyBalance; AvgDailyBalance) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(PostingAccount; ShowBold) { }
            column(FiltersData; GetFilters) { }
            column(FromDate; Format(DateFrom, 0, '<Month>/<Day,2>/<Year4>')) { }
            column(ToDate; Format(DateTo, 0, '<Month>/<Day,2>/<Year4>')) { }
            column(HideValues; HideValues) { }

            trigger OnAfterGetRecord()
            var
                GLAccount: Record "G/L Account";
                GLEntry: Record "G/L Entry";
                Period: Record Date;
                ShowEntry: Boolean;
                TotalAmount: Decimal;
            begin
                HideValues := false;
                ShowBold := not ("Account Type" = "Account Type"::Posting);
                if ShowBold then
                    if Totaling = '' then
                        HideValues := true;
                ShowEntry := true;
                TotalAmount := 0;
                GLAccount.Get("No.");
                GLAccount.CopyFilters("G/L Account");
                GLAccount.SetFilter("Date Filter", '..%1', DateFrom - 1);
                GLAccount.CalcFields("Balance at Date");
                BeginningBalance := GLAccount."Balance at Date";
                GLAccount.SetFilter("Date Filter", '..%1', DateTo);
                GLAccount.CalcFields("Balance at Date");
                EndingBalance := GLAccount."Balance at Date";
                Period.Reset();
                Period.SetRange("Period Type", Period."Period Type"::Date);
                Period.SetRange("Period Start", DateFrom, DateTo);
                Period.FindSet();
                repeat
                    GLAccount.SetRange("Date Filter", 0D, Period."Period Start");
                    GLAccount.CalcFields("Balance at Date");
                    TotalAmount := TotalAmount + GLAccount."Balance at Date";
                until Period.Next() = 0;
                AvgDailyBalance := TotalAmount / TotalDays;
                if "Account Type" = "Account Type"::Posting then
                    case PrintType of
                        PrintType::"Accounts with Balances":
                            if (EndingBalance = 0) and (BeginningBalance = 0) then
                                ShowEntry := false;
                        PrintType::"Accounts with Activities":
                            begin
                                GLEntry.Reset();
                                GLEntry.SetRange("G/L Account No.", "No.");
                                GLEntry.SetFilter("G/L Account No.", Totaling);
                                GLENtry.SetRange("Business Unit Code", "Business Unit Filter");
                                GLEntry.SetRange("Global Dimension 1 Code", "Global Dimension 1 Filter");
                                GLEntry.SetRange("Global Dimension 2 Code", "Global Dimension 2 Filter");
                                GLEntry.SetRange("Posting Date", "Date Filter");
                                ShowEntry := not GLEntry.IsEmpty();
                            end;
                    end;
                if not ShowEntry then
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
                    field(PrintType; PrintType) { Caption = 'Show'; ApplicationArea = All; }
                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        BeginningBalance: Decimal;
        EndingBalance: Decimal;
        AvgDailyBalance: Decimal;
        ShowBold: Boolean;
        HideValues: Boolean;
        DateFrom: Date;
        DateTo: Date;
        TotalDays: Integer;
        PrintType: Enum lvnDailyTrialBalancePrintType;

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        DateFrom := "G/L Account".GetRangeMin("Date Filter");
        DateTo := "G/L Account".GetRangeMax("Date Filter");
        TotalDays := DateTo - DateFrom + 1;
    end;
}