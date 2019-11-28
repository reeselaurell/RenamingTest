report 14135165 lvngAverageDailyTrialBalance
{
    Caption = 'Average Daily Trial Balance';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135165.rdl';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter", "Business Unit Filter", "Income/Balance", "Shortcut Dimension 3 Filter", "Shortcut Dimension 4 Filter";

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
                PeriodRec.Reset();
                PeriodRec.SetRange("Period Type", PeriodRec."Period Type"::Date);
                PeriodRec.SetRange("Period Start", DateFrom, DateTo);
                PeriodRec.FindSet();
                repeat
                    GLAccount.SetRange("Date Filter", 0D, PeriodRec."Period Start");
                    GLAccount.CalcFields("Balance at Date");
                    TotalAmount := TotalAmount + GLAccount."Balance at Date";
                until PeriodRec.Next() = 0;
                AvgDailyBalance := TotalAmount / TotalDays;
                if "Account Type" = "Account Type"::Posting then begin
                    if PrintType = PrintType::"Accounts with Balances" then
                        if (EndingBalance = 0) and (BeginningBalance = 0) then
                            ShowEntry := false;
                    if PrintType = PrintType::"Accounts with Activities" then begin
                        GLEntry.Reset();
                        GLEntry.SetRange("G/L Account No.", "No.");
                        GLEntry.SetFilter("G/L Account No.", Totaling);
                        GLENtry.SetRange("Business Unit Code", "Business Unit Filter");
                        GLEntry.SetRange("Global Dimension 1 Code", "Global Dimension 1 Filter");
                        GLEntry.SetRange("Global Dimension 2 Code", "Global Dimension 2 Filter");
                        GLEntry.SetRange("Posting Date", "Date Filter");
                        if GLEntry.IsEmpty then
                            ShowEntry := false
                        else
                            ShowEntry := true;
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
                    field(Show; PrintType) { Caption = 'Show'; ApplicationArea = All; }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        DateFrom := "G/L Account".GetRangeMin("Date Filter");
        DateTo := "G/L Account".GetRangeMax("Date Filter");
        TotalDays := DateTo - DateFrom + 1;
    end;

    var
        BeginningBalance: Decimal;
        EndingBalance: Decimal;
        AvgDailyBalance: Decimal;
        CompanyInformation: Record "Company Information";
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        DateFrom: Date;
        DateTo: Date;
        TotalDays: Integer;
        TotalAmount: Decimal;
        PeriodRec: Record Date;
        PrintType: Option "All Accounts","Accounts with Balances","Accounts with Activities";
        ShowEntry: Boolean;
        ShowBold: Boolean;
        HideValues: Boolean;
}