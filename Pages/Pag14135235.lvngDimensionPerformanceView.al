page 14135235 lvngDimensionPerformanceView
{
    PageType = Worksheet;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    Caption = 'Dimension Performance View';

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                field(SchemaName; SchemaName) { ApplicationArea = All; Caption = 'View Name'; ShowCaption = false; Editable = false; }
                field(Dim1Filter; Dim1Filter) { ApplicationArea = All; Caption = 'Dimension 1 Filter'; Editable = false; Visible = Dim1Visible; CaptionClass = '1,3,1'; }
                field(Dim2Filter; Dim2Filter) { ApplicationArea = All; Caption = 'Dimension 2 Filter'; Editable = false; Visible = Dim2Visible; CaptionClass = '1,3,2'; }
                field(Dim3Filter; Dim3Filter) { ApplicationArea = All; Caption = 'Dimension 3 Filter'; Editable = false; Visible = Dim3Visible; CaptionClass = '1,2,3'; }
                field(Dim4Filter; Dim4Filter) { ApplicationArea = All; Caption = 'Dimension 4 Filter'; Editable = false; Visible = Dim4Visible; CaptionClass = '1,2,4'; }
                field(BusinessUnitFilter; BusinessUnitFilter) { ApplicationArea = All; Caption = 'Business Unit Filter'; Editable = false; Visible = BusinessUnitVisible; }
                field(DateFilter; DateFilter) { ApplicationArea = All; Caption = 'Date Filter'; Editable = false; }
            }
            usercontrol(DataGrid; DataGridControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    InitializeDataGrid();
                end;

                trigger CellClick(BandIndex: Integer; ColIndex: Integer; RowIndex: Integer)
                begin
                    ProcessCellClick(BandIndex, ColIndex, RowIndex);
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
                    ExportToExcel(GridExportMode::lvngXlsx);
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
                    ExportToExcel(GridExportMode::lvngPdf);
                end;
            }
            action(HtmlExport)
            {
                ApplicationArea = All;
                Caption = 'Html Export';
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::lvngHtml);
                end;
            }
        }
    }

    var
        RowSchema: Record lvngPerformanceRowSchema;
        BandSchema: Record lvngDimensionPerfBandSchema;
        ColSchema: Record lvngPerformanceColSchema;
        TempBandLine: Record lvngDimPerfBandSchemaLine temporary;
        Buffer: Record lvngPerformanceValueBuffer temporary;
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
        PerformanceDataExport: Codeunit lvngPerformanceDataExport;
        BandIndexLookup: Dictionary of [Integer, Integer];
        StylesInUse: Dictionary of [Code[20], Boolean];
        GridExportMode: Enum lvngGridExportMode;
        SchemaName: Text;
        Dim1Filter: Code[20];
        Dim2Filter: Code[20];
        Dim3Filter: Code[20];
        Dim4Filter: Code[20];
        BusinessUnitFilter: Code[20];
        Dim1Visible: Boolean;
        Dim2Visible: Boolean;
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;
        BusinessUnitVisible: Boolean;
        DateFilter: Text;
        SchemaNameFormatTxt: Label '%1 - %2';
        NoDimensionPerformanceTotalsErr: Label 'Totals row is not supported by dimension performance view. Use row formula instead';

    trigger OnOpenPage()
    begin
        ColSchema.Get(RowSchema."Column Schema");
        SchemaName := StrSubstNo(SchemaNameFormatTxt, RowSchema.Description, BandSchema.Description);
        CalculateColumns();
    end;

    procedure SetParams(RowSchemaCode: Code[20]; BandSchemaCode: Code[20]; DateRange: Text; Dim1Code: Code[20]; Dim2Code: Code[20]; Dim3Code: Code[20]; Dim4Code: Code[20]; BUCode: Code[20])
    begin
        RowSchema.Get(RowSchemaCode);
        BandSchema.Get(BandSchemaCode);
        BusinessUnitFilter := BUCode;
        Dim1Filter := Dim1Code;
        Dim2Filter := Dim2Code;
        Dim3Filter := Dim3Code;
        Dim4Filter := Dim4Code;
        BusinessUnitVisible := BUCode <> '';
        Dim1Visible := Dim1Code <> '';
        Dim2Visible := Dim2Code <> '';
        Dim3Visible := Dim3Code <> '';
        Dim4Visible := Dim4Code <> '';
        DateFilter := DateRange;
    end;

    local procedure CalculateColumns()
    var
        DynamicBandLink: Record lvngDynamicBandLink;
        BandLine: Record lvngDimPerfBandSchemaLine;
        DimensionValue: Record "Dimension Value";
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        LineNo: Integer;
    begin
        TempBandLine.Reset();
        TempBandLine.DeleteAll();
        Clear(BandIndexLookup);
        if BandSchema."Dynamic Layout" then begin
            DynamicBandLink.Reset();
            DynamicBandLink.SetRange("Dimension Code", BandSchema."Dimension Code");
            if Dim1Filter <> '' then
                DynamicBandLink.SetRange("Global Dimension 1 Code", Dim1Filter);
            if Dim2Filter <> '' then
                DynamicBandLink.SetRange("Global Dimension 2 Code", Dim2Filter);
            if Dim3Filter <> '' then
                DynamicBandLink.SetRange("Shortcut Dimension 3 Code", Dim3Filter);
            if Dim4Filter <> '' then
                DynamicBandLink.SetRange("Shortcut Dimension 4 Code", Dim4Filter);
            if BusinessUnitFilter <> '' then
                DynamicBandLink.SetRange("Business Unit Code", BusinessUnitFilter);
            DynamicBandLink.FindSet();
            LineNo := 1;
            repeat
                Clear(TempBandLine);
                TempBandLine."Schema Code" := BandSchema.Code;
                TempBandLine."Band No." := LineNo;
                BandIndexLookup.Add(LineNo, LineNo - 1);
                DimensionValue.Get(BandSchema."Dimension Code", DynamicBandLink."Dimension Value Code");
                TempBandLine."Header Description" := DimensionValue.Name;
                TempBandLine."Dimension Filter" := DimensionValue.Code;
                TempBandLine."Band Type" := TempBandLine."Band Type"::lvngNormal;
                LineNo += 1;
                TempBandLine.Insert();
            until DynamicBandLink.Next() = 0;
        end else begin
            BandLine.Reset();
            BandLine.SetRange("Schema Code", BandSchema.Code);
            BandLine.FindSet();
            LineNo := 0;
            repeat
                Clear(TempBandLine);
                TempBandLine := BandLine;
                BandIndexLookup.Add(TempBandLine."Band No.", LineNo);
                LineNo += 1;
                TempBandLine.Insert();
            until BandLine.Next() = 0;
        end;

        TempBandLine.Reset();
        TempBandLine.SetRange("Schema Code", BandSchema.Code);
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::lvngNormal);
        TempBandLine.FindSet();
        repeat
            InitializeSystemFilter(SystemFilter);
            PerformanceMgmt.ApplyDimensionBandFilter(SystemFilter, BandSchema, TempBandLine);
            PerformanceMgmt.CalculatePerformanceBand(Buffer, TempBandLine."Band No.", RowSchema, ColSchema, SystemFilter);
        until TempBandLine.Next() = 0;

        TempBandLine.Reset();
        TempBandLine.SetRange("Schema Code", BandSchema.Code);
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::lvngTotals);
        if TempBandLine.FindSet() then
            Error(NoDimensionPerformanceTotalsErr);

        TempBandLine.Reset();
        TempBandLine.SetRange("Schema Code", BandSchema.Code);
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::lvngFormula);
        if TempBandLine.FindSet() then
            repeat
                InitializeSystemFilter(SystemFilter);
                PerformanceMgmt.ApplyDimensionBandFilter(SystemFilter, BandSchema, TempBandLine);
                PerformanceMgmt.CalculateFormulaBand(Buffer, TempBandLine."Band No.", RowSchema, ColSchema, SystemFilter, TempBandLine."Row Formula Code", PerformanceMgmt.GetDimensionRowExpressionConsumerId());
            until TempBandLine.Next() = 0;
    end;

    local procedure InitializeSystemFilter(var SystemFilter: Record lvngSystemCalculationFilter)
    begin
        Clear(SystemFilter);
        SystemFilter."Date Filter" := DateFilter;
        SystemFilter."Shortcut Dimension 1" := Dim1Filter;
        SystemFilter."Shortcut Dimension 2" := Dim2Filter;
        SystemFilter."Shortcut Dimension 3" := Dim3Filter;
        SystemFilter."Shortcut Dimension 4" := Dim4Filter;
        SystemFilter."Business Unit" := BusinessUnitFilter;
    end;

    local procedure InitializeDataGrid()
    var
        Json: JsonObject;
        Setting: JsonObject;
    begin
        Json.Add('columns', GetColumns());
        Json.Add('dataSource', PerformanceMgmt.GetData(Buffer, StylesInUse, RowSchema.Code, RowSchema."Column Schema"));
        Setting.Add('enabled', false);
        Json.Add('paging', Setting);
        Clear(Setting);
        Setting.Add('mode', 'none');
        Json.Add('sorting', Setting);
        Json.Add('columnAutoWidth', true);
        CurrPage.DataGrid.SetupStyles(PerformanceMgmt.GetGridStyles(StylesInUse.Keys()));
        CurrPage.DataGrid.InitializeDXGrid(Json);
    end;

    local procedure ProcessCellClick(BandIndex: Integer; ColIndex: Integer; RowIndex: Integer)
    var
        RowLine: Record lvngPerformanceRowSchemaLine;
        CalcUnit: Record lvngCalculationUnit;
        Loan: Record lvngLoan;
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        GLEntry: Record "G/L Entry";
        LoanList: Page lvngLoanList;
        GLEntries: Page lvngPerformanceGLEntries;
    begin
        TempBandLine.Get(BandSchema.Code, BandIndex);
        if TempBandLine."Band Type" = TempBandLine."Band Type"::lvngNormal then begin
            RowLine.Get(RowSchema.Code, RowIndex, ColIndex);
            CalcUnit.Get(RowLine."Calculation Unit Code");
            InitializeSystemFilter(SystemFilter);
            PerformanceMgmt.ApplyDimensionBandFilter(SystemFilter, BandSchema, TempBandLine);
            case CalcUnit."Lookup Source" of
                CalcUnit."Lookup Source"::lvngLoanCard:
                    begin
                        Loan.Reset();
                        PerformanceMgmt.ApplyLoanFilter(Loan, CalcUnit, SystemFilter);
                        LoanList.SetTableView(Loan);
                        LoanList.RunModal();
                    end;
                CalcUnit."Lookup Source"::lvngLedgerEntries:
                    begin
                        GLEntry.Reset();
                        PerformanceMgmt.ApplyGLFilter(GLEntry, CalcUnit, SystemFilter);
                        GLEntries.SetTableView(GLEntry);
                        GLEntries.RunModal();
                    end;
            end;
        end;
    end;

    local procedure ExportToExcel(GridExportMode: Enum lvngGridExportMode)
    var
        HeaderData: Record lvngSystemCalculationFilter temporary;
        BandInfo: Record lvngPerformanceBandLineInfo temporary;
        PerformanceDataExport: Codeunit lvngPerformanceDataExport;
        ExcelExport: Codeunit lvngExcelExport;
    begin
        Clear(HeaderData);
        HeaderData.Description := SchemaName;
        HeaderData."Shortcut Dimension 1" := Dim1Filter;
        HeaderData."Shortcut Dimension 2" := Dim2Filter;
        HeaderData."Shortcut Dimension 3" := Dim3Filter;
        HeaderData."Shortcut Dimension 4" := Dim4Filter;
        HeaderData."Business Unit" := BusinessUnitFilter;
        TempBandLine.Reset();
        repeat
            Clear(BandInfo);
            BandInfo."Band No." := TempBandLine."Band No.";
            BandInfo."Band Type" := TempBandLine."Band Type";
            BandInfo."Header Description" := TempBandLine."Header Description";
            BandInfo."Row Formula Code" := TempBandLine."Row Formula Code";
            BandInfo.Insert();
        until TempBandLine.Next() = 0;
        ExcelExport.Init('PerformanceWorksheet', GridExportMode);
        PerformanceDataExport.ExportToExcel(ExcelExport, RowSchema, Buffer, HeaderData, BandInfo);
        ExcelExport.Download(PerformanceDataExport.GetExportFileName(GridExportMode, RowSchema."Schema Type"));
    end;

    local procedure GetColumns() GridColumns: JsonArray
    var
        ColLine: Record lvngPerformanceColSchemaLine;
        DimensionBand: JsonObject;
        BandColumns: JsonArray;
    begin
        //Name Column
        Clear(DimensionBand);
        Clear(BandColumns);
        DimensionBand.Add('fixed', true);
        DimensionBand.Add('fixedPosition', 'left');
        DimensionBand.Add('caption', '');
        BandColumns.Add(GetColumn('Name', 'Name', 'desc'));
        DimensionBand.Add('columns', BandColumns);
        GridColumns.Add(DimensionBand);
        //Bands
        TempBandLine.Reset();
        TempBandLine.FindSet();
        repeat
            Clear(DimensionBand);
            Clear(BandColumns);
            DimensionBand.Add('caption', TempBandLine."Header Description");
            ColLine.Reset();
            ColLine.SetRange("Schema Code", RowSchema."Column Schema");
            ColLine.FindFirst();
            repeat
                BandColumns.Add(GetColumn(StrSubstNo(PerformanceMgmt.GetFieldFormat(), TempBandLine."Band No.", ColLine."Column No."), ColLine."Primary Caption", ''));
            until ColLine.Next() = 0;
            DimensionBand.Add('columns', BandColumns);
            GridColumns.Add(DimensionBand);
        until TempBandLine.Next() = 0;
    end;

    local procedure GetColumn(DataField: Text; Caption: Text; CssClass: Text) Col: JsonObject
    begin
        Col.Add('dataField', DataField);
        Col.Add('caption', Caption);
        if CssClass <> '' then
            Col.Add('cssClass', CssClass);
    end;
}