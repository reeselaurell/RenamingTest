page 14135225 "lvnLoanValuesView"
{
    PageType = Card;
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    Caption = 'Loan Values View';

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                field(SchemaName; LoanLevelReportSchema.Description)
                {
                    ApplicationArea = All;
                    Caption = 'View Name';
                    ShowCaption = false;
                    Editable = false;
                }
                field(Dim1Filter; TempSystemCalcFilter."Global Dimension 1")
                {
                    ApplicationArea = All;
                    Caption = 'Dimension 1 Filter';
                    Editable = false;
                    Visible = Dim1Visible;
                    CaptionClass = '1,3,1';
                }
                field(Dim2Filter; TempSystemCalcFilter."Global Dimension 2")
                {
                    ApplicationArea = All;
                    Caption = 'Dimension 2 Filter';
                    Editable = false;
                    Visible = Dim2Visible;
                    CaptionClass = '1,3,2';
                }
                field(Dim3Filter; TempSystemCalcFilter."Shortcut Dimension 3")
                {
                    ApplicationArea = All;
                    Caption = 'Dimension 3 Filter';
                    Editable = false;
                    Visible = Dim3Visible;
                    CaptionClass = '1,2,3';
                }
                field(Dim4Filter; TempSystemCalcFilter."Shortcut Dimension 4")
                {
                    ApplicationArea = All;
                    Caption = 'Dimension 4 Filter';
                    Editable = false;
                    Visible = Dim4Visible;
                    CaptionClass = '1,2,4';
                }
                field(BusinessUnitFilter; TempSystemCalcFilter."Business Unit")
                {
                    ApplicationArea = All;
                    Caption = 'Business Unit Filter';
                    Editable = false;
                    Visible = BusinessUnitVisible;
                }
                field(BasedOn; BasedOn)
                {
                    ApplicationArea = All;
                    Caption = 'Base Date';

                    trigger OnValidate()
                    begin
                        CalculateData();
                        InitializeDataGrid();
                    end;
                }
                field(DateFilter; TempSystemCalcFilter."Date Filter")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Date Filter';
                }
            }
            usercontrol(DataGrid; lvnDataGridControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    InitializeDataGrid();
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExcelExport)
            {
                ApplicationArea = All;
                Caption = 'Excel Export';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::Xlsx);
                end;
            }
            action(PdfExport)
            {
                ApplicationArea = All;
                Caption = 'Pdf Export';
                Image = ExportFile;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::Pdf);
                end;
            }
            action(HtmlExport)
            {
                ApplicationArea = All;
                Caption = 'Html Export';
                Image = Export;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::Html);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoanVisionSetup.Get();
        CacheGLFilterBlobs();
        CalculateData();
    end;

    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        LoanLevelReportSchema: Record lvnLoanLevelReportSchema;
        TempSystemCalcFilter: Record lvnSystemCalculationFilter temporary;
        TempRowBuffer: Record "Name/Value Buffer" temporary;
        TempLoanLevelValueBuffer: Record lvnLoanLevelValueBuffer temporary;
        GLFilterCache: Dictionary of [Integer, Text];
        TotalsData: Dictionary of [Integer, Decimal];
        BasedOn: Enum lvnLoanLevelReportBaseDate;
        GridExportMode: Enum lvnGridExportMode;
        DefaultBoolean: Enum lvnDefaultBoolean;
        CellHorizontalAlignment: Enum lvnCellHorizontalAlignment;
        CellVerticalAlignment: Enum lvnCellVerticalAlignment;
        Dim1Visible: Boolean;
        Dim2Visible: Boolean;
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;
        BusinessUnitVisible: Boolean;
        TotalsRowVisible: Boolean;
        LoanNoLbl: Label 'Loan No.';
        DateFundedLbl: Label 'Date Funded';
        DateSoldLbl: Label 'Date Sold';
        PostingDateLbl: Label 'Posting Date';
        LONameLbl: Label 'LO Name';
        YesTxt: Label 'Yes';
        NoTxt: Label 'No';
        TotalsTxt: Label 'Totals';
        NotAvailableTxt: Label 'N/A';
        LoanLevelExportFileNameTxt: Label 'Loan Level Report';
        BusinessUnitFilterTxt: Label 'Business Unit Filter';
        BaseDateTxt: Label 'Base Date';
        DateFilterTxt: Label 'Date Filter';
        IntranslatableRowFormulaErr: Label 'Row formula cannot be translated';

    procedure SetParams(
        SchemaCode: Code[20];
        BaseDate: Enum lvnLoanLevelReportBaseDate;
        var Filter: Record lvnSystemCalculationFilter;
        ShowTotals: Boolean)
    begin
        LoanLevelReportSchema.Get(SchemaCode);
        BasedOn := BaseDate;
        TempSystemCalcFilter := Filter;
        TotalsRowVisible := ShowTotals;
        BusinessUnitVisible := Filter."Business Unit" <> '';
        Dim1Visible := Filter."Global Dimension 1" <> '';
        Dim2Visible := Filter."Global Dimension 2" <> '';
        Dim3Visible := Filter."Shortcut Dimension 3" <> '';
        Dim4Visible := Filter."Shortcut Dimension 4" <> '';
    end;

    procedure GetExportFileName(Mode: Enum lvnGridExportMode): Text
    begin
        case Mode of
            Mode::Pdf:
                exit(LoanLevelExportFileNameTxt + '.pdf');
            Mode::Html:
                exit(LoanLevelExportFileNameTxt + '.html');
            else
                exit(LoanLevelExportFileNameTxt + '.xlsx');
        end;
    end;

    local procedure CacheGLFilterBlobs()
    var
        LoanLevelReportSchemaLine: Record lvnLoanLevelReportSchemaLine;
        IStream: InStream;
        GLFilter: Text;
    begin
        Clear(GLFilterCache);
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
        LoanLevelReportSchemaLine.SetRange(Type, LoanLevelReportSchemaLine.Type::"G/L Entry");
        if LoanLevelReportSchemaLine.FindSet() then
            repeat
                if LoanLevelReportSchemaLine."G/L Filter".HasValue then begin
                    LoanLevelReportSchemaLine.CalcFields("G/L Filter");
                    LoanLevelReportSchemaLine."G/L Filter".CreateInStream(IStream);
                    IStream.ReadText(GLFilter);
                    if GLFilter <> '' then
                        GLFilterCache.Add(LoanLevelReportSchemaLine."Column No.", GLFilter);
                end;
            until LoanLevelReportSchemaLine.Next() = 0;
    end;

    local procedure CalculateData()
    var
        Loan: Record lvnLoan;
        GLLoansPerPeriod: Query lvnGLEntryLoansPerPeriod;
        RowNo: Integer;
    begin
        TempRowBuffer.Reset();
        TempRowBuffer.DeleteAll();
        TempLoanLevelValueBuffer.Reset();
        TempLoanLevelValueBuffer.DeleteAll();
        Clear(TotalsData);
        RowNo := 1;
        if BasedOn = BasedOn::Posting then begin
            Clear(GLLoansPerPeriod);
            if TempSystemCalcFilter."Global Dimension 1" <> '' then
                GLLoansPerPeriod.SetFilter(Dim1Filter, TempSystemCalcFilter."Global Dimension 1");
            if TempSystemCalcFilter."Global Dimension 2" <> '' then
                GLLoansPerPeriod.SetFilter(Dim1Filter, TempSystemCalcFilter."Global Dimension 2");
            GLLoansPerPeriod.SetFilter(PostingDate, TempSystemCalcFilter."Date Filter");
            if TempSystemCalcFilter."Shortcut Dimension 3" <> '' then
                GLLoansPerPeriod.SetFilter(Dim1Filter, TempSystemCalcFilter."Shortcut Dimension 3");
            if TempSystemCalcFilter."Shortcut Dimension 4" <> '' then
                GLLoansPerPeriod.SetFilter(Dim1Filter, TempSystemCalcFilter."Shortcut Dimension 4");
            if TempSystemCalcFilter."Business Unit" <> '' then
                GLLoansPerPeriod.SetFilter(BUFilter, TempSystemCalcFilter."Business Unit");
            if GLLoansPerPeriod.Open() then
                while GLLoansPerPeriod.Read() do begin
                    Clear(TempRowBuffer);
                    TempRowBuffer.Id := RowNo;
                    RowNo += 1;
                    Loan.Get(GLLoansPerPeriod.LoanNo);
                    TempRowBuffer.Name := Loan."No.";
                    TempRowBuffer.Value := Format(GLLoansPerPeriod.PostingDate);
                    CalculateRowData(Loan);
                    if LoanLevelReportSchema."Skip Zero Balance Lines" then begin
                        TempLoanLevelValueBuffer.Reset();
                        TempLoanLevelValueBuffer.SetRange("Row No.", TempRowBuffer.Id);
                        TempLoanLevelValueBuffer.SetRange("Value Type", TempLoanLevelValueBuffer."Value Type"::Number);
                        TempLoanLevelValueBuffer.SetFilter("Numeric Value", '<>%1', 0);
                        if not TempLoanLevelValueBuffer.IsEmpty() then
                            TempRowBuffer.Insert();
                    end else
                        TempRowBuffer.Insert();
                end;
            GLLoansPerPeriod.Close();
        end else begin
            Loan.Reset();
            if TempSystemCalcFilter."Global Dimension 1" <> '' then
                Loan.SetFilter("Global Dimension 1 Code", TempSystemCalcFilter."Global Dimension 1");
            if TempSystemCalcFilter."Global Dimension 2" <> '' then
                Loan.SetFilter("Global Dimension 2 Code", TempSystemCalcFilter."Global Dimension 2");
            if TempSystemCalcFilter."Shortcut Dimension 3" <> '' then
                Loan.SetFilter("Shortcut Dimension 3 Code", TempSystemCalcFilter."Shortcut Dimension 3");
            if TempSystemCalcFilter."Shortcut Dimension 4" <> '' then
                Loan.SetFilter("Shortcut Dimension 4 Code", TempSystemCalcFilter."Shortcut Dimension 4");
            if TempSystemCalcFilter."Business Unit" <> '' then
                Loan.SetFilter("Business Unit Code", TempSystemCalcFilter."Business Unit");
            if BasedOn = BasedOn::Sold then
                Loan.SetFilter("Date Sold", TempSystemCalcFilter."Date Filter")
            else
                Loan.SetFilter("Date Funded", TempSystemCalcFilter."Date Filter");
            if Loan.FindSet() then
                repeat
                    Clear(TempRowBuffer);
                    TempRowBuffer.Id := RowNo;
                    RowNo += 1;
                    TempRowBuffer.Name := Loan."No.";
                    if BasedOn = BasedOn::Sold then
                        TempRowBuffer.Value := Format(Loan."Date Sold")
                    else
                        TempRowBuffer.Value := Format(loan."Date Funded");
                    CalculateRowData(Loan);
                    TempRowBuffer.Insert();
                until Loan.Next() = 0;
        end;
    end;

    local procedure CalculateRowData(var Loan: Record lvnLoan)
    var
        DefaultDimension: Record "Default Dimension";
        DimensionValue: Record "Dimension Value";
        GroupedLoanGLEntry: Record lvnGroupedLoanGLEntry;
        LoanLevelReportSchemaLine: Record lvnLoanLevelReportSchemaLine;
        TempGroupedLoanGLEntry: Record lvnGroupedLoanGLEntry temporary;
        RecordReference: RecordRef;
        CalculatedValue: Text;
        CurrentTotal: Decimal;
    begin
        if DefaultDimension.Get(Database::lvnLoan, Loan."No.", LoanVisionSetup."Loan Officer Dimension Code") then
            if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then
                TempRowBuffer."Value Long" := DimensionValue.Name;
        TempGroupedLoanGLEntry.Reset();
        TempGroupedLoanGLEntry.DeleteAll();
        GroupedLoanGLEntry.Reset();
        GroupedLoanGLEntry.SetRange("Loan No.", Loan."No.");
        if TempSystemCalcFilter."Global Dimension 1" <> '' then
            GroupedLoanGLEntry.SetFilter("Global Dimension 1 Code", TempSystemCalcFilter."Global Dimension 1");
        if TempSystemCalcFilter."Global Dimension 2" <> '' then
            GroupedLoanGLEntry.SetFilter("Global Dimension 2 Code", TempSystemCalcFilter."Global Dimension 2");
        if TempSystemCalcFilter."Shortcut Dimension 3" <> '' then
            GroupedLoanGLEntry.SetFilter("Shortcut Dimension 3 Code", TempSystemCalcFilter."Shortcut Dimension 3");
        if TempSystemCalcFilter."Shortcut Dimension 4" <> '' then
            GroupedLoanGLEntry.SetFilter("Shortcut Dimension 4 Code", TempSystemCalcFilter."Shortcut Dimension 4");
        if TempSystemCalcFilter."Business Unit" <> '' then
            GroupedLoanGLEntry.SetFilter("Business Unit Code", TempSystemCalcFilter."Business Unit");
        if GroupedLoanGLEntry.FindSet() then
            repeat
                //Still using temp because schema line filters may conflict with global filters
                TempGroupedLoanGLEntry := GroupedLoanGLEntry;
                TempGroupedLoanGLEntry.Insert();
            until GroupedLoanGLEntry.Next() = 0;
        RecordReference.GetTable(Loan);
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
        LoanLevelReportSchemaLine.SetFilter(Type, '<>%1', LoanLevelReportSchemaLine.Type::Formula);
        LoanLevelReportSchemaLine.FindSet();
        repeat
            Clear(TempLoanLevelValueBuffer);
            TempLoanLevelValueBuffer."Row No." := TempRowBuffer.Id;
            TempLoanLevelValueBuffer."Column No." := LoanLevelReportSchemaLine."Column No.";
            TempLoanLevelValueBuffer."Number Format Code" := LoanLevelReportSchemaLine."Number Format Code";
            CalculatePlainValue(LoanLevelReportSchemaLine, TempGroupedLoanGLEntry, Loan, RecordReference);
            TempLoanLevelValueBuffer.Insert();
        until LoanLevelReportSchemaLine.Next() = 0;
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
        LoanLevelReportSchemaLine.SetRange(Type, LoanLevelReportSchemaLine.Type::Formula);
        LoanLevelReportSchemaLine.FindSet();
        repeat
            CalculatedValue := CalculateFormulaValue(LoanLevelReportSchemaLine);
            Clear(TempLoanLevelValueBuffer);
            TempLoanLevelValueBuffer."Row No." := TempRowBuffer.Id;
            TempLoanLevelValueBuffer."Column No." := LoanLevelReportSchemaLine."Column No.";
            TempLoanLevelValueBuffer."Number Format Code" := LoanLevelReportSchemaLine."Number Format Code";
            TempLoanLevelValueBuffer."Raw Value" := CalculatedValue;
            if Evaluate(TempLoanLevelValueBuffer."Numeric Value", CalculatedValue) then
                TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Number
            else
                TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Text;
            TempLoanLevelValueBuffer.Insert();
        until LoanLevelReportSchemaLine.Next() = 0;
        RecordReference.Close();
        if TotalsRowVisible then begin
            TempLoanLevelValueBuffer.Reset();
            TempLoanLevelValueBuffer.SetRange("Row No.", TempRowBuffer.Id);
            if TempLoanLevelValueBuffer.FindSet() then
                repeat
                    if TempRowBuffer.Id = 1 then begin //First row
                        if TempLoanLevelValueBuffer."Value Type" = TempLoanLevelValueBuffer."Value Type"::Number then
                            TotalsData.Add(TempLoanLevelValueBuffer."Column No.", TempLoanLevelValueBuffer."Numeric Value");
                    end else
                        if TotalsData.Get(TempLoanLevelValueBuffer."Column No.", CurrentTotal) then
                            if TempLoanLevelValueBuffer."Value Type" = TempLoanLevelValueBuffer."Value Type"::Number then
                                TotalsData.Set(TempLoanLevelValueBuffer."Column No.", CurrentTotal + TempLoanLevelValueBuffer."Numeric Value")
                            else
                                TotalsData.Remove(TempLoanLevelValueBuffer."Column No.");
                until TempLoanLevelValueBuffer.Next() = 0;
        end;
    end;

    local procedure CalculatePlainValue(
        var LoanLevelReportSchemaLine: Record lvnLoanLevelReportSchemaLine;
        var GroupedLoanGLEntry: Record lvnGroupedLoanGLEntry;
        var Loan: Record lvnLoan;
        var LoanRef: RecordRef)
    var
        LoanValue: Record lvnLoanValue;
        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
        FieldReference: FieldRef;
        GLFilter: Text;
    begin
        case LoanLevelReportSchemaLine.Type of
            LoanLevelReportSchemaLine.Type::"G/L Entry":
                begin
                    TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Number;
                    //Possible bug (was): Value was always set to 0 if no filter is specified
                    GroupedLoanGLEntry.Reset();
                    if GLFilterCache.Get(LoanLevelReportSchemaLine."Column No.", GLFilter) then
                        GroupedLoanGLEntry.SetView(GLFilter);
                    GroupedLoanGLEntry.CalcSums(Amount);
                    TempLoanLevelValueBuffer."Numeric Value" := GroupedLoanGLEntry.Amount;
                    TempLoanLevelValueBuffer."Raw Value" := Format(TempLoanLevelValueBuffer."Numeric Value");
                end;
            LoanLevelReportSchemaLine.Type::"Variable Field":
                if LoanValue.Get(Loan."No.", LoanLevelReportSchemaLine."Value Field No.") then begin
                    LoanFieldsConfiguration.Get(LoanValue."Field No.");
                    case LoanFieldsConfiguration."Value Type" of
                        LoanFieldsConfiguration."Value Type"::Boolean:
                            begin
                                TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Text;
                                if LoanValue."Boolean Value" then
                                    TempLoanLevelValueBuffer."Raw Value" := YesTxt
                                else
                                    TempLoanLevelValueBuffer."Raw Value" := NoTxt;
                            end;
                        LoanFieldsConfiguration."Value Type"::Date:
                            begin
                                TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Date;
                                TempLoanLevelValueBuffer."Date Value" := LoanValue."Date Value";
                                TempLoanLevelValueBuffer."Raw Value" := Format(TempLoanLevelValueBuffer."Date Value");
                            end;
                        LoanFieldsConfiguration."Value Type"::Decimal:
                            begin
                                TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Number;
                                TempLoanLevelValueBuffer."Numeric Value" := LoanValue."Decimal Value";
                                TempLoanLevelValueBuffer."Raw Value" := Format(TempLoanLevelValueBuffer."Numeric Value");
                            end;
                        LoanFieldsConfiguration."Value Type"::Integer:
                            begin
                                TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Number;
                                TempLoanLevelValueBuffer."Numeric Value" := LoanValue."Integer Value";
                                TempLoanLevelValueBuffer."Raw Value" := Format(TempLoanLevelValueBuffer."Numeric Value");
                            end
                        else begin
                                TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Text;
                                TempLoanLevelValueBuffer."Raw Value" := LoanValue."Field Value";
                            end;
                    end;
                end;
            LoanLevelReportSchemaLine.Type::"Table Field":
                begin
                    FieldReference := LoanRef.Field(LoanLevelReportSchemaLine."Value Field No.");
                    TempLoanLevelValueBuffer."Raw Value" := Format(FieldReference.Value);
                    TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Text;
                    if Evaluate(TempLoanLevelValueBuffer."Date Value", TempLoanLevelValueBuffer."Raw Value") then
                        TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Date
                    else
                        if Evaluate(TempLoanLevelValueBuffer."Numeric Value", TempLoanLevelValueBuffer."Raw Value") then
                            TempLoanLevelValueBuffer."Value Type" := TempLoanLevelValueBuffer."Value Type"::Number;
                end;
        end;
    end;

    local procedure CalculateFormulaValue(var LoanLevelReportSchemaLine: Record lvnLoanLevelReportSchemaLine): Text
    var
        ExpressionHeader: Record lvnExpressionHeader;
        TempExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
        LoanLevelMgmt: Codeunit lvnLoanLevelReportManagement;
        ExpressionEngine: Codeunit lvnExpressionEngine;
    begin
        ExpressionHeader.Get(LoanLevelReportSchemaLine."Formula Code", LoanLevelMgmt.GetLoanLevelFormulaConsumerId());
        TempExpressionValueBuffer.Reset();
        TempExpressionValueBuffer.DeleteAll();
        TempLoanLevelValueBuffer.Reset();
        TempLoanLevelValueBuffer.SetRange("Row No.", TempRowBuffer.Id);
        TempLoanLevelValueBuffer.SetRange("Value Type", TempLoanLevelValueBuffer."Value Type"::Number);
        if TempLoanLevelValueBuffer.FindSet() then
            repeat
                Clear(TempExpressionValueBuffer);
                TempExpressionValueBuffer.Number := TempLoanLevelValueBuffer."Column No.";
                TempExpressionValueBuffer.Name := 'Col' + Format(TempLoanLevelValueBuffer."Column No.");
                TempExpressionValueBuffer.Type := 'Decimal';
                TempExpressionValueBuffer.Value := TempLoanLevelValueBuffer."Raw Value";
                TempExpressionValueBuffer.Insert();
            until TempLoanLevelValueBuffer.Next() = 0;
        exit(ExpressionEngine.CalculateFormula(ExpressionHeader, TempExpressionValueBuffer));
    end;

    local procedure InitializeDataGrid()
    var
        Json: JsonObject;
        Setting: JsonObject;
    begin
        Json.Add('columns', GetColumns());
        Json.Add('dataSource', GetData());
        Setting.Add('enabled', false);
        Json.Add('paging', Setting);
        Clear(Setting);
        Setting.Add('mode', 'none');
        Json.Add('sorting', Setting);
        Json.Add('columnAutoWidth', true);
        CurrPage.DataGrid.SetupStyles(GetGridStyles());
        CurrPage.DataGrid.InitializeDXGrid(Json);
    end;

    local procedure GetGridStyles() Json: JsonObject
    var
        CssClass: JsonObject;
    begin
        Clear(Json);
        Clear(CssClass);
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('font-style', 'italic');
        CssClass.Add('text-align', 'center !important');
        CssClass.Add('border-left', 'none !important');
        CssClass.Add('border-right', 'none !important');
        Json.Add('.dx-header-row td', CssClass);
        Clear(CssClass);
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('text-align', 'left');
        CssClass.Add('border-right', '1px solid #808080');
        CssClass.Add('white-space', 'nowrap');
        Json.Add('td.desc', CssClass);
        Clear(CssClass);
        CssClass.Add('text-align', 'right');
        Json.Add('.right', CssClass);
        Clear(CssClass);
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('border-top', '1px solid #000');
        Json.Add('.totals td', CssClass);
    end;

    local procedure GetData() DataSource: JsonArray
    var
        LoanLevelReportSchemaLine: Record lvnLoanLevelReportSchemaLine;
        PerformanceMgmt: Codeunit lvnPerformanceMgmt;
        RowData: JsonObject;
        ValueData: JsonObject;
        CalculatedTotal: Decimal;
    begin
        TempRowBuffer.Reset();
        if TempRowBuffer.FindSet() then begin
            repeat
                Clear(RowData);
                RowData.Add('rowId', TempRowBuffer.Id);
                RowData.Add('LoanNo', TempRowBuffer.Name);
                RowData.Add('BaseDate', TempRowBuffer.Value);
                RowData.Add('LOName', TempRowBuffer."Value Long");
                TempLoanLevelValueBuffer.Reset();
                TempLoanLevelValueBuffer.SetRange("Row No.", TempRowBuffer.Id);
                if TempLoanLevelValueBuffer.FindSet() then
                    repeat
                        if TempLoanLevelValueBuffer."Value Type" = TempLoanLevelValueBuffer."Value Type"::Number then begin
                            Clear(ValueData);
                            ValueData.Add('v', FormatValue(TempLoanLevelValueBuffer));
                            ValueData.Add('c', 'right');
                            RowData.Add('Col' + Format(TempLoanLevelValueBuffer."Column No."), ValueData);
                        end else
                            RowData.Add('Col' + Format(TempLoanLevelValueBuffer."Column No."), FormatValue(TempLoanLevelValueBuffer));
                    until TempLoanLevelValueBuffer.Next() = 0;
                DataSource.Add(RowData);
            until TempRowBuffer.Next() = 0;
            if TotalsRowVisible then begin
                Clear(RowData);
                RowData.Add('rowId', -1);
                RowData.Add('CssClass', 'totals');
                RowData.Add('LoanNo', TotalsTxt);
                RowData.Add('BaseDate', NotAvailableTxt);
                RowData.Add('LOName', NotAvailableTxt);
                LoanLevelReportSchemaLine.Reset();
                LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
                if LoanLevelReportSchemaLine.FindSet() then
                    repeat
                        if TotalsData.Get(LoanLevelReportSchemaLine."Column No.", CalculatedTotal) then begin
                            Clear(ValueData);
                            ValueData.Add('v', PerformanceMgmt.FormatValue(CalculatedTotal, LoanLevelReportSchemaLine."Number Format Code"));
                            ValueData.Add('c', 'right');
                            RowData.Add('Col' + Format(LoanLevelReportSchemaLine."Column No."), ValueData);
                        end else
                            RowData.Add('Col' + Format(LoanLevelReportSchemaLine."Column No."), NotAvailableTxt);
                    until LoanLevelReportSchemaLine.Next() = 0;
                DataSource.Add(RowData);
            end;
        end;
    end;

    local procedure FormatValue(var Buffer: Record lvnLoanLevelValueBuffer): Text
    var
        PerformanceMgmt: Codeunit lvnPerformanceMgmt;
    begin
        if Buffer."Value Type" <> Buffer."Value Type"::Number then
            exit(Buffer."Raw Value")
        else
            exit(PerformanceMgmt.FormatValue(Buffer."Numeric Value", Buffer."Number Format Code"))
    end;

    local procedure GetColumns() GridColumns: JsonArray
    var
        LoanLevelReportSchemaLine: Record lvnLoanLevelReportSchemaLine;
        ShowCol: Boolean;
    begin
        GridColumns.Add(GetColumn('LoanNo', LoanNoLbl, 'desc', true));
        case BasedOn of
            BasedOn::Sold:
                GridColumns.Add(GetColumn('BaseDate', DateSoldLbl, '', true));
            BasedOn::Posting:
                GridColumns.Add(GetColumn('BaseDate', PostingDateLbl, '', true))
            else
                GridColumns.Add(GetColumn('BaseDate', DateFundedLbl, '', true));
        end;
        GridColumns.Add(GetColumn('LOName', LONameLbl, '', true));
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
        if LoanLevelReportSchemaLine.FindSet() then
            repeat
                ShowCol := true;
                if LoanLevelReportSchema."Skip Zero Balance Lines" and (LoanLevelReportSchemaLine.Type = LoanLevelReportSchemaLine.Type::"G/L Entry") then begin
                    TempLoanLevelValueBuffer.Reset();
                    TempLoanLevelValueBuffer.SetRange("Column No.", LoanLevelReportSchemaLine."Column No.");
                    TempLoanLevelValueBuffer.SetFilter("Numeric Value", '<>0');
                    ShowCol := not TempLoanLevelValueBuffer.IsEmpty();
                end;
                if ShowCol then
                    GridColumns.Add(GetColumn('Col' + Format(LoanLevelReportSchemaLine."Column No."), LoanLevelReportSchemaLine.Description, '', false));
            until LoanLevelReportSchemaLine.Next() = 0;
    end;

    local procedure GetColumn(DataField: Text; Caption: Text; CssClass: Text; Fix: Boolean) Col: JsonObject
    begin
        Col.Add('dataField', DataField);
        Col.Add('caption', Caption);
        if CssClass <> '' then
            Col.Add('cssClass', CssClass);
        if Fix then begin
            Col.Add('fixed', true);
            Col.Add('fixedPosition', 'left');
        end;
    end;

    local procedure ExportToExcel(GridExportMode: Enum lvnGridExportMode)
    var
        LoanLevelReportSchemaLine: Record lvnLoanLevelReportSchemaLine;
        ExpressionHeader: Record lvnExpressionHeader;
        TempColBuffer: Record lvnLoanLevelReportSchemaLine temporary;
        LoanLevelMgmt: Codeunit lvnLoanLevelReportManagement;
        ExpressionEngine: Codeunit lvnExpressionEngine;
        ExcelExport: Codeunit lvnExcelExport;
        ColIndexLookup: Dictionary of [Integer, Integer];
        DataColStartIdx: Integer;
        DataRowStartIdx: Integer;
        RowId: Integer;
        Idx: Integer;
        ShowCol: Boolean;
        Dummy: Decimal;
        BaseDate: Date;
    begin
        Idx := 0;
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
        if LoanLevelReportSchemaLine.FindSet() then
            repeat
                ShowCol := true;
                if LoanLevelReportSchema."Skip Zero Balance Lines" and (LoanLevelReportSchemaLine.Type = LoanLevelReportSchemaLine.Type::"G/L Entry") then begin
                    TempLoanLevelValueBuffer.Reset();
                    TempLoanLevelValueBuffer.SetRange("Column No.", LoanLevelReportSchemaLine."Column No.");
                    TempLoanLevelValueBuffer.SetFilter("Numeric Value", '<>0');
                    ShowCol := not TempLoanLevelValueBuffer.IsEmpty();
                end;
                if ShowCol then begin
                    TempColBuffer := LoanLevelReportSchemaLine;
                    TempColBuffer.Insert();
                    ColIndexLookup.Add(TempColBuffer."Column No.", Idx);
                    Idx += 1;
                end;
            until LoanLevelReportSchemaLine.Next() = 0;
        ExcelExport.Init('LoanLevelWorksheet', GridExportMode);
        //Add Filters
        ExcelExport.NewRow(-10);
        ExcelExport.StyleColumn(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, -1, '', '', '');
        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 14, '', '', '');
        ExcelExport.BeginRange();
        ExcelExport.WriteString(LoanLevelReportSchema.Description);
        ExcelExport.SkipCells(6);
        ExcelExport.MergeRange(false);
        ExcelExport.NewRow(-20);
        RowId := -30;
        if TempSystemCalcFilter."Global Dimension 1" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('3,1,1'));
            ExcelExport.WriteString(TempSystemCalcFilter."Global Dimension 1");
        end;
        if TempSystemCalcFilter."Global Dimension 2" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('3,1,2'));
            ExcelExport.WriteString(TempSystemCalcFilter."Global Dimension 2");
        end;
        if TempSystemCalcFilter."Shortcut Dimension 3" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('4,1,3'));
            ExcelExport.WriteString(TempSystemCalcFilter."Shortcut Dimension 3");
        end;
        if TempSystemCalcFilter."Shortcut Dimension 4" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('4,1,4'));
            ExcelExport.WriteString(TempSystemCalcFilter."Shortcut Dimension 4");
        end;
        if TempSystemCalcFilter."Business Unit" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(BusinessUnitFilterTxt);
            ExcelExport.WriteString(TempSystemCalcFilter."Business Unit");
        end;
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        ExcelExport.WriteString(BaseDateTxt);
        if BasedOn = BasedOn::Default then
            BasedOn := BasedOn::Funded;
        ExcelExport.WriteString(Format(BasedOn));
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        ExcelExport.WriteString(DateFilterTxt);
        ExcelExport.WriteString(TempSystemCalcFilter."Date Filter");
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        //Add Header
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Yes, DefaultBoolean::No, -1, '', '', '');
        ExcelExport.AlignRow(CellHorizontalAlignment::Center, CellVerticalAlignment::Default, -1, 0, DefaultBoolean::Default, DefaultBoolean::Default);
        DataColStartIdx := 3; //Skip LoanNo, BaseDate and LOName columns
        DataRowStartIdx := -RowId div 10 - 1; //Skip header columns, - 1 for zero-based
        ExcelExport.WriteString(LoanNoLbl);
        case BasedOn of
            BasedOn::Sold:
                ExcelExport.WriteString(DateSoldLbl);
            BasedOn::Posting:
                ExcelExport.WriteString(PostingDateLbl);
            else
                ExcelExport.WriteString(DateFundedLbl);
        end;
        ExcelExport.WriteString(LONameLbl);
        TempColBuffer.Reset();
        if TempColBuffer.FindSet() then
            repeat
                ExcelExport.WriteString(TempColBuffer.Description);
            until TempColBuffer.Next() = 0;
        //Add Rows
        TempRowBuffer.Reset();
        if TempRowBuffer.FindSet() then begin
            repeat
                ExcelExport.NewRow(TempRowBuffer.Id);
                ExcelExport.WriteString(TempRowBuffer.Name);    //LoanNo
                Evaluate(BaseDate, TempRowBuffer.Value);
                ExcelExport.WriteDate(BaseDate);   //Date
                ExcelExport.WriteString(TempRowBuffer."Value Long");//LOName
                TempColBuffer.Reset();
                if TempColBuffer.FindSet() then
                    repeat
                        if TempColBuffer.Type = TempColBuffer.Type::Formula then begin
                            ExcelExport.FormatCell(TempColBuffer."Number Format Code");
                            ExpressionHeader.Get(TempColBuffer."Formula Code", LoanLevelMgmt.GetLoanLevelFormulaConsumerId());
                            ExcelExport.WriteFormula('=' + TranslateRowFormula(ExpressionEngine.GetFormulaFromLines(ExpressionHeader), TempRowBuffer.Id - 1, DataRowStartIdx, DataColStartIdx, ColIndexLookup));
                        end else begin
                            TempLoanLevelValueBuffer.Get(TempRowBuffer.Id, TempColBuffer."Column No.");
                            if TempLoanLevelValueBuffer."Number Format Code" <> '' then
                                ExcelExport.FormatCell(TempLoanLevelValueBuffer."Number Format Code");
                            case TempLoanLevelValueBuffer."Value Type" of
                                TempLoanLevelValueBuffer."Value Type"::Number:
                                    ExcelExport.WriteNumber(TempLoanLevelValueBuffer."Numeric Value");
                                TempLoanLevelValueBuffer."Value Type"::Date:
                                    ExcelExport.WriteDate(TempLoanLevelValueBuffer."Date Value");
                                else
                                    ExcelExport.WriteString(TempLoanLevelValueBuffer."Raw Value");
                            end;
                        end;
                    until TempColBuffer.Next() = 0;
            until TempRowBuffer.Next() = 0;
            if TotalsRowVisible then begin
                ExcelExport.NewRow(TempRowBuffer.Id + 1);
                ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::No, DefaultBoolean::No, -1, '', '', '');
                ExcelExport.WriteString(TotalsTxt);
                ExcelExport.WriteString(NotAvailableTxt);
                ExcelExport.WriteString(NotAvailableTxt);
                TempColBuffer.Reset();
                TempColBuffer.SetRange("Report Code", LoanLevelReportSchema.Code);
                if TempColBuffer.FindSet() then
                    repeat
                        if TotalsData.Get(TempColBuffer."Column No.", Dummy) then begin
                            ExcelExport.FormatCell(TempColBuffer."Number Format Code");
                            ExcelExport.WriteFormula('=SUM(' + TranslateRowFormulaField('col' + Format(TempColBuffer."Column No."), 0, DataRowStartIdx, DataColStartIdx, ColIndexLookup) + ':' + TranslateRowFormulaField('col' + Format(TempColBuffer."Column No."), TempRowBuffer.Id - 1, DataRowStartIdx, DataColStartIdx, ColIndexLookup) + ')');
                        end else
                            ExcelExport.WriteString(NotAvailableTxt);
                    until TempColBuffer.Next() = 0;
            end;
        end;
        ExcelExport.AutoFit(false, true);
        ExcelExport.Download(GetExportFileName(GridExportMode));
    end;

    local procedure TranslateRowFormula(
        Formula: Text;
        RowIdx: Integer;
        DataRowOffset: Integer;
        DataColOffset: Integer;
        var ColIndexLookup: Dictionary of [Integer, Integer]): Text
    var
        FieldStart: Integer;
        FieldEnd: Integer;
    begin
        //[Col1]+[Col2]+[Col3]+...
        //=>
        //=D7+E7+F7+...
        Formula := LowerCase(Formula);
        FieldStart := StrPos(Formula, '[');
        while FieldStart <> 0 do begin
            FieldEnd := StrPos(Formula, ']');
            if FieldEnd = 0 then
                Error(IntranslatableRowFormulaErr);
            Formula := CopyStr(Formula, 1, FieldStart - 1) + TranslateRowFormulaField(CopyStr(Formula, FieldStart + 1, FieldEnd - FieldStart - 1), RowIdx, DataRowOffset, DataColOffset, ColIndexLookup) + CopyStr(Formula, FieldEnd + 1);
            FieldStart := StrPos(Formula, '[');
        end;
        exit(Formula);
    end;

    local procedure TranslateRowFormulaField(
        Field: Text;
        RowIdx: Integer;
        DataRowOffset: Integer;
        DataColOffset: Integer;
        var ColIndexLookup: Dictionary of [Integer, Integer]): Text
    var
        ExcelExport: Codeunit lvnExcelExport;
        FieldIdx: Integer;
    begin
        if StrPos(Field, 'col') <> 1 then
            Error(IntranslatableRowFormulaErr);
        if not Evaluate(FieldIdx, DelStr(Field, 1, 3)) then
            Error(IntranslatableRowFormulaErr);
        if not ColIndexLookup.Get(FieldIdx, FieldIdx) then
            Error(IntranslatableRowFormulaErr);
        exit(ExcelExport.GetExcelColumnName(DataColOffset + FieldIdx) + Format(RowIdx + DataRowOffset + 1));
    end;
}