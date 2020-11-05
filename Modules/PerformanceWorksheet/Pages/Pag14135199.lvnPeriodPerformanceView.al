page 14135199 "lvnPeriodPerformanceView"
{
    PageType = Card;
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
                field(AsOfDate; SystemFilter."As Of Date")
                {
                    ApplicationArea = All;
                    Caption = 'As Of Date';
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
        PerformanceMgmt.CalculatePeriodsData(RowSchema, BandSchema, SystemFilter, BandInfoBuffer, ValueBuffer);
    end;

    var
        RowSchema: Record lvnPerformanceRowSchema;
        BandSchema: Record lvnPeriodPerfBandSchema;
        ColSchema: Record lvnPerformanceColSchema;
        BandInfoBuffer: Record lvnPerformanceBandLineInfo temporary;
        ValueBuffer: Record lvnPerformanceValueBuffer temporary;
        SystemFilter: Record lvnSystemCalculationFilter temporary;
        PerformanceMgmt: Codeunit lvnPerformanceMgmt;
        GridExportMode: Enum lvnGridExportMode;
        Dim1Visible: Boolean;
        Dim2Visible: Boolean;
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;
        BusinessUnitVisible: Boolean;
        SchemaNameFormatTxt: Label '%1 - %2';

    procedure SetParams(
        RowSchemaCode: Code[20];
        BandSchemaCode: Code[20];
        var Filter: Record lvnSystemCalculationFilter)
    begin
        RowSchema.Get(RowSchemaCode);
        BandSchema.Get(BandSchemaCode);
        SystemFilter := Filter;
        if SystemFilter."As Of Date" = 0D then
            SystemFilter."As Of Date" := Today;
        SystemFilter.Description := StrSubstNo(SchemaNameFormatTxt, RowSchema.Description, BandSchema.Description);
        BusinessUnitVisible := SystemFilter."Business Unit" <> '';
        Dim1Visible := SystemFilter."Global Dimension 1" <> '';
        Dim2Visible := SystemFilter."Global Dimension 2" <> '';
        Dim3Visible := SystemFilter."Shortcut Dimension 3" <> '';
        Dim4Visible := SystemFilter."Shortcut Dimension 4" <> '';
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
        RowLine: Record lvnPerformanceRowSchemaLine;
        CalcUnit: Record lvnCalculationUnit;
        Loan: Record lvnLoan;
        GLEntry: Record "G/L Entry";
        BandLine: Record lvnPeriodPerfBandSchemaLine;
        LoanList: Page lvnLoanList;
        GLEntries: Page lvnPerformanceGLEntries;
    begin
        BandLine.Get(BandSchema.Code, BandIndex);
        if BandLine."Band Type" = BandLine."Band Type"::Normal then begin
            RowLine.Get(RowSchema.Code, RowIndex, ColIndex);
            CalcUnit.Get(RowLine."Calculation Unit Code");
            case CalcUnit."Lookup Source" of
                CalcUnit."Lookup Source"::"Loan Card":
                    begin
                        Loan.Reset();
                        PerformanceMgmt.ApplyLoanFilter(Loan, CalcUnit, SystemFilter);
                        LoanList.SetTableView(Loan);
                        LoanList.RunModal();
                    end;
                CalcUnit."Lookup Source"::"Ledger Entries":
                    begin
                        GLEntry.Reset();
                        PerformanceMgmt.ApplyGLFilter(GLEntry, CalcUnit, SystemFilter);
                        GLEntries.SetTableView(GLEntry);
                        GLEntries.RunModal();
                    end;
            end;
        end;
    end;

    local procedure ExportToExcel(GridExportMode: Enum lvnGridExportMode)
    var
        HeaderData: Record lvnSystemCalculationFilter temporary;
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
        ExcelExport.Init('PerformanceWorksheet', GridExportMode);
        PerformanceDataExport.ExportToExcel(ExcelExport, RowSchema, ValueBuffer, HeaderData, BandInfoBuffer);
        ExcelExport.Download(PerformanceDataExport.GetExportFileName(GridExportMode, RowSchema."Schema Type"));
    end;

    local procedure GetColumns() GridColumns: JsonArray
    var
        ColLine: Record lvnPerformanceColSchemaLine;
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