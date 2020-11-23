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
                field(SchemaName; TempSystemCalcFilter.Description)
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
                field(AsOfDate; TempSystemCalcFilter."As Of Date")
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
            action(XlsExport)
            {
                ApplicationArea = All;
                Caption = 'Excel Export';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

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
                PromotedOnly = true;

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
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::Html);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        PerformanceMgmt.CalculatePeriodsData(RowSchema, BandSchema, TempSystemCalcFilter, TempBandInfoBuffer, TempValueBuffer);
    end;

    var
        RowSchema: Record lvnPerformanceRowSchema;
        BandSchema: Record lvnPeriodPerfBandSchema;
        TempBandInfoBuffer: Record lvnPerformanceBandLineInfo temporary;
        TempValueBuffer: Record lvnPerformanceValueBuffer temporary;
        TempSystemCalcFilter: Record lvnSystemCalculationFilter temporary;
        PerformanceMgmt: Codeunit lvnPerformanceMgmt;
        GridExportMode: Enum lvnGridExportMode;
        Dim1Visible: Boolean;
        Dim2Visible: Boolean;
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;
        BusinessUnitVisible: Boolean;
        SchemaNameFormatTxt: Label '%1 - %2', Comment = '%1 - Row Schema Description; %2 - Band Schema Description';

    procedure SetParams(
        RowSchemaCode: Code[20];
        BandSchemaCode: Code[20];
        var Filter: Record lvnSystemCalculationFilter)
    begin
        RowSchema.Get(RowSchemaCode);
        BandSchema.Get(BandSchemaCode);
        TempSystemCalcFilter := Filter;
        if TempSystemCalcFilter."As Of Date" = 0D then
            TempSystemCalcFilter."As Of Date" := Today;
        TempSystemCalcFilter.Description := StrSubstNo(SchemaNameFormatTxt, RowSchema.Description, BandSchema.Description);
        BusinessUnitVisible := TempSystemCalcFilter."Business Unit" <> '';
        Dim1Visible := TempSystemCalcFilter."Global Dimension 1" <> '';
        Dim2Visible := TempSystemCalcFilter."Global Dimension 2" <> '';
        Dim3Visible := TempSystemCalcFilter."Shortcut Dimension 3" <> '';
        Dim4Visible := TempSystemCalcFilter."Shortcut Dimension 4" <> '';
    end;

    local procedure InitializeDataGrid()
    var
        Json: JsonObject;
        Setting: JsonObject;
        StylesInUse: Dictionary of [Code[20], Boolean];
    begin
        Json.Add('columns', GetColumns());
        Json.Add('dataSource', PerformanceMgmt.GetData(TempValueBuffer, StylesInUse, RowSchema.Code, RowSchema."Column Schema"));
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
                        PerformanceMgmt.ApplyLoanFilter(Loan, CalcUnit, TempSystemCalcFilter);
                        LoanList.SetTableView(Loan);
                        LoanList.RunModal();
                    end;
                CalcUnit."Lookup Source"::"Ledger Entries":
                    begin
                        GLEntry.Reset();
                        PerformanceMgmt.ApplyGLFilter(GLEntry, CalcUnit, TempSystemCalcFilter);
                        GLEntries.SetTableView(GLEntry);
                        GLEntries.RunModal();
                    end;
            end;
        end;
    end;

    local procedure ExportToExcel(GridExportMode: Enum lvnGridExportMode)
    var
        TempHeaderData: Record lvnSystemCalculationFilter temporary;
        PerformanceDataExport: Codeunit lvnPerformanceDataExport;
        ExcelExport: Codeunit lvnExcelExport;
    begin
        Clear(TempHeaderData);
        TempHeaderData.Description := TempSystemCalcFilter.Description;
        TempHeaderData."Global Dimension 1" := TempSystemCalcFilter."Global Dimension 1";
        TempHeaderData."Global Dimension 2" := TempSystemCalcFilter."Global Dimension 2";
        TempHeaderData."Shortcut Dimension 3" := TempSystemCalcFilter."Shortcut Dimension 3";
        TempHeaderData."Shortcut Dimension 4" := TempSystemCalcFilter."Shortcut Dimension 4";
        TempHeaderData."Business Unit" := TempSystemCalcFilter."Business Unit";
        ExcelExport.Init('PerformanceWorksheet', GridExportMode);
        PerformanceDataExport.ExportToExcel(ExcelExport, RowSchema, TempValueBuffer, TempHeaderData, TempBandInfoBuffer);
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
        TempBandInfoBuffer.Reset();
        TempBandInfoBuffer.FindSet();
        repeat
            Clear(PeriodBand);
            Clear(BandColumns);
            PeriodBand.Add('caption', TempBandInfoBuffer."Header Description");
            ColLine.Reset();
            ColLine.SetRange("Schema Code", RowSchema."Column Schema");
            ColLine.FindSet();
            repeat
                BandColumns.Add(GetColumn(StrSubstNo(PerformanceMgmt.GetFieldFormat(), TempBandInfoBuffer."Band No.", ColLine."Column No."), ColLine."Primary Caption", ''));
            until ColLine.Next() = 0;
            PeriodBand.Add('columns', BandColumns);
            GridColumns.Add(PeriodBand);
        until TempBandInfoBuffer.Next() = 0;
    end;

    local procedure GetColumn(DataField: Text; Caption: Text; CssClass: Text) Col: JsonObject
    begin
        Col.Add('dataField', DataField);
        Col.Add('caption', Caption);
        if CssClass <> '' then
            Col.Add('cssClass', CssClass);
    end;
}