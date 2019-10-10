report 14135182 lvngGLDetails
{
    Caption = 'G/L Details';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135182.rdl';

    dataset
    {
        dataitem(lvngGLAccount; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type" = const(Posting));
            RequestFilterFields = "No.", "Income/Balance";

            column(AccountNo; lvngGLAccount."No.")
            {

            }
            column(AccountName; lvngGLAccount.Name)
            {

            }
            column(BegBalance; BegBalance)
            {

            }
            column(EndBalance; EndBalance)
            {

            }
            column(CompanyName; CompanyInformation.Name)
            {

            }
            column(Filters; 'For: ' + GetFilter("Date Filter"))
            {

            }
            column(ReportName; ReportSubName)
            {

            }
            dataitem(lvngGLEntry; "G/L Entry")
            {
                DataItemTableView = sorting("G/L Account No.", "Posting Date");
                DataItemLink = "G/L Account No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Business Unit Code" = field("Business Unit Filter");

                column(EntryNo; EntryNo)
                {

                }
                column(Description; GLDescription)
                {

                }
                column(ExternalDocumentNo; lvngGLEntry."External Document No.")
                {

                }
                column(DocumentNo; DocumentNo)
                {

                }
                column(PostingDate; PostingDate)
                {

                }
                column(DebitAmount; lvngGLEntry."Debit Amount")
                {

                }
                column(CreditAmount; lvngGLEntry."Credit Amount")
                {

                }
                column(LoanNo; lvngGLEntry.lvngLoanNo)
                {

                }
                column(BorrowerName; BorrowerName)
                {

                }
                column(DateFunded; DateFunded)
                {

                }
                column(DateSold; DateSold)
                {

                }
                column(GlobalDimension1Code; "Global Dimension 1 Code")
                {

                }
                column(GlobalDimension2Code; "Global Dimension 2 Code")
                {

                }
                column(Dim1Caption; Loan.FieldCaption(lvngGlobalDimension1Code))
                {

                }
                column(Dim2Caption; Loan.FieldCaption(lvngGlobalDimension2Code))
                {

                }

                trigger OnAfterGetRecord()
                var
                    LoanFound: Boolean;
                begin
                    Clear(BorrowerName);
                    Clear(DateFunded);
                    Clear(DateSold);
                    Loan.SecurityFiltering(SecurityFiltering::Ignored);
                    Clear(LoanFound);
                    if Loan.Get(lvngLoanNo) then begin
                        BorrowerName := Loan.lvngBorrowerFirstName + ' ' + Loan.lvngBorrowerMiddleName + ' ' + Loan.lvngBorrowerLastName;
                        DateFunded := Loan.lvngDateFunded;
                        DateSold := Loan.lvngDateSold;
                        LoanFound := true;
                    end;

                    EntryNo := 0;
                    PostingDate := "Posting Date";
                    DocumentNo := "Document No.";
                    EntryNo := "Entry No.";
                    GLDescription := Description;

                    if ExcelExport then begin
                        NewRow;
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
                        ExportTextColumn(ColumnNo, lvngLoanNo, false);
                        ColumnNo := ColumnNo + 1;
                        if LoanFound then begin
                            ExportTextColumn(ColumnNo, Loan.lvngBorrowerFirstName + ' ' + Loan.lvngBorrowerMiddleName + ' ' + Loan.lvngBorrowerLastName, false);
                            ColumnNo := ColumnNo + 1;
                            ExportDateColumn(ColumnNo, Loan.lvngDateFunded);
                            ColumnNo := ColumnNo + 1;
                            ExportDateColumn(ColumnNo, Loan.lvngDateSold);
                        end else begin
                            ColumnNo := ColumnNo + 2;
                        end;
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
            begin
                case ReportingType of
                    ReportingType::"Business Unit":
                        begin
                            SetFilter("Business Unit Filter", Filtercode);
                            if BusinessUnit.Get(Filtercode) then begin
                                ReportSubName := StrSubstNo(Text001, BusinessUnit.Code, BusinessUnit.Name);
                            end;
                        end;
                    ReportingType::"Dimension 2":
                        begin
                            SetFilter("Global Dimension 2 Filter", Filtercode);
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Global Dimension No.", 2);
                            DimensionValue.SetRange(Code, Filtercode);
                            if DimensionValue.FindFirst() then begin
                                ReportSubName := StrSubstNo(Text001, DimensionValue.Code, DimensionValue.Name);
                            end;
                        end;
                    ReportingType::"Dimension 1":
                        begin
                            SetFilter("Global Dimension 1 Filter", Filtercode);
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Global Dimension No.", 1);
                            DimensionValue.SetRange(Code, Filtercode);
                            if DimensionValue.FindFirst() then begin
                                ReportSubName := StrSubstNo(Text001, DimensionValue.Code, DimensionValue.Name);
                            end;
                        end;
                    ReportingType::"Dimension 3":
                        begin
                            // SetFilter(lvngShortcutDimension3Filter, Filtercode);
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Global Dimension No.", 3);
                            DimensionValue.SetRange(Code, Filtercode);
                            if DimensionValue.FindFirst() then begin
                                ReportSubName := StrSubstNo(Text001, DimensionValue.Code, DimensionValue.Name);
                            end;
                        end;
                    ReportingType::"Dimension 4":
                        begin
                            // SetFilter(lvngShortcutDimension4Filter, Filtercode);
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Global Dimension No.", 4);
                            DimensionValue.SetRange(Code, Filtercode);
                            if DimensionValue.FindFirst() then begin
                                ReportSubName := StrSubstNo(Text001, DimensionValue.Code, DimensionValue.Name);
                            end;
                        end;
                end;

                SetFilter("Date Filter", DateFilter);
                BegDate := lvngGLAccount.GetRangeMin("Date Filter");
                EndDate := lvngGLAccount.GetRangeMax("Date Filter");
            end;

            trigger OnAfterGetRecord()
            begin
                GLAccount.Reset();
                GLAccount.CopyFilters(lvngGLAccount);
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
                            if GLSetup."Global Dimension 1 Code" = BasedOnDimension then begin
                                ReportingType := ReportingType::"Dimension 1";
                            end;
                            if GLSetup."Global Dimension 2 Code" = BasedOnDimension then begin
                                ReportingType := ReportingType::"Dimension 2";
                            end;
                            if GLSetup."Shortcut Dimension 3 Code" = BasedOnDimension then begin
                                ReportingType := ReportingType::"Dimension 3";
                            end;
                            if GLSetup."Shortcut Dimension 4 Code" = BasedOnDimension then begin
                                ReportingType := ReportingType::"Dimension 4";
                            end;
                            if BasedOnDimension = 'BUSINESS UNIT' then begin
                                ReportingType := ReportingType::"Business Unit";
                            end;
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, DimensionLookup) = Action::LookupOK then begin
                                BasedOnDimension := DimensionLookup.Code;
                                if GLSetup."Global Dimension 1 Code" = BasedOnDimension then begin
                                    ReportingType := ReportingType::"Dimension 1";
                                end;
                                if GLSetup."Global Dimension 2 Code" = BasedOnDimension then begin
                                    ReportingType := ReportingType::"Dimension 2";
                                end;
                                if GLSetup."Shortcut Dimension 3 Code" = BasedOnDimension then begin
                                    ReportingType := ReportingType::"Dimension 3";
                                end;
                                if GLSetup."Shortcut Dimension 4 Code" = BasedOnDimension then begin
                                    ReportingType := ReportingType::"Dimension 4";
                                end;
                                if BasedOnDimension = 'BUSINESS UNIT' then begin
                                    ReportingType := ReportingType::"Business Unit";
                                end;
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
                    field(DateFilter; DateFilter)
                    {
                        Caption = 'Date Filter';


                    }
                    field(ExcelExport; ExcelExport)
                    {
                        Caption = 'Excel Export';
                    }
                }
            }
        }


        trigger OnOpenPage()
        begin
            GLSetup.Get();
            DimensionLookup.Reset();
            DimensionLookup.DeleteAll();
            if Dimension.Get(GLSetup."Global Dimension 1 Code") then begin
                Clear(DimensionLookup);
                DimensionLookup := Dimension;
                DimensionLookup.Insert();
                if ReportingType = ReportingType::"Dimension 1" then begin
                    BasedOnDimension := GLSetup."Global Dimension 1 Code";
                end;
            end;
            if Dimension.Get(GLSetup."Global Dimension 2 Code") then begin
                Clear(DimensionLookup);
                DimensionLookup := Dimension;
                DimensionLookup.Insert();
                if ReportingType = ReportingType::"Dimension 2" then begin
                    BasedOnDimension := GLSetup."Global Dimension 2 Code";
                end;
            end;
            if Dimension.Get(GLSetup."Shortcut Dimension 3 Code") then begin
                Clear(DimensionLookup);
                DimensionLookup := Dimension;
                DimensionLookup.Insert();
                if ReportingType = ReportingType::"Dimension 3" then begin
                    BasedOnDimension := GLSetup."Shortcut Dimension 3 Code";
                end;
            end;
            if Dimension.Get(GLSetup."Shortcut Dimension 4 Code") then begin
                Clear(DimensionLookup);
                DimensionLookup := Dimension;
                DimensionLookup.Insert();
                if ReportingType = ReportingType::"Dimension 4" then begin
                    BasedOnDimension := GLSetup."Shortcut Dimension 4 Code";
                end;
            end;
            Clear(DimensionLookup);
            DimensionLookup.Code := 'BUSINESS UNIT';
            DimensionLookup.Name := 'Business Unit';
            DimensionLookup.Insert();
            if ReportingType = ReportingType::"Business Unit" then begin
                BasedOnDimension := 'BUSINESS UNIT';
            end;
        end;
    }

    var
        BegBalance: Decimal;
        EndBalance: Decimal;
        DateFilter: Text;
        GLAccount: Record "G/L Account";
        BorrowerName: Text;
        Loan: Record lvngLoan;
        BegDate: Date;
        EndDate: Date;
        EntryNo: Integer;
        GLDescription: Text;
        PostingDate: Date;
        DocumentNo: Code[20];
        CompanyInformation: Record "Company Information";
        ReportSubName: Text;
        ReportingType: Option "Business Unit","Dimension 1","Dimension 2","Dimension 3","Dimension 4";
        Filtercode: Code[20];
        BusinessUnit: Record "Business Unit";
        DimensionValue: Record "Dimension Value";
        DateSold: Date;
        DateFunded: Date;
        ExcelBuffer: Record "Excel Buffer" temporary;
        RowNo: Integer;
        ColumnNo: Integer;
        ExcelExport: Boolean;
        GLSetup: Record "General Ledger Setup";
        DimensionLookup: Record Dimension temporary;
        Dimension: Record Dimension;
        BasedOnDimension: Code[20];
        Text001: TextConst ENU = 'For %1 - %2';

    trigger OnPreReport()
    begin
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
            ExportTextColumn(ColumnNo, 'Trans. ' + Loan.FieldCaption(lvngGlobalDimension1Code), true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Trans. ' + Loan.FieldCaption(lvngGlobalDimension2Code), true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Debit Amount', true);
            ColumnNo := ColumnNo + 1;
            ExportTextColumn(ColumnNo, 'Credit Amount', true);
        end;
    end;

    trigger OnPostReport()
    begin
        if ExcelExport then begin
            ExcelBuffer.CreateNewBook('Export');
            ExcelBuffer.WriteSheet('', CompanyName, '');
            ExcelBuffer.CloseBook();
            ExcelBuffer.OpenExcel();
        end;
    end;

    local procedure NewRow()
    begin
        ColumnNo := 1;
        RowNo := RowNo + 1;
    end;

    local procedure ExportTextColumn(ColumnNo: Integer; Value: Text; Bold: Boolean)
    begin
        Clear(ExcelBuffer);
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer.Validate("Cell Value as Text", Value);
        ExcelBuffer.Validate("Cell Type", ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.Validate(Bold, Bold);
        ExcelBuffer.Insert(true);
    end;

    local procedure ExportDateColumn(ColumnNo: Integer; Value: Date)
    begin
        Clear(ExcelBuffer);
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer.Validate("Cell Value as Text", Format(Value));
        ExcelBuffer.Validate("Cell Type", ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.Insert(true);
    end;

    local procedure ExportDecimalColumn(ColumnNo: Integer; Value: Decimal)
    begin
        Clear(ExcelBuffer);
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer.Validate("Cell Value as Text", Format(Value));
        ExcelBuffer.Validate("Cell Type", ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NumberFormat := '0.00';
        ExcelBuffer.Insert(true);
    end;

    local procedure ExportIntColumn(ColumnNo: Integer; Value: Integer)
    begin
        Clear(ExcelBuffer);
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer.Validate("Cell Value as Text", Format(Value));
        ExcelBuffer.Validate("Cell Type", ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NumberFormat := '0';
        ExcelBuffer.Insert(true);
    end;

    procedure SetParams(_DateFilter: Text; _ReportingType: Option "Business Unit","Dimension 1","Dimension 2","Dimension 3","Dimension 4"; _Filter: Code[20])
    begin
        DateFilter := _DateFilter;
        ReportingType := _ReportingType;
        Filtercode := _Filter;
    end;
}