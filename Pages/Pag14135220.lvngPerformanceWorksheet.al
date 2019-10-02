page 14135220 lvngPerformanceWorksheet
{
    PageType = Worksheet;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            grid(Filters)
            {
                GridLayout = Rows;

                field(SchemaName; SchemaName) { ApplicationArea = All; Caption = 'View Name'; ShowCaption = false; }
                field(Dim1Filter; Dim1Filter) { ApplicationArea = All; Caption = 'Dimension 1 Filter'; Editable = false; Visible = Dim1Visible; CaptionClass = '1,3,1'; }
                field(Dim2Filter; Dim2Filter) { ApplicationArea = All; Caption = 'Dimension 2 Filter'; Editable = false; Visible = Dim2Visible; CaptionClass = '1,3,2'; }
                field(Dim3Filter; Dim3Filter) { ApplicationArea = All; Caption = 'Dimension 3 Filter'; Editable = false; Visible = Dim3Visible; CaptionClass = '1,2,3'; }
                field(Dim4Filter; Dim4Filter) { ApplicationArea = All; Caption = 'Dimension 4 Filter'; Editable = false; Visible = Dim4Visible; CaptionClass = '1,2,4'; }
                field(BusinessUnitFilter; BusinessUnitFilter) { ApplicationArea = All; Caption = 'Business Unit Filter'; Editable = false; }
            }
            usercontrol(DataGrid; DataGridControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    InitializeDataGrid();
                end;

                trigger CellClick(ColIndex: Integer; RowIndex: Integer)
                begin
                    ProcessCellClick(ColIndex, RowIndex);
                end;
            }
        }
    }

    var
        RowSchema: Record lvngPerformanceRowSchema;
        ColSchema: Record lvngPerformanceColSchema;
        BandSchema: Record lvngPeriodPerfBandSchema;
        Buffer: Record lvngPerformanceValueBuffer temporary;
        TempBandLine: Record lvngPeriodPerfBandSchemaLine temporary;
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
        RowSchemaCode: Code[20];
        BandSchemaCode: Code[20];

    trigger OnOpenPage()
    begin
        RowSchema.Get(RowSchemaCode);
        ColSchema.Get(RowSchema."Column Schema");
        BandSchema.Get(BandSchemaCode);
        CalculateColumns();
    end;

    procedure SetParams(RowSchema: Code[20]; BandSchema: Code[20]; ToDate: Date; Dim1Code: Code[20]; Dim2Code: Code[20]; Dim3Code: Code[20]; Dim4Code: Code[20]; BUCode: Code[20])
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
        AsOfDate := ToDate;
    end;

    local procedure CalculateColumns()
    var
        BandLine: Record lvngPeriodPerfBandSchemaLine;
        AccountingPeriod: Record "Accounting Period";
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
        StartDate: Date;
        EndDate: Date;
        TotalStartDate: Date;
        TotalEndDate: Date;
        Multiplier: Integer;
    begin
        BandLine.Reset();
        BandLine.SetRange("Band Code", ColSchema.Code);
        BandLine.FindSet();
        repeat
            TempBandLine := BandLine;
            TempBandLine.Insert();
            case BandLine."Band Type" of
                BandLine."Band Type"::lvngNormal:
                    begin
                        case BandLine."Period Type" of
                            BandLine."Period Type"::lvngMTD:
                                begin
                                    StartDate := CalcDate('<-CM>', AsOfDate);
                                    if BandLine."Period Offset" <> 0 then
                                        StartDate := CalcDate(StrSubstNo('<%1M>', BandLine."Period Offset"), StartDate);
                                    EndDate := CalcDate('<CM>', StartDate);
                                    TempBandLine."Date From" := StartDate;
                                    TempBandLine."Date To" := EndDate;
                                    if TempBandLine."Dynamic Date Description" then
                                        TempBandLine."Header Description" := Format(StartDate, 0, '<Month Text,3>-<Year4>');
                                    TempBandLine.Modify();
                                end;
                            BandLine."Period Type"::lvngQTD:
                                begin
                                    StartDate := CalcDate('<-CQ>', AsOfDate);
                                    if BandLine."Period Offset" <> 0 then begin
                                        StartDate := CalcDate(StrSubstNo('<%1Q>', BandLine."Period Offset"), StartDate);
                                        if Format(BandLine."Period Length Formula") = '' then
                                            EndDate := CalcDate('<CQ>', AsOfDate)
                                        else
                                            EndDate := CalcDate(BandLine."Period Length Formula", StartDate);
                                    end else begin
                                        if Format(BandLine."Period Length Formula") = '' then
                                            EndDate := AsOfDate
                                        else
                                            EndDate := CalcDate(BandLine."Period Length Formula", StartDate);
                                    end;
                                    TempBandLine."Date From" := StartDate;
                                    TempBandLine."Date To" := EndDate;
                                    if TempBandLine."Dynamic Date Description" then
                                        TempBandLine."Header Description" := Format(StartDate, 0, 'Qtr. <Quarter>, <Year4>');
                                    TempBandLine.Modify();
                                end;
                            BandLine."Period Type"::lvngYTD:
                                begin
                                    StartDate := CalcDate('<-CY>', AsOfDate);
                                    if BandLine."Period Offset" <> 0 then begin
                                        StartDate := CalcDate(StrSubstNo('<%1Y>', BandLine."Period Offset"), StartDate);
                                        EndDate := CalcDate('<CY>', StartDate);
                                    end else
                                        EndDate := AsOfDate;
                                    TempBandLine."Date From" := StartDate;
                                    TempBandLine."Date To" := EndDate;
                                    if TempBandLine."Dynamic Date Description" then
                                        TempBandLine."Header Description" := Format(StartDate, 0, 'Year <Year4>');
                                    TempBandLine.Modify();
                                end;
                            BandLine."Period Type"::lvngFiscalQTD:
                                begin
                                    AccountingPeriod.Reset();
                                    AccountingPeriod.SetRange("Starting Date", 0D, AsOfDate);
                                    AccountingPeriod.SetRange(lvngFiscalQuarter, true);
                                    AccountingPeriod.FindLast();
                                    StartDate := AccountingPeriod."Starting Date";
                                    if BandLine."Period Offset" <> 0 then begin
                                        Multiplier := 3 * BandLine."Period Offset";
                                        StartDate := CalcDate(StrSubstNo('<%1M>', Multiplier), StartDate);
                                        if Format(BandLine."Period Length Formula") = '' then begin
                                            AccountingPeriod.SetFilter("Starting Date", '>%1', StartDate);
                                            AccountingPeriod.FindFirst();
                                            EndDate := AccountingPeriod."Starting Date" - 1;
                                        end else
                                            EndDate := CalcDate(BandLine."Period Length Formula", StartDate);
                                    end else
                                        if Format(BandLine."Period Length Formula") = '' then
                                            EndDate := AsOfDate
                                        else
                                            EndDate := CalcDate(BandLine."Period Length Formula", StartDate);
                                    TempBandLine."Date From" := StartDate;
                                    TempBandLine."Date To" := EndDate;
                                    if TempBandLine."Dynamic Date Description" then
                                        if TempBandLine."Header Description" = '' then
                                            TempBandLine."Header Description" := Format(StartDate, 0, '<Month,2>/<Day,2>/<Year4>') + ' to ' + Format(EndDate, 0, '<Month,2>/<Day,2>/<Year4>')
                                        else
                                            TempBandLine."Header Description" := Format(StartDate, 0, TempBandLine."Header Description");
                                    TempBandLine.Modify();
                                end;
                            BandLine."Period Type"::lvngFiscalYTD:
                                begin
                                    AccountingPeriod.Reset();
                                    AccountingPeriod.SetRange("New Fiscal Year", true);
                                    AccountingPeriod.SetRange("Starting Date", 0D, AsOfDate);
                                    if AccountingPeriod.FindLast() then
                                        StartDate := AccountingPeriod."Starting Date"
                                    else begin
                                        AccountingPeriod.Reset();
                                        AccountingPeriod.FindFirst();
                                        StartDate := AccountingPeriod."Starting Date";
                                    end;
                                    if BandLine."Period Offset" <> 0 then begin
                                        StartDate := CalcDate(StrSubstNo('<%1Y>', BandLine."Period Offset"), StartDate);
                                        if Format(BandLine."Period Length Formula") = '' then begin
                                            EndDate := CalcDate('<-1Y>', AsOfDate);
                                            EndDate := CalcDate('<CM>', EndDate);
                                        end else
                                            EndDate := CalcDate(BandLine."Period Length Formula", StartDate);
                                    end else
                                        EndDate := AsOfDate;
                                    TempBandLine."Date From" := StartDate;
                                    TempBandLine."Date To" := EndDate;
                                    if TempBandLine."Dynamic Date Description" then
                                        if TempBandLine."Header Description" = '' then
                                            TempBandLine."Header Description" := Format(StartDate, 0, '<Year4>/<Month>') + ' to ' + Format(EndDate, 0, '<Year4>/<Month>')
                                        else
                                            TempBandLine."Header Description" := Format(EndDate, 0, TempBandLine."Header Description");
                                    TempBandLine.Modify();
                                end;
                            BandLine."Period Type"::lvngLifeToDate:
                                begin
                                    StartDate := 00010101D;
                                    EndDate := AsOfDate;
                                    if Format(BandLine."Period Length Formula") <> '' then
                                        EndDate := CalcDate(BandLine."Period Length Formula", EndDate);
                                    EndDate := CalcDate('<CM>', EndDate);
                                    if BandLine."Header Description" <> '' then
                                        TempBandLine."Header Description" := BandLine."Header Description" + ' ';
                                    TempBandLine."Header Description" := TempBandLine."Header Description" + Format(EndDate, 0, '<Month Text>/<Year4>');
                                    TempBandLine."Date From" := StartDate;
                                    TempBandLine."Date To" := EndDate;
                                    TempBandLine.Modify();
                                end;
                            BandLine."Period Type"::lvngCustomDateFilter:
                                begin
                                    TempBandLine.TestField("Date From");
                                    TempBandLine.TestField("Date To");
                                    if TempBandLine."Header Description" = '' then
                                        TempBandLine."Header Description" := Format(TempBandLine."Date From") + '..' + Format(TempBandLine."Date To");
                                    TempBandLine.Modify();
                                end;
                        end;
                        if (TotalStartDate = 0D) and (TotalEndDate = 0D) then begin
                            TotalStartDate := TempBandLine."Date From";
                            TotalEndDate := TempBandLine."Date To";
                        end else begin
                            if TempBandLine."Date From" < TotalStartDate then
                                TotalStartDate := TempBandLine."Date From";
                            if TempBandLine."Date To" > TotalEndDate then
                                TotalEndDate := TempBandLine."Date To";
                        end;
                    end;
                BandLine."Band Type"::lvngTotals:
                    begin
                        TempBandLine."Date From" := TotalStartDate;
                        TempBandLine."Date To" := TotalEndDate;
                        if TempBandLine."Header Description" = '' then
                            TempBandLine."Header Description" := Format(TempBandLine."Date From") + '..' + Format(TempBandLine."Date To");
                        TempBandLine.Modify();
                    end;
                BandLine."Band Type"::lvngFormula:
                    Error('Not Implemented');
            end;
        until BandLine.Next() = 0;

        TempBandLine.Reset();
        TempBandLine.FindSet();
        repeat
            Clear(SystemFilter);
            SystemFilter."Date From" := TempBandLine."Date From";
            SystemFilter."Date To" := TempBandLine."Date To";
            SystemFilter."Shortcut Dimension 1" := Dim1Filter;
            SystemFilter."Shortcut Dimension 2" := Dim2Filter;
            SystemFilter."Shortcut Dimension 3" := Dim3Filter;
            SystemFilter."Shortcut Dimension 4" := Dim4Filter;
            SystemFilter."Business Unit" := BusinessUnitFilter;
            Clear(PerformanceMgmt);
            PerformanceMgmt.CalculatePeriod(Buffer, TempBandLine, RowSchema, ColSchema, SystemFilter);
        until TempBandLine.Next() = 0;
    end;

    local procedure InitializeDataGrid()
    var
        Json: JsonObject;
        Setting: JsonObject;
    begin
        SetupGridStyles();
        //Json.Add('dataSource', GetData());
        Json.Add('columns', GetColumns());
        Setting.Add('enabled', false);
        Json.Add('paging', Setting);
        Clear(Setting);
        Setting.Add('mode', 'none');
        Json.Add('sorting', Setting);
        Json.Add('columnAuthoWidth', true);
        CurrPage.DataGrid.InitializeDXGrid(Json);
    end;

    local procedure ProcessCellClick(ColIndex: Integer; RowIndex: Integer)
    begin
        Error('Not Implemented');
    end;

    local procedure GetData() DataSource: JsonArray
    begin
        Error('Not Implemented');
    end;

    local procedure GetColumns() GridColumns: JsonArray
    var
        ColLine: Record lvngPerformanceColSchemaLine;
        PeriodBand: JsonObject;
        BandColumns: JsonArray;
        ColIdx: Integer;
    begin
        //Name Column
        Clear(PeriodBand);
        Clear(BandColumns);
        PeriodBand.Add('caption', '');
        BandColumns.Add(GetColumn('Name', 'Name', 'desc'));
        PeriodBand.Add('columns', BandColumns);
        GridColumns.Add(PeriodBand);
        //Period bands
        TempBandLine.Reset();
        TempBandLine.FindSet();
        repeat
            Clear(PeriodBand);
            Clear(BandColumns);
            PeriodBand.Add('caption', TempBandLine."Header Description");
            ColLine.Reset();
            ColLine.SetRange("Schema Code", RowSchema."Column Schema");
            ColLine.FindFirst();
            repeat
                ColIdx += 1;
                BandColumns.Add(GetColumn('v' + Format(ColIdx), ColLine."Primary Caption", ''));
            until ColLine.Next() = 0;
            PeriodBand.Add('columns', BandColumns);
            GridColumns.Add(PeriodBand);
        until TempBandLine.Next() = 0;
    end;

    local procedure GetColumn(DataField: Text; Caption: Text; CssClass: Text) Col: JsonObject
    begin
        Col.Add('dataField', DataField);
        Col.Add('caption', Caption);
        if CssClass <> '' then
            Col.Add('cssClass', CssClass);
    end;

    local procedure SetupGridStyles()
    var
        Json: JsonObject;
        CssClass: JsonObject;
    begin
        Clear(CssClass);
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('font-style', 'italic');
        CssClass.Add('font-size', '14px');
        CssClass.Add('text-decoration', 'underline');
        CssClass.Add('text-align', 'center !important');
        CssClass.Add('border-left', 'none !important');
        CssClass.Add('border-right', 'none !important');
        Json.Add('.dx-header-row td', CssClass);
        Clear(CssClass);
        CssClass.Add('text-align', 'center');
        CssClass.Add('font-style', 'italic');
        CssClass.Add('text-decoration', 'underline');
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('color', '#959595');
        Json.Add('tr.secondary-header', CssClass);
        Clear(CssClass);
        CssClass.Add('border', '1px solid #ddd');
        Json.Add('tr.secondary-header td', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '12px');
        CssClass.Add('text-align', 'right');
        Json.Add('.dx-data-row', CssClass);
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
        CssClass.Add('color', 'red');
        Json.Add('.red', CssClass);
        Clear(CssClass);
        CssClass.Add('font-weight', 'bold');
        Json.Add('.bold', CssClass);
        Clear(CssClass);
        CssClass.Add('font-style', 'italic');
        Json.Add('.italic', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '14px');
        Json.Add('.big', CssClass);
        Clear(CssClass);
        CssClass.Add('color', 'blue');
        Json.Add('.font-blue', CssClass);
        Clear(CssClass);
        CssClass.Add('background-color', '#CCFFCC');
        Json.Add('.background-honeydew', CssClass);
        Clear(CssClass);
        CssClass.Add('background-color', '#99CCFF');
        Json.Add('.background-columbia-blue', CssClass);
        Clear(CssClass);
        CssClass.Add('border-bottom', '1px solid #808080');
        Json.Add('.border-bottom-thin td', CssClass);
        Clear(CssClass);
        CssClass.Add('border-bottom', '3px solid #808080');
        Json.Add('.border-bottom-thick td', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '2px');
        CssClass.Add('line-height', '1');
        Json.Add('td.third-size', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '16px');
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('font-style', 'italic');
        CssClass.Add('border-top', '3px double #000');
        CssClass.Add('border-bottom', '3px double #000');
        CssClass.Add('background-color', '#C0C0C0');
        Json.Add('.heading td', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '12px');
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('border-top', '1px solid #000');
        CssClass.Add('border-bottom', 'solid #000');
        Json.Add('.subtotals td', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '12px');
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('border-top', '1px solid #000');
        CssClass.Add('border-bottom', 'double #000');
        Json.Add('.totals td', CssClass);
        Clear(CssClass);
        CssClass.Add('padding-left', '15px !important');
        Json.Add('.indent1 td:first-child', CssClass);
        Clear(CssClass);
        CssClass.Add('padding-left', '25px !important');
        Json.Add('.indent2 td:first-child', CssClass);
        Clear(CssClass);
        CssClass.Add('padding-left', '35px !important');
        Json.Add('.ident3 td:first-child', CssClass);
        CurrPage.DataGrid.SetupStyles(Json);
    end;
}