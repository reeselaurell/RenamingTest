report 14135400 lvngGeneralLedgerDetails
{
    UsageCategory = Documents;
    ApplicationArea = All;
    Caption = 'General Ledger Details';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135400.rdl';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type" = const(Posting));

            column(AccountNo; "No.") { }
            column(AccountName; Name) { }
            column(BegBalance; BegBalance) { }
            column(EndBalance; EndBalance) { }
            column(Grouping; lvngReportGrouping = lvngReportGrouping::Loan) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(Filters; 'For: ' + GetFilter("Date Filter")) { }
            column(ReportName; ReportSubName) { }
            column(CostCenterCode; CostCenterCode) { }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemTableView = sorting("G/L Account No.", "Posting Date");
                DataItemLink = "G/L Account No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Business Unit Code" = field("Business Unit Filter"), lvngShortcutDimension3Code = field(lvngShortcutDimension3Filter), lvngShortcutDimension4Code = field(lvngShortcutDimension4Filter);

                column(EntryNo; EntryNo) { }
                column(Description; GLDescription) { }
                column(ExternalDocumentNo; "External Document No.") { }
                column(DocumentNo; DocumentNo) { }
                column(PostingDate; PostingDate) { }
                column(DebitAmount; "Debit Amount") { }
                column(CreditAmount; "Credit Amount") { }
                column(LoanNo; lvngLoanNo) { }
                column(BorrowerName; BorrowerName) { }
                column(DateFunded; DateFunded) { }
                column(DateSold; DateSold) { }
                column(CostCenterCaption; CostCenterCaption) { }

                trigger OnAfterGetRecord()
                var
                    Loan: Record lvngLoan;
                begin
                    BorrowerName := '';
                    DateFunded := 0D;
                    DateSold := 0D;
                    CostCenterCode := '';
                    Loan.SecurityFiltering(SecurityFilter::Ignored);
                    if Loan.Get(lvngLoanNo) then begin
                        BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Last Name";
                        DateFunded := Loan."Date Funded";
                        DateSold := Loan."Date Sold";
                    end;
                    EntryNo := 0;
                    PostingDate := "Posting Date";
                    DocumentNo := "Document No.";
                    if "G/L Account".lvngReportGrouping = "G/L Account".lvngReportGrouping::" " then begin
                        EntryNo := "Entry No.";
                        GLDescription := Description;
                    end else begin
                        DocumentNo := lvngLoanNo;
                        if Loan."Date Funded" <> 0D then
                            PostingDate := Loan."Date Funded";
                        if BorrowerName <> '' then
                            GLDescription := BorrowerName
                        else
                            GLDescription := Description;
                    end;
                    case CostCenterDimNo of
                        1:
                            CostCenterCode := "Global Dimension 1 Code";
                        2:
                            CostCenterCode := "Global Dimension 2 Code";
                        3:
                            CostCenterCode := lvngShortcutDimension3Code;
                        4:
                            CostCenterCode := lvngShortcutDimension4Code;
                    end;
                    if ExportToExcel then begin
                        ExcelExport.NewRow("Entry No.");
                        ExcelExport.WriteString("G/L Account No.");
                        ExcelExport.WriteString("G/L Account".Name);
                        ExcelExport.WriteString(GLDescription);
                        ExcelExport.WriteString("External Document No.");
                        ExcelExport.WriteString(DocumentNo);
                        ExcelExport.WriteDate(PostingDate);
                        ExcelExport.WriteString(lvngLoanNo);
                        if BorrowerName = '' then
                            ExcelExport.SkipCells(1)
                        else
                            ExcelExport.WriteString(BorrowerName);
                        if DateFunded = 0D then
                            ExcelExport.SkipCells(1)
                        else
                            ExcelExport.WriteDate(DateFunded);
                        if DateSold = 0D then
                            ExcelExport.SkipCells(1)
                        else
                            ExcelExport.WriteDate(DateSold);
                        ExcelExport.WriteString(CostCenterCode);
                        ExcelExport.WriteNumber("Debit Amount");
                        ExcelExport.WriteNumber("Credit Amount");
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                case BasedOnDimension of
                    BusinessUnitCodeTxt:
                        begin
                            SetFilter("Business Unit Filter", FilterCode);
                            if BusinessUnit.Get(FilterCode) then
                                ReportSubName := StrSubstNo(ReportSubNameTxt, BusinessUnit.Code, BusinessUnit.Name);
                        end;
                    GLSetup."Global Dimension 1 Code":
                        begin
                            SetFilter("Global Dimension 1 Filter", FilterCode);
                            if DimensionValue.Get(BasedOnDimension, FilterCode) then
                                ReportSubName := StrSubstNo(ReportSubNameTxt, DimensionValue.Code, DimensionValue.Name);
                        end;
                    GLSetup."Global Dimension 2 Code":
                        begin
                            SetFilter("Global Dimension 2 Filter", FilterCode);
                            if DimensionValue.Get(BasedOnDimension, FilterCode) then
                                ReportSubName := StrSubstNo(ReportSubNameTxt, DimensionValue.Code, DimensionValue.Name);
                        end;
                    GLSetup."Shortcut Dimension 3 Code":
                        begin
                            SetFilter(lvngShortcutDimension3Filter, FilterCode);
                            if DimensionValue.Get(BasedOnDimension, FilterCode) then
                                ReportSubName := StrSubstNo(ReportSubNameTxt, DimensionValue.Code, DimensionValue.Name);
                        end;
                    GLSetup."Shortcut Dimension 4 Code":
                        begin
                            SetFilter(lvngShortcutDimension4Filter, FilterCode);
                            if DimensionValue.Get(BasedOnDimension, FilterCode) then
                                ReportSubName := StrSubstNo(ReportSubNameTxt, DimensionValue.Code, DimensionValue.Name);
                        end;
                end;
                SetFilter("Date Filter", DateFilter);
                BegDate := "G/L Account".GetRangeMin("Date Filter");
                EndDate := "G/L Account".GetRangeMax("Date Filter");
            end;

            trigger OnAfterGetRecord()
            var
                GLAccount: Record "G/L Account";
                GLEntry: Record "G/L Entry";
            begin
                if UseGLMapping then begin
                    BranchUserGLMapping.Reset();
                    BranchUserGLMapping.SetRange("User ID", UserId());
                    BranchUserGLMapping.SetRange("G/L Account No.", "No.");
                    if BranchUserGLMapping.IsEmpty() then
                        CurrReport.Skip();
                end else
                    if "Income/Balance" <> "Income/Balance"::"Income Statement" then
                        CurrReport.Skip();
                //From "Transaction Exists" Flow Field in DataItemTableView =>
                //TODO: Check if table filter is translated correctly
                //Exist("G/L Entry" WHERE (G/L Account No.=FIELD(No.),G/L Account No.=FIELD(FILTER(Totaling)),Business Unit Code=FIELD(Business Unit Filter),Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),Posting Date=FIELD(Date Filter),Loan No.=FIELD(Loan No. Filter),Shortcut Dimension 3 Code=FIELD(Shortcut Dimension 3 Filter),Shortcut Dimension 4 Code=FIELD(Shortcut Dimension 4 Filter)))
                GLEntry.Reset();
                GLEntry.SetRange("G/L Account No.", "No.");
                if Totaling <> '' then
                    GLEntry.SetFilter("G/L Account No.", Totaling);
                GLEntry.SetRange("Business Unit Code", "Business Unit Filter");
                GLEntry.SetRange("Global Dimension 1 Code", "Global Dimension 1 Filter");
                GLEntry.SetRange("Global Dimension 2 Code", "Global Dimension 2 Filter");
                GLEntry.SetRange("Posting Date", "Date Filter");
                //GLEntry.SetRange(lvngLoanNo, "G/L Account".lvngLoanNoFilter); -- Field does not exist in G/L Account table extension
                GLEntry.SetRange(lvngShortcutDimension3Code, lvngShortcutDimension3Filter);
                GLEntry.SetRange(lvngShortcutDimension4Code, lvngShortcutDimension4Filter);
                if GLEntry.IsEmpty then
                    CurrReport.Skip();
                GLAccount.Reset();
                GLAccount.CopyFilters("G/L Account");
                GLAccount.SetRange("Date Filter", 0D, BegDate - 1);
                GLAccount.Get("No.");
                GLAccount.CalcFields("Balance at Date");
                BegBalance := GLAccount."Balance at Date";
                GLAccount.SetRange("Date Filter", 0D, EndDate);
                GLAccount.CalcFields("Balance at Date");
                EndBalance := GLAccount."Balance at Date";
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(BasedOnDimension; BasedOnDimension)
                    {
                        ApplicationArea = All;
                        Caption = 'Type';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, DimensionBuffer) = Action::LookupOK then
                                if Text <> DimensionBuffer.Code then begin
                                    Text := DimensionBuffer.Code;
                                    FilterCode := '';
                                    exit(true);
                                end;
                            exit(false);
                        end;

                        trigger OnValidate()
                        begin
                            DimensionBuffer.Get(BasedOnDimension);
                        end;
                    }
                    field(FilterCode; FilterCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Filter';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if BasedOnDimension = BusinessUnitCodeTxt then begin
                                BusinessUnit.Reset();
                                if Page.RunModal(0, BusinessUnit) = Action::LookupOK then begin
                                    Text := BusinessUnit.Code;
                                    exit(true);
                                end
                            end else begin
                                DimensionValue.Reset();
                                DimensionValue.SetRange("Dimension Code", BasedOnDimension);
                                if Page.RunModal(0, DimensionValue) = Action::LookupOK then begin
                                    Text := DimensionValue.Code;
                                    exit(true);
                                end;
                            end;
                            exit(false);
                        end;
                    }
                    field(DateFilter; DateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Date Filter';

                        trigger OnValidate()
                        var
                            GLAccount: Record "G/L Account" temporary;
                            TextMgmt: Codeunit "Filter Tokens";
                            MinDate: Date;
                            MaxDate: Date;
                        begin
                            TextMgmt.MakeDateFilter(DateFilter);
                            if (SystemFilter."Block Data From Date" <> 0D) or (SystemFilter."Block Data To Date" <> 0D) then begin
                                GLAccount.SetFilter("Date Filter", DateFilter);
                                MinDate := GLAccount.GetRangeMin("Date Filter");
                                MaxDate := GLAccount.GetRangeMax("Date Filter");
                                if SystemFilter."Block Data To Date" <> 0D then begin
                                    if MinDate <= SystemFilter."Block Data To Date" then
                                        MinDate := SystemFilter."Block Data To Date" + 1;
                                    if MaxDate <= SystemFilter."Block Data To Date" then
                                        MaxDate := SystemFilter."Block Data To Date" + 1;
                                end;
                                if SystemFilter."Block Data From Date" <> 0D then begin
                                    if MinDate >= SystemFilter."Block Data From Date" then
                                        MinDate := SystemFilter."Block Data From Date" - 1;
                                    if MaxDate >= SystemFilter."Block Data From Date" then
                                        MaxDate := SystemFilter."Block Data From Date" - 1;
                                end;
                                GLAccount.SetRange("Date Filter", MinDate, MaxDate);
                                DateFilter := GLAccount.GetFilter("Date Filter");
                                RequestOptionsPage.Update();
                            end;
                        end;
                    }
                    field(ExcelExport; ExportToExcel) { ApplicationArea = All; Caption = 'Export To Excel'; }
                }
            }
        }

        trigger OnOpenPage()
        var
            Dimension: Record Dimension;
        begin
            DimensionBuffer.Reset();
            DimensionBuffer.DeleteAll();
            if Dimension.Get(GLSetup."Global Dimension 1 Code") then begin
                DimensionBuffer := Dimension;
                DimensionBuffer.Insert();
                if SystemFilter."Shortcut Dimension 1" <> '' then begin
                    BasedOnDimension := Dimension.Code;
                    FilterCode := SystemFilter."Shortcut Dimension 1";
                end;
                if LoanVisionSetup."Cost Center Dimension Code" = Dimension.Code then begin
                    CostCenterDimNo := 1;
                    CostCenterCaption := CaptionClassTranslate('1,1,1');
                end;
            end;
            if Dimension.Get(GLSetup."Global Dimension 2 Code") then begin
                DimensionBuffer := Dimension;
                DimensionBuffer.Insert();
                if SystemFilter."Shortcut Dimension 2" <> '' then begin
                    BasedOnDimension := Dimension.Code;
                    FilterCode := SystemFilter."Shortcut Dimension 2";
                end;
                if LoanVisionSetup."Cost Center Dimension Code" = Dimension.Code then begin
                    CostCenterDimNo := 2;
                    CostCenterCaption := CaptionClassTranslate('1,1,2');
                end;
            end;
            if Dimension.Get(GLSetup."Shortcut Dimension 3 Code") then begin
                DimensionBuffer := Dimension;
                DimensionBuffer.Insert();
                if SystemFilter."Shortcut Dimension 3" <> '' then begin
                    BasedOnDimension := Dimension.Code;
                    FilterCode := SystemFilter."Shortcut Dimension 3";
                end;
                if LoanVisionSetup."Cost Center Dimension Code" = Dimension.Code then begin
                    CostCenterDimNo := 3;
                    CostCenterCaption := CaptionClassTranslate('1,2,3');
                end;
            end;
            if Dimension.Get(GLSetup."Shortcut Dimension 4 Code") then begin
                DimensionBuffer := Dimension;
                DimensionBuffer.Insert();
                if SystemFilter."Shortcut Dimension 4" <> '' then begin
                    BasedOnDimension := Dimension.Code;
                    FilterCode := SystemFilter."Shortcut Dimension 4";
                end;
                if LoanVisionSetup."Cost Center Dimension Code" = Dimension.Code then begin
                    CostCenterDimNo := 4;
                    CostCenterCaption := CaptionClassTranslate('1,2,4');
                end;
            end;
            Clear(DimensionBuffer);
            DimensionBuffer.Code := BusinessUnitCodeTxt;
            DimensionBuffer.Name := BusinessUnitNameTxt;
            DimensionBuffer.Insert();
            if SystemFilter."Business Unit" <> '' then begin
                BasedOnDimension := DimensionBuffer.Code;
                FilterCode := SystemFilter."Business Unit";
            end;
            BranchUserGLMapping.Reset();
            BranchUserGLMapping.SetRange("User ID", UserId());
            UseGLMapping := not BranchUserGLMapping.IsEmpty();
        end;
    }

    var
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        CompanyInformation: Record "Company Information";
        LoanVisionSetup: Record lvngLoanVisionSetup;
        GLSetup: Record "General Ledger Setup";
        BusinessUnit: Record "Business Unit";
        DimensionValue: Record "Dimension Value";
        DimensionBuffer: Record Dimension temporary;
        BranchUserGLMapping: Record lvngBranchUserGLMapping;
        ExcelExport: Codeunit lvngExcelExport;
        BasedOnDimension: Code[20];
        FilterCode: Code[20];
        DateFilter: Text;
        ExportToExcel: Boolean;
        UseGLMapping: Boolean;
        ReportSubName: Text;
        BegDate: Date;
        EndDate: Date;
        BegBalance: Decimal;
        EndBalance: Decimal;
        BorrowerName: Text;
        DateFunded: Date;
        DateSold: Date;
        EntryNo: Integer;
        GLDescription: Text;
        DocumentNo: Code[20];
        PostingDate: Date;
        CostCenterDimNo: Integer;
        CostCenterCode: Code[20];
        CostCenterCaption: Text;
        BusinessUnitCodeTxt: Label 'BUSINESS UNIT';
        BusinessUnitNameTxt: Label 'Business Unit';
        ReportSubNameTxt: Label 'For %1 - %2';

    trigger OnInitReport()
    begin
        GLSetup.Get();
        LoanVisionSetup.Get();
    end;

    trigger OnPreReport()
    var
        ExportMode: Enum lvngGridExportMode;
        DefaultBoolean: Enum lvngDefaultBoolean;
    begin
        CompanyInformation.Get();
        if ExportToExcel then begin
            ExcelExport.Init('GeneralLedgerDetails', ExportMode::lvngXlsx);
            ExcelExport.NewRow(0);
            ExcelExport.StyleRow(DefaultBoolean::lvngTrue, DefaultBoolean::lvngDefault, DefaultBoolean::lvngDefault, 0, '', '', '');
            ExcelExport.WriteString('G/L Account No.');
            ExcelExport.WriteString('G/L Account Name');
            ExcelExport.WriteString('Description');
            ExcelExport.WriteString('External Document No.');
            ExcelExport.WriteString('Document No.');
            ExcelExport.WriteString('Posting Date');
            ExcelExport.WriteString('Loan No.');
            ExcelExport.WriteString('Borrower Name');
            ExcelExport.WriteString('Date Funded');
            ExcelExport.WriteString('Date Sold');
            ExcelExport.WriteString(CostCenterCaption);
            ExcelExport.WriteString('Debit Amount');
            ExcelExport.WriteString('Credit Amount');
        end;
    end;

    trigger OnPostReport()
    begin
        if ExportToExcel then begin
            ExcelExport.AutoFit(false, true);
            ExcelExport.Download('Export.xlsx');
        end;
    end;

    procedure SetParams(var Filter: Record lvngSystemCalculationFilter)
    begin
        SystemFilter := Filter;
        DateFilter := SystemFilter."Date Filter";
    end;
}