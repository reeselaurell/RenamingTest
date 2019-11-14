report 14135153 "lvngLoanProfitability"
{
    Caption = 'Loan Profitability';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135153.rdl';
    dataset
    {
        dataitem(lvngLoan; lvngLoan)
        {
            RequestFilterFields = "Loan No.";
            DataItemTableView = sorting("Loan No.");
            column(lvngLoanNo; "Loan No.")
            {

            }
            column(lvngBorrowerFirstName; "Borrower First Name")
            {

            }
            column(lvngBorrowerMiddleName; "Borrower Middle Name")
            {

            }
            column(lvngBorrowerLastName; "Borrower Last Name")
            {

            }
            column(lvngDateFunded; "Date Funded")
            {

            }
            column(lvngWarehouseLineCode; "Warehouse Line Code")
            {

            }
            column(LoanType; LoanType)
            {

            }
            column(lvngInterestRate; "Interest Rate")
            {

            }
            column(lvngDateSold; "Date Sold")
            {

            }
            column(InvestorName; InvestorName)
            {

            }
            column(lvngLoanAmount; "Loan Amount")
            {

            }
            column(LoanOfficerName; LoanOfficerName)
            {

            }
            column(CompanyName; CompanyInformation.Name)
            {

            }
            column(AsOfDate; AsOfDate)
            {

            }
            dataitem(DataSetValues; Integer)
            {
                DataItemTableView = sorting(Number);
                column(BalanceAtDate; CalculatedValue)
                {

                }
                column(ReportingAccountType; ReportingAccountType)
                {

                }
                column(Descripiton; Buffer."Cell Value as Text")
                {

                }

                trigger OnPreDataItem()
                begin
                    Buffer.Reset();
                    SetRange(Number, 1, Buffer.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        Buffer.Find('-')
                    else
                        Buffer.Next();
                    Clear(CalculatedValue);
                    GLAccount.Reset();
                    GLAccount.SetRange(lvngReportingAccountName, Buffer."Cell Value as Text");
                    GLAccount.FindSet();
                    repeat
                        if GLAccount.Totaling <> '' then
                            GLEntriesByDimension.SetFilter(GLAccountNoFilter, GLAccount.Totaling)
                        else
                            GLEntriesByDimension.SetRange(GLAccountNoFilter, GLAccount."No.");
                        GLEntriesByDimension.Open();
                        if GLEntriesByDimension.Read() then begin
                            CalculatedValue := CalculatedValue + GLEntriesByDimension.SumAmount;
                        end;
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
                if DefaultDimension.Get(Database::lvngLoan, "Loan No.", LoanVisionSetup."Loan Type Dimension Code") then begin
                    LoanType := DefaultDimension."Dimension Value Code";
                end;
                if DefaultDimension.Get(Database::lvngLoan, "Loan No.", LoanVisionSetup."Loan Officer Dimension Code") then begin
                    if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", DefaultDimension."Dimension Value Code") then begin
                        LoanOfficerName := DimensionValue.Name;
                        if LoanOfficerName = '' then begin
                            LoanOfficerName := DimensionValue.Code;
                        end;
                    end;
                end;
                Clear(InvestorName);
                if Customer.Get("Investor Customer No.") then begin
                    InvestorName := Customer.Name;
                end;
                GLEntriesByDimension.SetRange(LoanNoFilter, lvngLoan."Loan No.");
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
                    field(FromDate; PeriodStart)
                    {
                        Caption = 'From Date';
                    }
                    field(ToDate; PeriodEnd1)
                    {
                        Caption = 'To Date';
                    }
                    field(ReportingType; ReportingType)
                    {
                        Caption = 'Reporting Type';
                        OptionCaption = ',Income,Expense';
                    }
                    group(Dimensions)
                    {
                        field(Dimension1Filter; Dimension1Filter)
                        {
                            Visible = Dimension1FilterVisible;
                            TableRelation = "Dimension Value".Code where("Global Dimension No." = Const(1));
                            CaptionClass = '1,1,1';
                        }
                        field(Dimension2Filter; Dimension2Filter)
                        {
                            Visible = Dimension2FilterVisible;
                            TableRelation = "Dimension Value".Code where("Global Dimension No." = Const(2));
                            CaptionClass = '1,1,2';
                        }
                        field(Dimension3Filter; Dimension3Filter)
                        {
                            Visible = Dimension3FilterVisible;
                            TableRelation = "Dimension Value".Code where("Global Dimension No." = Const(3));
                            CaptionClass = '1,2,3';
                        }
                        field(Dimension4Filter; Dimension4Filter)
                        {
                            Visible = Dimension4FilterVisible;
                            TableRelation = "Dimension Value".Code where("Global Dimension No." = Const(4));
                            CaptionClass = '1,2,4';
                        }
                        field(Dimension5Filter; Dimension5Filter)
                        {
                            Visible = Dimension5FilterVisible;
                            TableRelation = "Dimension Value".Code where("Global Dimension No." = Const(5));
                            CaptionClass = '1,2,5';
                        }
                        field(Dimension6Filter; Dimension6Filter)
                        {
                            Visible = Dimension6FilterVisible;
                            TableRelation = "Dimension Value".Code where("Global Dimension No." = Const(6));
                            CaptionClass = '1,2,6';
                        }
                        field(Dimension7Filter; Dimension7Filter)
                        {
                            Visible = Dimension7FilterVisible;
                            TableRelation = "Dimension Value".Code where("Global Dimension No." = Const(7));
                            CaptionClass = '1,2,7';
                        }
                        field(Dimension8Filter; Dimension8Filter)
                        {
                            Visible = Dimension8FilterVisible;
                            TableRelation = "Dimension Value".Code where("Global Dimension No." = Const(8));
                            CaptionClass = '1,2,8';
                        }
                    }
                }
            }
        }
        trigger OnInit()
        begin
            GeneralLedgerSetup.Get();
        end;

        trigger OnOpenPage()
        begin
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 1 Code");
            Dimension1FilterVisible := not DimensionValue.IsEmpty;
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 2 Code");
            Dimension2FilterVisible := not DimensionValue.IsEmpty;
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 3 Code");
            Dimension3FilterVisible := not DimensionValue.IsEmpty;
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 4 Code");
            Dimension4FilterVisible := not DimensionValue.IsEmpty;
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 5 Code");
            Dimension5FilterVisible := not DimensionValue.IsEmpty;
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 6 Code");
            Dimension6FilterVisible := not DimensionValue.IsEmpty;
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 7 Code");
            Dimension7FilterVisible := not DimensionValue.IsEmpty;
            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 8 Code");
            Dimension8FilterVisible := not DimensionValue.IsEmpty;
        end;
    }
    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        LoanVisionSetup.Get();
        LoanVisionSetup.TestField("Loan Type Dimension Code");
        PeriodEnd := PeriodEnd1;
        if (Dimension1Filter <> '') or
        (Dimension2Filter <> '') or
        (Dimension3Filter <> '') or
        (Dimension4Filter <> '') or
        (Dimension5Filter <> '') or
        (Dimension6Filter <> '') or
        (Dimension7Filter <> '') or
        (Dimension8Filter <> '') then begin
            if (PeriodEnd = 0D) or
                (PeriodStart = 0D) then begin
                Error(Text001);
            end;
        end;
        if PeriodEnd = 0D then begin
            PeriodEnd := WorkDate();
        end;
        EntryNo := 1;
        GLAccount.Reset();
        GLAccount.SetFilter(lvngReportingAccountName, '<>%1', '');
        if ReportingType = ReportingType::Income then begin

            GLAccount.SetRange("Account Category", GLAccount."Account Category"::Income);
        end;
        if ReportingType = ReportingType::Expense then begin
            GLAccount.SetRange("Account Category", GLAccount."Account Category"::Expense);
        end;
        GLEntriesByDimension.SetRange(PostingDateFilter, PeriodStart, PeriodEnd);
        if (Dimension1Filter <> '') then begin
            GLEntriesByDimension.SetRange(Dimension1Filter, Dimension1Filter);
        end;
        if (Dimension2Filter <> '') then begin
            GLEntriesByDimension.SetRange(Dimension2Filter, Dimension2Filter);
        end;
        if (Dimension3Filter <> '') then begin
            GLEntriesByDimension.SetRange(Dimension3Filter, Dimension3Filter);
        end;
        if (Dimension4Filter <> '') then begin
            GLEntriesByDimension.SetRange(Dimension4Filter, Dimension4Filter);
        end;
        if (Dimension5Filter <> '') then begin
            GLEntriesByDimension.SetRange(Dimension5Filter, Dimension5Filter);
        end;
        if (Dimension6Filter <> '') then begin
            GLEntriesByDimension.SetRange(Dimension6Filter, Dimension6Filter);
        end;
        if (Dimension7Filter <> '') then begin
            GLEntriesByDimension.SetRange(Dimension7Filter, Dimension7Filter);
        end;
        if (Dimension8Filter <> '') then begin
            GLEntriesByDimension.SetRange(Dimension8Filter, Dimension8Filter);
        end;
        AsOfDate := Format(PeriodStart, 0, '<Month,2>/<Day,2>/<Year4>') + '..' + Format(PeriodEnd, 0, '<Month,2>/<Day,2>/<Year4>');
        GLAccount.FindSet();
        repeat
            Buffer.Reset();
            Buffer.SetRange("Cell Value as Text", GLAccount.lvngReportingAccountName);
            if Buffer.IsEmpty then begin
                Clear(Buffer);
                Buffer."Row No." := EntryNo;
                EntryNo := EntryNo + 1;
                Buffer."Cell Value as Text" := GLAccount.lvngReportingAccountName;
                Buffer.Bold := (GLAccount."Account Category" = GLAccount."Account Category"::Income);
                Buffer.Insert();
            end;
        until GLAccount.Next() = 0;
    end;

    var
        CompanyInformation: Record "Company Information";
        GeneralLedgerSetup: Record "General Ledger Setup";
        DefaultDimension: Record "Default Dimension";
        LoanVisionSetup: Record lvngLoanVisionSetup;
        Buffer: Record "Excel Buffer" temporary;
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
        Text001: TextConst ENU = 'If you set Dimension Filter you must also set From Date and To Date';




}