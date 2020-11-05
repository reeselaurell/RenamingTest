page 14135214 "lvnDimensionPerformanceView"
{
    PageType = Card;
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
                field(SchemaName; SystemFilter.Description)
                {
                    ApplicationArea = All;
                    Caption = 'View Name';
                    ShowCaption = false;
                    Editable = false;
                }
                field(Dim1Filter; SystemFilter."Global Dimension 1")
                {
                    ApplicationArea = All;
                    Caption = 'Dimension 1 Filter';
                    Editable = false;
                    Visible = Dim1Visible;
                    CaptionClass = '1,3,1';
                }
                field(Dim2Filter; SystemFilter."Global Dimension 2")
                {
                    ApplicationArea = All;
                    Caption = 'Dimension 2 Filter';
                    Editable = false;
                    Visible = Dim2Visible;
                    CaptionClass = '1,3,2';
                }
                field(Dim3Filter; SystemFilter."Shortcut Dimension 3")
                {
                    ApplicationArea = All;
                    Caption = 'Dimension 3 Filter';
                    Editable = false;
                    Visible = Dim3Visible;
                    CaptionClass = '1,2,3';
                }
                field(Dim4Filter; SystemFilter."Shortcut Dimension 4")
                {
                    ApplicationArea = All;
                    Caption = 'Dimension 4 Filter';
                    Editable = false;
                    Visible = Dim4Visible;
                    CaptionClass = '1,2,4';
                }
                field(BusinessUnitFilter; SystemFilter."Business Unit")
                {
                    ApplicationArea = All;
                    Caption = 'Business Unit Filter';
                    Editable = false;
                    Visible = BusinessUnitVisible;
                }
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Date Filter';
                    Editable = false;
                }
            }
            usercontrol(DataGrid; lvnDataGridControl)
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
        ColSchema.Get(RowSchema."Column Schema");
        CalculateColumns();
    end;

    var
        RowSchema: Record lvnPerformanceRowSchema;
        BandSchema: Record lvnDimensionPerfBandSchema;
        ColSchema: Record lvnPerformanceColSchema;
        TempBandLine: Record lvnDimPerfBandSchemaLine temporary;
        Buffer: Record lvnPerformanceValueBuffer temporary;
        SystemFilter: Record lvnSystemCalculationFilter temporary;
        PerformanceMgmt: Codeunit lvnPerformanceMgmt;
        PerformanceDataExport: Codeunit lvnPerformanceDataExport;
        BandIndexLookup: Dictionary of [Integer, Integer];
        StylesInUse: Dictionary of [Code[20], Boolean];
        GridExportMode: Enum lvnGridExportMode;
        Dim1Visible: Boolean;
        Dim2Visible: Boolean;
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;
        BusinessUnitVisible: Boolean;
        DateFilter: Text;
        SchemaNameFormatTxt: Label '%1 - %2';
        NoDimensionPerformanceTotalsErr: Label 'Totals row is not supported by dimension performance view. Use row formula instead';

    procedure SetParams(
        RowSchemaCode: Code[20];
        BandSchemaCode: Code[20];
        var Filter: Record lvnSystemCalculationFilter)
    begin
        RowSchema.Get(RowSchemaCode);
        BandSchema.Get(BandSchemaCode);
        SystemFilter := Filter;
        SystemFilter.Description := StrSubstNo(SchemaNameFormatTxt, RowSchema.Description, BandSchema.Description);
        BusinessUnitVisible := SystemFilter."Business Unit" <> '';
        Dim1Visible := SystemFilter."Global Dimension 1" <> '';
        Dim2Visible := SystemFilter."Global Dimension 2" <> '';
        Dim3Visible := SystemFilter."Shortcut Dimension 3" <> '';
        Dim4Visible := SystemFilter."Shortcut Dimension 4" <> '';
    end;

    local procedure CalculateColumns()
    var
        DynamicBandLink: Record lvnDynamicBandLink;
        BandLine: Record lvnDimPerfBandSchemaLine;
        DimensionValue: Record "Dimension Value";
        BandFilter: Record lvnSystemCalculationFilter temporary;
        LineNo: Integer;
    begin
        TempBandLine.Reset();
        TempBandLine.DeleteAll();
        Clear(BandIndexLookup);
        if BandSchema."Dynamic Layout" then begin
            DynamicBandLink.Reset();
            DynamicBandLink.SetRange("Dimension Code", BandSchema."Dimension Code");
            if SystemFilter."Global Dimension 1" <> '' then
                DynamicBandLink.SetFilter("Global Dimension 1 Code", SystemFilter."Global Dimension 1");
            if SystemFilter."Global Dimension 2" <> '' then
                DynamicBandLink.SetFilter("Global Dimension 2 Code", SystemFilter."Global Dimension 2");
            if SystemFilter."Shortcut Dimension 3" <> '' then
                DynamicBandLink.SetFilter("Shortcut Dimension 3 Code", SystemFilter."Shortcut Dimension 3");
            if SystemFilter."Shortcut Dimension 4" <> '' then
                DynamicBandLink.SetFilter("Shortcut Dimension 4 Code", SystemFilter."Shortcut Dimension 4");
            if SystemFilter."Business Unit" <> '' then
                DynamicBandLink.SetFilter("Business Unit Code", SystemFilter."Business Unit");
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
                TempBandLine."Band Type" := TempBandLine."Band Type"::Normal;
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
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::Normal);
        TempBandLine.FindSet();
        repeat
            BandFilter := SystemFilter;
            PerformanceMgmt.ApplyDimensionBandFilter(BandFilter, BandSchema, TempBandLine);
            PerformanceMgmt.CalculatePerformanceBand(Buffer, TempBandLine."Band No.", RowSchema, ColSchema, BandFilter);
        until TempBandLine.Next() = 0;

        TempBandLine.Reset();
        TempBandLine.SetRange("Schema Code", BandSchema.Code);
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::Totals);
        if TempBandLine.FindSet() then
            Error(NoDimensionPerformanceTotalsErr);

        TempBandLine.Reset();
        TempBandLine.SetRange("Schema Code", BandSchema.Code);
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::Formula);
        if TempBandLine.FindSet() then
            repeat
                BandFilter := SystemFilter;
                PerformanceMgmt.ApplyDimensionBandFilter(BandFilter, BandSchema, TempBandLine);
                PerformanceMgmt.CalculateFormulaBand(Buffer, TempBandLine."Band No.", RowSchema, ColSchema, BandFilter, TempBandLine."Row Formula Code", PerformanceMgmt.GetDimensionRowExpressionConsumerId());
            until TempBandLine.Next() = 0;
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
        RowLine: Record lvnPerformanceRowSchemaLine;
        CalcUnit: Record lvnCalculationUnit;
        Loan: Record lvnLoan;
        BandFilter: Record lvnSystemCalculationFilter temporary;
        GLEntry: Record "G/L Entry";
        LoanList: Page lvnLoanList;
        GLEntries: Page lvnPerformanceGLEntries;
    begin
        TempBandLine.Get(BandSchema.Code, BandIndex);
        if TempBandLine."Band Type" = TempBandLine."Band Type"::Normal then begin
            RowLine.Get(RowSchema.Code, RowIndex, ColIndex);
            CalcUnit.Get(RowLine."Calculation Unit Code");
            BandFilter := SystemFilter;
            PerformanceMgmt.ApplyDimensionBandFilter(BandFilter, BandSchema, TempBandLine);
            case CalcUnit."Lookup Source" of
                CalcUnit."Lookup Source"::"Loan Card":
                    begin
                        Loan.Reset();
                        PerformanceMgmt.ApplyLoanFilter(Loan, CalcUnit, BandFilter);
                        LoanList.SetTableView(Loan);
                        LoanList.RunModal();
                    end;
                CalcUnit."Lookup Source"::"Ledger Entries":
                    begin
                        GLEntry.Reset();
                        PerformanceMgmt.ApplyGLFilter(GLEntry, CalcUnit, BandFilter);
                        GLEntries.SetTableView(GLEntry);
                        GLEntries.RunModal();
                    end;
            end;
        end;
    end;

    local procedure ExportToExcel(GridExportMode: Enum lvnGridExportMode)
    var
        HeaderData: Record lvnSystemCalculationFilter temporary;
        BandInfo: Record lvnPerformanceBandLineInfo temporary;
        PerformanceDataExport: Codeunit lvnPerformanceDataExport;
        ExcelExport: Codeunit lvnExcelExport;
    begin
        Clear(HeaderData);
        HeaderData.Description := SystemFilter.Description;
        HeaderData."Global Dimension 1" := SystemFilter."Global Dimension 1";
        HeaderData."Global Dimension 2" := SystemFilter."Global Dimension 2";
        HeaderData."Shortcut Dimension 3" := SystemFilter."Shortcut Dimension 3";
        HeaderData."Shortcut Dimension 4" := SystemFilter."Shortcut Dimension 4";
        HeaderData."Business Unit" := SystemFilter."Business Unit";
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
        ColLine: Record lvnPerformanceColSchemaLine;
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