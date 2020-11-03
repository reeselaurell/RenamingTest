report 14135160 "lvnLoanProfitability"
{
    Caption = 'Loan Profitability';
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135160.rdl';

    dataset
    {
        dataitem(Loan; lvnLoan)
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
                column(Descripiton; TempDataBuffer."Raw Value") { }

                trigger OnPreDataItem()
                begin
                    TempDataBuffer.Reset();
                    SetRange(Number, 1, TempDataBuffer.Count);
                end;

                trigger OnAfterGetRecord()
                var
                    GLAccount: Record "G/L Account";
                begin
                    if Number = 1 then
                        TempDataBuffer.FindSet()
                    else
                        TempDataBuffer.Next();
                    CalculatedValue := 0;
                    GLAccount.Reset();
                    GLAccount.SetRange(lvnReportingAccountName, TempDataBuffer."Raw Value");
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
                    ReportingAccountType := TempDataBuffer."Numeric Value";
                    if CalculatedValue = 0 then
                        CurrReport.Skip();
                end;
            }

            trigger OnAfterGetRecord()
            var
                DefaultDimension: Record "Default Dimension";
                Customer: Record Customer;
                DimensionValue: Record "Dimension Value";
            begin
                LoanType := '';
                LoanOfficerName := '';
                if DefaultDimension.Get(Database::lvnLoan, "No.", LoanVisionSetup."Loan Type Dimension Code") then
                    LoanType := DefaultDimension."Dimension Value Code";
                if DefaultDimension.Get(Database::lvnLoan, "No.", LoanVisionSetup."Loan Officer Dimension Code") then
                    if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", DefaultDimension."Dimension Value Code") then begin
                        LoanOfficerName := DimensionValue.Name;
                        if LoanOfficerName = '' then
                            LoanOfficerName := DimensionValue.Code;
                    end;
                InvestorName := '';
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
                        field(ToDate; PeriodEnd) { ApplicationArea = All; Caption = 'To Date'; }
                    }

                    field(ReportingType; ReportingType) { ApplicationArea = All; Caption = 'Reporting Type'; }

                    group(Dimensions)
                    {
                        Caption = 'G/L Entries Dimension Filters';

                        field(Dimension1Filter; DimensionFilters[1]) { ApplicationArea = All; Visible = Dimension1FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); CaptionClass = '1,1,1'; }
                        field(Dimension2Filter; DimensionFilters[2]) { ApplicationArea = All; Visible = Dimension2FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); CaptionClass = '1,1,2'; }
                        field(Dimension3Filter; DimensionFilters[3]) { ApplicationArea = All; Visible = Dimension3FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); CaptionClass = '1,2,3'; }
                        field(Dimension4Filter; DimensionFilters[4]) { ApplicationArea = All; Visible = Dimension4FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); CaptionClass = '1,2,4'; }
                        field(Dimension5Filter; DimensionFilters[5]) { ApplicationArea = All; Visible = Dimension5FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); CaptionClass = '1,2,5'; }
                        field(Dimension6Filter; DimensionFilters[6]) { ApplicationArea = All; Visible = Dimension6FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); CaptionClass = '1,2,6'; }
                        field(Dimension7Filter; DimensionFilters[7]) { ApplicationArea = All; Visible = Dimension7FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); CaptionClass = '1,2,7'; }
                        field(Dimension8Filter; DimensionFilters[8]) { ApplicationArea = All; Visible = Dimension8FilterVisible; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); CaptionClass = '1,2,8'; }
                    }
                }
            }
        }

        trigger OnOpenPage()
        var
            DimensionValue: Record "Dimension Value";
            GeneralLedgerSetup: Record "General Ledger Setup";
        begin
            GeneralLedgerSetup.Get();
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 1 Code");
            Dimension1FilterVisible := not DimensionValue.IsEmpty();
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 2 Code");
            Dimension2FilterVisible := not DimensionValue.IsEmpty();
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 3 Code");
            Dimension3FilterVisible := not DimensionValue.IsEmpty();
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 4 Code");
            Dimension4FilterVisible := not DimensionValue.IsEmpty();
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 5 Code");
            Dimension5FilterVisible := not DimensionValue.IsEmpty();
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 6 Code");
            Dimension6FilterVisible := not DimensionValue.IsEmpty();
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 7 Code");
            Dimension7FilterVisible := not DimensionValue.IsEmpty();
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 8 Code");
            Dimension8FilterVisible := not DimensionValue.IsEmpty();
        end;
    }

    var
        DateRangeRequiredErr: Label 'If you set Dimension Filter you must also set From Date and To Date';
        CompanyInformation: Record "Company Information";
        LoanVisionSetup: Record lvnLoanVisionSetup;
        TempDataBuffer: Record lvnLoanLevelValueBuffer temporary;
        GLEntriesByDimension: Query lvnGLEntriesByDimension;
        PeriodEnd: Date;
        PeriodStart: Date;
        AsOfDate: Text[250];
        LoanType: Text;
        LoanOfficerName: Text;
        InvestorName: Text;
        ReportingAccountType: Integer;
        CalculatedValue: Decimal;
        DimensionFilters: array[8] of Code[20];
        ReportingType: Enum lvnLoanProfitReportingType;
        [InDataSet]
        Dimension1FilterVisible: Boolean;
        [InDataSet]
        Dimension2FilterVisible: Boolean;
        [InDataSet]
        Dimension3FilterVisible: Boolean;
        [InDataSet]
        Dimension4FilterVisible: Boolean;
        [InDataSet]
        Dimension5FilterVisible: Boolean;
        [InDataSet]
        Dimension6FilterVisible: Boolean;
        [InDataSet]
        Dimension7FilterVisible: Boolean;
        [InDataSet]
        Dimension8FilterVisible: Boolean;

    trigger OnPreReport()
    var
        GLAccount: Record "G/L Account";
        EntryNo: Integer;
        RowNo: Integer;
    begin
        CompanyInformation.Get();
        LoanVisionSetup.Get();
        LoanVisionSetup.TestField("Loan Type Dimension Code");
        if (DimensionFilters[1] <> '') or (DimensionFilters[2] <> '') or (DimensionFilters[3] <> '') or (DimensionFilters[4] <> '') or (DimensionFilters[5] <> '') or (DimensionFilters[6] <> '') or (DimensionFilters[7] <> '') or (DimensionFilters[8] <> '') then
            if (PeriodEnd = 0D) or (PeriodStart = 0D) then
                Error(DateRangeRequiredErr);
        if PeriodEnd = 0D then
            PeriodEnd := WorkDate();
        EntryNo := 1;
        GLAccount.Reset();
        GLAccount.SetFilter(lvnReportingAccountName, '<>%1', '');
        if ReportingType = ReportingType::Income then
            GLAccount.SetRange("Account Category", GLAccount."Account Category"::Income);
        if ReportingType = ReportingType::Expense then
            GLAccount.SetRange("Account Category", GLAccount."Account Category"::Expense);
        GLEntriesByDimension.SetRange(PostingDateFilter, PeriodStart, PeriodEnd);
        if (DimensionFilters[1] <> '') then
            GLEntriesByDimension.SetRange(Dimension1Filter, DimensionFilters[1]);
        if (DimensionFilters[2] <> '') then
            GLEntriesByDimension.SetRange(Dimension2Filter, DimensionFilters[2]);
        if (DimensionFilters[3] <> '') then
            GLEntriesByDimension.SetRange(Dimension3Filter, DimensionFilters[3]);
        if (DimensionFilters[4] <> '') then
            GLEntriesByDimension.SetRange(Dimension4Filter, DimensionFilters[4]);
        if (DimensionFilters[5] <> '') then
            GLEntriesByDimension.SetRange(Dimension5Filter, DimensionFilters[5]);
        if (DimensionFilters[6] <> '') then
            GLEntriesByDimension.SetRange(Dimension6Filter, DimensionFilters[6]);
        if (DimensionFilters[7] <> '') then
            GLEntriesByDimension.SetRange(Dimension7Filter, DimensionFilters[7]);
        if (DimensionFilters[8] <> '') then
            GLEntriesByDimension.SetRange(Dimension8Filter, DimensionFilters[8]);
        AsOfDate := Format(PeriodStart, 0, '<Month,2>/<Day,2>/<Year4>') + '..' + Format(PeriodEnd, 0, '<Month,2>/<Day,2>/<Year4>');
        if GLAccount.FindSet() then
            repeat
                TempDataBuffer.Reset();
                TempDataBuffer.SetRange("Raw Value", GLAccount.lvnReportingAccountName);
                if TempDataBuffer.IsEmpty then begin
                    Clear(TempDataBuffer);
                    TempDataBuffer."Raw Value" := GLAccount.lvnReportingAccountName;
                    if GLAccount."Account Category" = GLAccount."Account Category"::Income then
                        TempDataBuffer."Numeric Value" := 1
                    else
                        TempDataBuffer."Numeric Value" := 2;
                    RowNo += 1;
                    TempDataBuffer."Row No." := RowNo;
                    TempDataBuffer.Insert();
                end;
            until GLAccount.Next() = 0;
    end;
}