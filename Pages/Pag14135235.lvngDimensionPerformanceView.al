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
        ColSchema: Record lvngPerformanceColSchema;
        BandSchema: Record lvngDimensionPerfBandSchema;
        TempBandLine: Record lvngDimPerfBandSchemaLine temporary;
        Buffer: Record lvngPerformanceValueBuffer temporary;
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
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
        RowSchemaCode: Code[20];
        BandSchemaCode: Code[20];
        StylesInUse: Dictionary of [Code[20], Boolean];
        GridExportMode: Enum lvngGridExportMode;
        SchemaNameFormatTxt: Label '%1 - %2';

    trigger OnOpenPage()
    begin
        RowSchema.Get(RowSchemaCode);
        ColSchema.Get(RowSchema."Column Schema");
        BandSchema.Get(BandSchemaCode);
        SchemaName := StrSubstNo(SchemaNameFormatTxt, RowSchema.Description, BandSchema.Description);
        CalculateColumns();
    end;

    procedure SetParams(RowSchema: Code[20]; BandSchema: Code[20]; DateRange: Text; Dim1Code: Code[20]; Dim2Code: Code[20]; Dim3Code: Code[20]; Dim4Code: Code[20]; BUCode: Code[20])
    begin
        RowSchemaCode := RowSchema;
        BandSchemaCode := BandSchema;
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
            repeat
                Clear(TempBandLine);
                TempBandLine := BandLine;
                TempBandLine.Insert();
            until BandLine.Next() = 0;
        end;

        TempBandLine.Reset();
        TempBandLine.SetRange("Schema Code", BandSchema.Code);
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::lvngNormal);
        TempBandLine.FindSet();
        repeat
            Clear(SystemFilter);
            SystemFilter."Date Filter" := DateFilter;
            SystemFilter."Shortcut Dimension 1" := Dim1Filter;
            SystemFilter."Shortcut Dimension 2" := Dim2Filter;
            SystemFilter."Shortcut Dimension 3" := Dim3Filter;
            SystemFilter."Shortcut Dimension 4" := Dim4Filter;
            SystemFilter."Business Unit" := BusinessUnitFilter;
            ApplyColumnFilter(SystemFilter, TempBandLine."Dimension Filter");
            PerformanceMgmt.CalculatePerformanceBand(Buffer, TempBandLine."Band No.", TempBandLine."Band Type", RowSchema, ColSchema, SystemFilter);
        until TempBandLine.Next() = 0;
        TempBandLine.Reset();
        TempBandLine.SetRange("Schema Code", BandSchema.Code);
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::lvngTotals);
        if not TempBandLine.IsEmpty() then
            Error('Not Implemented');

        TempBandLine.Reset();
        TempBandLine.SetRange("Schema Code", BandSchema.Code);
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::lvngFormula);
        if not TempBandLine.IsEmpty() then
            Error('Not Implemented');
    end;

    local procedure ApplyColumnFilter(var SystemFilter: Record lvngSystemCalculationFilter; BandFilter: Text)
    var
        DimensionValue: Record "Dimension Value";
    begin
        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", BandSchema."Dimension Code");
        DimensionValue.SetFilter(Code, BandFilter);
        DimensionValue.FindFirst();
        case DimensionValue."Global Dimension No." of
            1:
                SystemFilter."Shortcut Dimension 1" := BandFilter;
            2:
                SystemFilter."Shortcut Dimension 2" := BandFilter;
            3:
                SystemFilter."Shortcut Dimension 3" := BandFilter;
            4:
                SystemFilter."Shortcut Dimension 4" := BandFilter;
            5:
                SystemFilter."Shortcut Dimension 5" := BandFilter;
            6:
                SystemFilter."Shortcut Dimension 6" := BandFilter;
            7:
                SystemFilter."Shortcut Dimension 7" := BandFilter;
            8:
                SystemFilter."Shortcut Dimension 8" := BandFilter;
        end;
    end;

    local procedure InitializeDataGrid()
    var
        Json: JsonObject;
        Setting: JsonObject;
    begin
        Json.Add('columns', GetColumns());
        Json.Add('dataSource', PerformanceMgmt.GetData(Buffer, StylesInUse, RowSchema.Code, ColSchema.Code));
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
            Clear(SystemFilter);
            SystemFilter."Date Filter" := DateFilter;
            SystemFilter."Shortcut Dimension 1" := Dim1Filter;
            SystemFilter."Shortcut Dimension 2" := Dim2Filter;
            SystemFilter."Shortcut Dimension 3" := Dim3Filter;
            SystemFilter."Shortcut Dimension 4" := Dim4Filter;
            SystemFilter."Business Unit" := BusinessUnitFilter;
            ApplyColumnFilter(SystemFilter, TempBandLine."Dimension Filter");
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

    local procedure ExportToExcel(Mode: Enum lvngGridExportMode)
    begin
        Error('Not Implemented');
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