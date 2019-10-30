page 14135220 lvngPeriodPerformanceView
{
    PageType = Worksheet;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    Caption = 'Period Performance View';

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
                field(AsOfDate; AsOfDate) { ApplicationArea = All; Caption = 'As Of Date'; Editable = false; }
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
        BandSchema: Record lvngPeriodPerfBandSchema;
        ColSchema: Record lvngPerformanceColSchema;
        BandInfoBuffer: Record lvngPerformanceBandLineInfo temporary;
        ValueBuffer: Record lvngPerformanceValueBuffer temporary;
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
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
        AsOfDate: Date;
        BlockDataFromDate: Date;
        BlockDataToDate: Date;
        SchemaNameFormatTxt: Label '%1 - %2';

    trigger OnOpenPage()
    begin
        CalculateColumns();
    end;

    procedure SetDateLimits(FromDate: Date; ToDate: Date)
    begin
        BlockDataFromDate := FromDate;
        BlockDataToDate := ToDate;
    end;

    procedure SetParams(RowSchemaCode: Code[20]; BandSchemaCode: Code[20]; ToDate: Date; Dim1Code: Code[20]; Dim2Code: Code[20]; Dim3Code: Code[20]; Dim4Code: Code[20]; BUCode: Code[20])
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
        AsOfDate := ToDate;
    end;

    local procedure CalculateColumns()
    var
        BaseFilter: Record lvngSystemCalculationFilter;
    begin
        if AsOfDate = 0D then
            AsOfDate := Today;
        SchemaName := StrSubstNo(SchemaNameFormatTxt, RowSchema.Description, BandSchema.Description);
        InitalizeSystemFilter(BaseFilter);
        PerformanceMgmt.CalculatePeriodsData(RowSchema, BandSchema, BaseFilter, BandInfoBuffer, ValueBuffer);
    end;

    local procedure InitalizeSystemFilter(var SystemFilter: Record lvngSystemCalculationFilter)
    begin
        Clear(SystemFilter);
        SystemFilter.Description := SchemaName;
        SystemFilter."Shortcut Dimension 1" := Dim1Filter;
        SystemFilter."Shortcut Dimension 2" := Dim2Filter;
        SystemFilter."Shortcut Dimension 3" := Dim3Filter;
        SystemFilter."Shortcut Dimension 4" := Dim4Filter;
        SystemFilter."Business Unit" := BusinessUnitFilter;
        SystemFilter."As Of Date" := AsOfDate;
        SystemFilter."Block Data From Date" := BlockDataFromDate;
        SystemFilter."Block Data To Date" := BlockDataToDate;
    end;

    local procedure InitializeDataGrid()
    var
        Json: JsonObject;
        Setting: JsonObject;
        StylesInUse: Dictionary of [Code[20], Boolean];
    begin
        Json.Add('columns', GetColumns());
        Json.Add('dataSource', PerformanceMgmt.GetData(ValueBuffer, StylesInUse, RowSchema.Code, RowSchema."Column Schema"));
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
        BandLine: Record lvngPeriodPerfBandSchemaLine;
        LoanList: Page lvngLoanList;
        GLEntries: Page lvngPerformanceGLEntries;
    begin
        BandLine.Get(BandSchema.Code, BandIndex);
        if BandLine."Band Type" = BandLine."Band Type"::lvngNormal then begin
            RowLine.Get(RowSchema.Code, RowIndex, ColIndex);
            CalcUnit.Get(RowLine."Calculation Unit Code");
            InitalizeSystemFilter(SystemFilter);
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
        ExcelExport.Init('PerformanceWorksheet', GridExportMode);
        PerformanceDataExport.ExportToExcel(ExcelExport, RowSchema, ValueBuffer, HeaderData, BandInfoBuffer);
        ExcelExport.Download(PerformanceDataExport.GetExportFileName(GridExportMode, RowSchema."Schema Type"));
    end;

    local procedure GetColumns() GridColumns: JsonArray
    var
        ColLine: Record lvngPerformanceColSchemaLine;
        PeriodBand: JsonObject;
        BandColumns: JsonArray;
    begin
        //Name Column
        Clear(PeriodBand);
        Clear(BandColumns);
        PeriodBand.Add('fixed', true);
        PeriodBand.Add('fixedPosition', 'left');
        PeriodBand.Add('caption', '');
        BandColumns.Add(GetColumn('Name', 'Name', 'desc'));
        PeriodBand.Add('columns', BandColumns);
        GridColumns.Add(PeriodBand);
        //Bands
        BandInfoBuffer.Reset();
        BandInfoBuffer.FindSet();
        repeat
            Clear(PeriodBand);
            Clear(BandColumns);
            PeriodBand.Add('caption', BandInfoBuffer."Header Description");
            ColLine.Reset();
            ColLine.SetRange("Schema Code", RowSchema."Column Schema");
            ColLine.FindFirst();
            repeat
                BandColumns.Add(GetColumn(StrSubstNo(PerformanceMgmt.GetFieldFormat(), BandInfoBuffer."Band No.", ColLine."Column No."), ColLine."Primary Caption", ''));
            until ColLine.Next() = 0;
            PeriodBand.Add('columns', BandColumns);
            GridColumns.Add(PeriodBand);
        until BandInfoBuffer.Next() = 0;
    end;

    local procedure GetColumn(DataField: Text; Caption: Text; CssClass: Text) Col: JsonObject
    begin
        Col.Add('dataField', DataField);
        Col.Add('caption', Caption);
        if CssClass <> '' then
            Col.Add('cssClass', CssClass);
    end;
}