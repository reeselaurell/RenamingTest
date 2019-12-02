report 14135153 lvngLoanProfitability
{
    Caption = 'Loan Profitability';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135153.rdl';

    dataset
    {
        dataitem(Loan; lvngLoan)
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");

            column(LoanNo; "No.") { }
            column(BorrowerFirstName; "Borrower First Name") { }
            column(BorrowerMiddleName; "Borrower Middle Name") { }
            column(BorrowerLastName; "Borrower Last Name") { }
            column(DateFunded; "Date Funded") { }
            column(WarehouseLineCode; "Warehouse Line Code") { }
            column(LoanType; LoanType) { }
            column(InterestRate; "Interest Rate") { }
            column(DateSold; "Date Sold") { }
            column(InvestorName; InvestorName) { }
            column(LoanAmount; "Loan Amount") { }
            column(LoanOfficerName; LoanOfficerName) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(AsOfDate; AsOfDate) { }

            dataitem(DataSetValues; Integer)
            {
                DataItemTableView = sorting(Number);
                column(BalanceAtDate; CalculatedValue) { }
                column(ReportingAccountType; ReportingAccountType) { }
                column(Descripiton; Buffer."Value as Text") { }

                trigger OnPreDataItem()
                begin
                    Buffer.Reset();
                    SetRange(Number, 1, Buffer.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        Buffer.FindSet()
                    else
                        Buffer.Next();
                    Clear(CalculatedValue);
                    GLAccount.Reset();
                    GLAccount.SetRange(lvngReportingAccountName, Buffer."Value as Text");
                    GLAccount.FindSet();
                    repeat
                        if GLAccount.Totaling <> '' then
                            GLEntriesByDimension.SetFilter(GLAccountNoFilter, GLAccount.Totaling)
                        else
                            GLEntriesByDimension.SetRange(GLAccountNoFilter, GLAccount."No.");
                        GLEntriesByDimension.Open();
                        if GLEntriesByDimension.Read() then
                            CalculatedValue := CalculatedValue + GLEntriesByDimension.SumAmount;
                    until GLAccount.Next() = 0;
                    GLEntriesByDimension.Close();
                    if Buffer.Bold then
                        ReportingAccountType := 1
                    else
                        ReportingAccountType := 2;
                    if CalculatedValue = 0 then
                        CurrReport.Skip();
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(LoanType);
                Clear(LoanOfficerName);
                if DefaultDimension.Get(Database::lvngLoan, "No.", LoanVisionSetup."Loan Type Dimension Code") then
                    LoanType := DefaultDimension."Dimension Value Code";
                if DefaultDimension.Get(Database::lvngLoan, "No.", LoanVisionSetup."Loan Officer Dimension Code") then
                    if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", DefaultDimension."Dimension Value Code") then begin
                        LoanOfficerName := DimensionValue.Name;
                        if LoanOfficerName = '' then
                            LoanOfficerName := DimensionValue.Code;
                    end;
                Clear(InvestorName);
                if Customer.Get("Investor Customer No.") then
                    InvestorName := Customer.Name;
                GLEntriesByDimension.SetRange(LoanNoFilter, Loan."No.");
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
                    group("G/L Transactions")
                    {
                        field(FromDate; PeriodStart) { ApplicationArea = All; Caption = 'From Date'; }
                        field(ToDate; PeriodEnd1) { ApplicationArea = All; Caption = 'To Date'; }
                    }

                    field(ReportingType; ReportingType) { Caption = 'Reporting Type'; OptionCaption = ',Income,Expense'; }

                    group(Dimensions)
                    {
                        Caption = 'G/L Entries Deimension Filter';

                        field(Dimension1Filter; Dimension1Filter) { ApplicationArea = All; Visible = Dimension1FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); CaptionClass = '1,1,1'; }
                        field(Dimension2Filter; Dimension2Filter) { ApplicationArea = All; Visible = Dimension2FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); CaptionClass = '1,1,2'; }
                        field(Dimension3Filter; Dimension3Filter) { ApplicationArea = All; Visible = Dimension3FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); CaptionClass = '1,2,3'; }
                        field(Dimension4Filter; Dimension4Filter) { ApplicationArea = All; Visible = Dimension4FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); CaptionClass = '1,2,4'; }
                        field(Dimension5Filter; Dimension5Filter) { ApplicationArea = All; Visible = Dimension5FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); CaptionClass = '1,2,5'; }
                        field(Dimension6Filter; Dimension6Filter) { ApplicationArea = All; Visible = Dimension6FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); CaptionClass = '1,2,6'; }
                        field(Dimension7Filter; Dimension7Filter) { ApplicationArea = All; Visible = Dimension7FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); CaptionClass = '1,2,7'; }
                        field(Dimension8Filter; Dimension8Filter) { ApplicationArea = All; Visible = Dimension8FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); CaptionClass = '1,2,8'; }
                    }
                }
            }
        }

        trigger OnInit()
        begin
            GeneralLedgerSetup.Get();
        end;

        trigger OnOpenPage()
        var
            DimensionManagement: Codeunit DimensionManagement;
        begin
            DimensionManagement.UseShortcutDims(Dimension1FilterVisible, Dimension2FilterVisible, Dimension3FilterVisible, Dimension4FilterVisible, Dimension5FilterVisible, Dimension6FilterVisible, Dimension7FilterVisible, Dimension8FilterVisible);
        end;
    }

    var
        CompanyInformation: Record "Company Information";
        GeneralLedgerSetup: Record "General Ledger Setup";
        DefaultDimension: Record "Default Dimension";
        LoanVisionSetup: Record lvngLoanVisionSetup;
        Buffer: Record lvngDataStorageBuffer temporary;
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        DimensionValue: Record "Dimension Value";
        GLEntriesByDimension: Query lvngGLEntriesByDimension;
        PeriodEnd: Date;
        PeriodEnd1: Date;
        PeriodStart: Date;
        Dimension1Filter: Code[20];
        Dimension2Filter: Code[20];
        Dimension3Filter: Code[20];
        Dimension4Filter: Code[20];
        Dimension5Filter: Code[20];
        Dimension6Filter: Code[20];
        Dimension7Filter: Code[20];
        Dimension8Filter: Code[20];
        Dimension1FilterVisible: Boolean;
        Dimension2FilterVisible: Boolean;
        Dimension3FilterVisible: Boolean;
        Dimension4FilterVisible: Boolean;
        Dimension5FilterVisible: Boolean;
        Dimension6FilterVisible: Boolean;
        Dimension7FilterVisible: Boolean;
        Dimension8FilterVisible: Boolean;
        AsOfDate: Text[250];
        LoanType: Text;
        LoanOfficerName: Text;
        InvestorName: Text;
        EntryNo: Integer;
        ReportingAccountType: Integer;
        CalculatedValue: Decimal;
        ReportingType: Option ,Income,Expense;
        DateRangeRequiredErr: Label 'If you set Dimension Filter you must also set From Date and To Date';

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        LoanVisionSetup.Get();
        LoanVisionSetup.TestField("Loan Type Dimension Code");
        PeriodEnd := PeriodEnd1;
        if (Dimension1Filter <> '') or (Dimension2Filter <> '') or (Dimension3Filter <> '') or (Dimension4Filter <> '') or
            (Dimension5Filter <> '') or (Dimension6Filter <> '') or (Dimension7Filter <> '') or (Dimension8Filter <> '') then
            if (PeriodEnd = 0D) or (PeriodStart = 0D) then
                Error(DateRangeRequiredErr);
        if PeriodEnd = 0D then
            PeriodEnd := WorkDate();
        EntryNo := 1;
        GLAccount.Reset();
        GLAccount.SetFilter(lvngReportingAccountName, '<>%1', '');
        if ReportingType = ReportingType::Income then
            GLAccount.SetRange("Account Category", GLAccount."Account Category"::Income);
        if ReportingType = ReportingType::Expense then
            GLAccount.SetRange("Account Category", GLAccount."Account Category"::Expense);
        GLEntriesByDimension.SetRange(PostingDateFilter, PeriodStart, PeriodEnd);
        if (Dimension1Filter <> '') then
            GLEntriesByDimension.SetRange(Dimension1Filter, Dimension1Filter);
        if (Dimension2Filter <> '') then
            GLEntriesByDimension.SetRange(Dimension2Filter, Dimension2Filter);
        if (Dimension3Filter <> '') then
            GLEntriesByDimension.SetRange(Dimension3Filter, Dimension3Filter);
        if (Dimension4Filter <> '') then
            GLEntriesByDimension.SetRange(Dimension4Filter, Dimension4Filter);
        if (Dimension5Filter <> '') then
            GLEntriesByDimension.SetRange(Dimension5Filter, Dimension5Filter);
        if (Dimension6Filter <> '') then
            GLEntriesByDimension.SetRange(Dimension6Filter, Dimension6Filter);
        if (Dimension7Filter <> '') then
            GLEntriesByDimension.SetRange(Dimension7Filter, Dimension7Filter);
        if (Dimension8Filter <> '') then
            GLEntriesByDimension.SetRange(Dimension8Filter, Dimension8Filter);
        AsOfDate := Format(PeriodStart, 0, '<Month,2>/<Day,2>/<Year4>') + '..' + Format(PeriodEnd, 0, '<Month,2>/<Day,2>/<Year4>');
        GLAccount.FindSet();
        repeat
            Buffer.Reset();
            Buffer.SetRange("Value as Text", GLAccount.lvngReportingAccountName);
            if Buffer.IsEmpty then begin
                Clear(Buffer);
                Buffer."Entry No." := EntryNo;
                EntryNo := EntryNo + 1;
                Buffer."Value as Text" := GLAccount.lvngReportingAccountName;
                Buffer.Bold := (GLAccount."Account Category" = GLAccount."Account Category"::Income);
                Buffer.Insert();
            end;
        until GLAccount.Next() = 0;
    end;
}