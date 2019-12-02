report 14135182 lvngGLDetails
{
    Caption = 'G/L Details';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135182.rdl';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type" = const(Posting));
            RequestFilterFields = "No.", "Income/Balance";

            column(AccountNo; "G/L Account"."No.") { }
            column(AccountName; "G/L Account".Name) { }
            column(BegBalance; BegBalance) { }
            column(EndBalance; EndBalance) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(Filters; ForHeaderLbl + GetFilter("Date Filter")) { }
            column(ReportName; ReportSubName) { }

            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemTableView = sorting("G/L Account No.", "Posting Date");
                DataItemLink = "G/L Account No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Business Unit Code" = field("Business Unit Filter");

                column(EntryNo; EntryNo) { }
                column(Description; GLDescription) { }
                column(ExternalDocumentNo; "G/L Entry"."External Document No.") { }
                column(DocumentNo; DocumentNo) { }
                column(PostingDate; PostingDate) { }
                column(DebitAmount; "G/L Entry"."Debit Amount") { }
                column(CreditAmount; "G/L Entry"."Credit Amount") { }
                column(LoanNo; "G/L Entry"."Loan No.") { }
                column(BorrowerName; BorrowerName) { }
                column(DateFunded; DateFunded) { }
                column(DateSold; DateSold) { }
                column(GlobalDimension1Code; "Global Dimension 1 Code") { }
                column(GlobalDimension2Code; "Global Dimension 2 Code") { }
                column(Dim1Caption; Loan.FieldCaption("Global Dimension 1 Code")) { }
                column(Dim2Caption; Loan.FieldCaption("Global Dimension 2 Code")) { }

                trigger OnAfterGetRecord()
                var
                    LoanFound: Boolean;
                begin
                    BorrowerName := '';
                    DateFunded := 0D;
                    DateSold := 0D;
                    Loan.SecurityFiltering(SecurityFiltering::Ignored);
                    LoanFound := false;
                    if Loan.Get("Loan No.") then begin
                        BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name";
                        DateFunded := Loan."Date Funded";
                        DateSold := Loan."Date Sold";
                        LoanFound := true;
                    end;
                    EntryNo := 0;
                    PostingDate := "Posting Date";
                    DocumentNo := "Document No.";
                    EntryNo := "Entry No.";
                    GLDescription := Description;
                    if ExcelExport then begin
                        NewRow();
                        ExportTextColumn(ColumnNo, "G/L Account No.", false);
                        ColumnNo := ColumnNo + 1;
                        ExportTextColumn(ColumnNo, GLAccount.Name, false);
                        ColumnNo := ColumnNo + 1;
                        ExportTextColumn(ColumnNo, GLDescription, false);
                        ColumnNo := ColumnNo + 1;
                        ExportTextColumn(ColumnNo, "External Document No.", false);
                        ColumnNo := ColumnNo + 1;
                        ExportTextColumn(ColumnNo, DocumentNo, false);
                        ColumnNo := ColumnNo + 1;
                        ExportDateColumn(ColumnNo, "Posting Date");
                        ColumnNo := ColumnNo + 1;
                        ExportTextColumn(ColumnNo, "Loan No.", false);
                        ColumnNo := ColumnNo + 1;
                        if LoanFound then begin
                            ExportTextColumn(ColumnNo, Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name", false);
                            ColumnNo := ColumnNo + 1;
                            ExportDateColumn(ColumnNo, Loan."Date Funded");
                            ColumnNo := ColumnNo + 1;
                            ExportDateColumn(ColumnNo, Loan."Date Sold");
                        end else
                            ColumnNo := ColumnNo + 2;
                        ColumnNo := ColumnNo + 1;
                        ExportTextColumn(ColumnNo, "Global Dimension 1 Code", false);
                        ColumnNo := ColumnNo + 1;
                        ExportTextColumn(ColumnNo, "Global Dimension 2 Code", false);
                        ColumnNo := ColumnNo + 1;
                        ExportDecimalColumn(ColumnNo, "Debit Amount");
                        ColumnNo := ColumnNo + 1;
                        ExportDecimalColumn(ColumnNo, "Credit Amount");
                    end;
                end;
            }

            trigger OnPreDataItem()
            var
                BusinessUnit: Record "Business Unit";
                DimensionValue: Record "Dimension Value";
            begin
                case ReportingType of
                    ReportingType::"Business Unit":
                        begin
                            SetFilter("Business Unit Filter", Filtercode);
                            if BusinessUnit.Get(Filtercode) then
                                ReportSubName := StrSubstNo(RangeTxt, BusinessUnit.Code, BusinessUnit.Name);
                        end;
                    ReportingType::"Dimension 2":
                        begin
                            SetFilter("Global Dimension 2 Filter", Filtercode);
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Global Dimension No.", 2);
                            DimensionValue.SetRange(Code, Filtercode);
                            if DimensionValue.FindFirst() then
                                ReportSubName := StrSubstNo(RangeTxt, DimensionValue.Code, DimensionValue.Name);
                        end;
                    ReportingType::"Dimension 1":
                        begin
                            SetFilter("Global Dimension 1 Filter", Filtercode);
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Global Dimension No.", 1);
                            DimensionValue.SetRange(Code, Filtercode);
                            if DimensionValue.FindFirst() then
                                ReportSubName := StrSubstNo(RangeTxt, DimensionValue.Code, DimensionValue.Name);
                        end;
                    ReportingType::"Dimension 3":
                        begin
                            SetFilter("Shortcut Dimension 3 Filter", Filtercode);
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Global Dimension No.", 3);
                            DimensionValue.SetRange(Code, Filtercode);
                            if DimensionValue.FindFirst() then
                                ReportSubName := StrSubstNo(RangeTxt, DimensionValue.Code, DimensionValue.Name);
                        end;
                    ReportingType::"Dimension 4":
                        begin
                            SetFilter("Shortcut Dimension 4 Filter", Filtercode);
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Global Dimension No.", 4);
                            DimensionValue.SetRange(Code, Filtercode);
                            if DimensionValue.FindFirst() then
                                ReportSubName := StrSubstNo(RangeTxt, DimensionValue.Code, DimensionValue.Name);
                        end;
                end;

                SetFilter("Date Filter", DateFilter);
                BegDate := "G/L Account".GetRangeMin("Date Filter");
                EndDate := "G/L Account".GetRangeMax("Date Filter");
            end;

            trigger OnAfterGetRecord()
            begin
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
                    Caption = 'Filters';

                    field(BasedOnDimension; BasedOnDimension)
                    {
                        Caption = 'Type';

                        trigger OnValidate()
                        begin
                            if GLSetup."Global Dimension 1 Code" = BasedOnDimension then
                                ReportingType := ReportingType::"Dimension 1";
                            if GLSetup."Global Dimension 2 Code" = BasedOnDimension then
                                ReportingType := ReportingType::"Dimension 2";
                            if GLSetup."Shortcut Dimension 3 Code" = BasedOnDimension then
                                ReportingType := ReportingType::"Dimension 3";
                            if GLSetup."Shortcut Dimension 4 Code" = BasedOnDimension then
                                ReportingType := ReportingType::"Dimension 4";
                            if BasedOnDimension = 'BUSINESS UNIT' then
                                ReportingType := ReportingType::"Business Unit";
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, TempDimensionLookup) = Action::LookupOK then begin
                                BasedOnDimension := TempDimensionLookup.Code;
                                if GLSetup."Global Dimension 1 Code" = BasedOnDimension then
                                    ReportingType := ReportingType::"Dimension 1";
                                if GLSetup."Global Dimension 2 Code" = BasedOnDimension then
                                    ReportingType := ReportingType::"Dimension 2";
                                if GLSetup."Shortcut Dimension 3 Code" = BasedOnDimension then
                                    ReportingType := ReportingType::"Dimension 3";
                                if GLSetup."Shortcut Dimension 4 Code" = BasedOnDimension then
                                    ReportingType := ReportingType::"Dimension 4";
                                if BasedOnDimension = BusinessUnitCodeTxt then
                                    ReportingType := ReportingType::"Business Unit";
                            end;
                        end;
                    }

                    field(Filtercode; Filtercode)
                    {
                        Caption = 'Filter';
                        Lookup = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            BULookup: Record "Business Unit";
                            DimensionValue: Record "Dimension Value";
                        begin
                            case ReportingType of
                                ReportingType::"Business Unit":
                                    begin
                                        if Page.RunModal(0, BULookup) = Action::LookupOK then
                                            Filtercode := BULookup.Code;
                                    end;
                                ReportingType::"Dimension 1":
                                    begin
                                        DimensionValue.Reset();
                                        DimensionValue.SetRange("Global Dimension No.", 1);
                                        if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                            Filtercode := DimensionValue.Code;
                                    end;
                                ReportingType::"Dimension 2":
                                    begin
                                        DimensionValue.Reset();
                                        DimensionValue.SetRange("Global Dimension No.", 2);
                                        if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                            Filtercode := DimensionValue.Code;
                                    end;
                                ReportingType::"Dimension 3":
                                    begin
                                        DimensionValue.Reset();
                                        DimensionValue.SetRange("Global Dimension No.", 3);
                                        if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                            Filtercode := DimensionValue.Code;
                                    end;
                                ReportingType::"Dimension 4":
                                    begin
                                        DimensionValue.Reset();
                                        DimensionValue.SetRange("Global Dimension No.", 4);
                                        if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                                            Filtercode := DimensionValue.Code;
                                    end;
                            end;
                        end;
                    }
                    field(DateFilter; DateFilter) { Caption = 'Date Filter'; ApplicationArea = All; }
                    field(ExcelExport; ExcelExport) { Caption = 'Excel Export'; ApplicationArea = All; }
                }
            }
        }

        trigger OnOpenPage()
        var
            Dimension: Record Dimension;
        begin
            GLSetup.Get();
            TempDimensionLookup.Reset();
            TempDimensionLookup.DeleteAll();
            if Dimension.Get(GLSetup."Global Dimension 1 Code") then begin
                Clear(TempDimensionLookup);
                TempDimensionLookup := Dimension;
                TempDimensionLookup.Insert();
                if ReportingType = ReportingType::"Dimension 1" then
                    BasedOnDimension := GLSetup."Global Dimension 1 Code";
            end;
            if Dimension.Get(GLSetup."Global Dimension 2 Code") then begin
                Clear(TempDimensionLookup);
                TempDimensionLookup := Dimension;
                TempDimensionLookup.Insert();
                if ReportingType = ReportingType::"Dimension 2" then
                    BasedOnDimension := GLSetup."Global Dimension 2 Code";
            end;
            if Dimension.Get(GLSetup."Shortcut Dimension 3 Code") then begin
                Clear(TempDimensionLookup);
                TempDimensionLookup := Dimension;
                TempDimensionLookup.Insert();
                if ReportingType = ReportingType::"Dimension 3" then
                    BasedOnDimension := GLSetup."Shortcut Dimension 3 Code";
            end;
            if Dimension.Get(GLSetup."Shortcut Dimension 4 Code") then begin
                Clear(TempDimensionLookup);
                TempDimensionLookup := Dimension;
                TempDimensionLookup.Insert();
                if ReportingType = ReportingType::"Dimension 4" then
                    BasedOnDimension := GLSetup."Shortcut Dimension 4 Code";
            end;
            Clear(TempDimensionLookup);
            TempDimensionLookup.Code := BusinessUnitCodeTxt;
            TempDimensionLookup.Name := BusinessUnitNameTxt;
            TempDimensionLookup.Insert();
            if ReportingType = ReportingType::"Business Unit" then
                BasedOnDimension := BusinessUnitCodeTxt;
        end;
    }

    var
        RangeTxt: Label 'For %1 - %2';
        ForHeaderLbl: Label 'For: ';
        BusinessUnitCodeTxt: Label 'BUSINESS UNIT';
        BusinessUnitNameTxt: Label 'Business Unit';
        CompanyInformation: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        GLAccount: Record "G/L Account";
        Loan: Record lvngLoan;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempDimensionLookup: Record Dimension temporary;
        BegBalance: Decimal;
        EndBalance: Decimal;
        DateFilter: Text;
        BorrowerName: Text;
        BegDate: Date;
        EndDate: Date;
        EntryNo: Integer;
        GLDescription: Text;
        PostingDate: Date;
        DocumentNo: Code[20];
        ReportSubName: Text;
        ReportingType: Option "Business Unit","Dimension 1","Dimension 2","Dimension 3","Dimension 4";
        Filtercode: Code[20];
        DateSold: Date;
        DateFunded: Date;
        RowNo: Integer;
        ColumnNo: Integer;
        ExcelExport: Boolean;
        BasedOnDimension: Code[20];

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        if ExcelExport then begin
            RowNo := 1;
            ColumnNo := 1;
            ExportTextColumn(ColumnNo, 'G/L Account No.', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'G/L Account Name', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Description', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'External Document No.', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Document No.', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Posting Date', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Loan No.', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Borrower Name', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Date Funded', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Date Sold', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Trans. ' + Loan.FieldCaption("Global Dimension 1 Code"), true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Trans. ' + Loan.FieldCaption("Global Dimension 2 Code"), true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Debit Amount', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Credit Amount', true);
        end;
    end;

    trigger OnPostReport()
    begin
        if ExcelExport then begin
            TempExcelBuffer.CreateNewBook('Export');
            TempExcelBuffer.WriteSheet('', CompanyName, '');
            TempExcelBuffer.CloseBook();
            TempExcelBuffer.OpenExcel();
        end;
    end;

    local procedure NewRow()
    begin
        ColumnNo := 1;
        RowNo := RowNo + 1;
    end;

    local procedure ExportTextColumn(ColumnNo: Integer; Value: Text; Bold: Boolean)
    begin
        Clear(TempExcelBuffer);
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer.Validate("Cell Value as Text", Value);
        TempExcelBuffer.Validate("Cell Type", TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.Validate(Bold, Bold);
        TempExcelBuffer.Insert(true);
    end;

    local procedure ExportDateColumn(ColumnNo: Integer; Value: Date)
    begin
        Clear(TempExcelBuffer);
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer.Validate("Cell Value as Text", Format(Value));
        TempExcelBuffer.Validate("Cell Type", TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.Insert(true);
    end;

    local procedure ExportDecimalColumn(ColumnNo: Integer; Value: Decimal)
    begin
        Clear(TempExcelBuffer);
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer.Validate("Cell Value as Text", Format(Value));
        TempExcelBuffer.Validate("Cell Type", TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.NumberFormat := '0.00';
        TempExcelBuffer.Insert(true);
    end;

    local procedure ExportIntColumn(ColumnNo: Integer; Value: Integer)
    begin
        Clear(TempExcelBuffer);
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer.Validate("Cell Value as Text", Format(Value));
        TempExcelBuffer.Validate("Cell Type", TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.NumberFormat := '0';
        TempExcelBuffer.Insert(true);
    end;

    procedure SetParams(_DateFilter: Text; _ReportingType: Option "Business Unit","Dimension 1","Dimension 2","Dimension 3","Dimension 4"; _Filter: Code[20])
    begin
        DateFilter := _DateFilter;
        ReportingType := _ReportingType;
        Filtercode := _Filter;
    end;
}