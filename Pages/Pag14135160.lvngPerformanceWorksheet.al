page 14135160 lvngPerformanceWorksheet
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
        RowSchema: Record lvngRowPerformanceSchema;
        ColSchema: Record lvngPeriodPerformanceLayout;
        GroupSchema: Record lvngPerformanceColumnGroup;
        Buffer: Record lvngPerformanceValueBuffer temporary;
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
        ColSchemaCode: Code[20];
        ColGroupSchemaCode: Code[20];

    trigger OnOpenPage()
    begin
        RowSchema.Get(RowSchemaCode);
        ColSchema.Get(ColSchemaCode);
        GroupSchema.Get(ColGroupSchemaCode);
        CalculateColumns();
    end;

    procedure SetParams(_ReportingType: Integer; _Filter: Code[20]; _ToDate: Date)
    begin
        BusinessUnitFilter := '';
        Dim1Filter := '';
        Dim2Filter := '';
        Dim3Filter := '';
        Dim4Filter := '';
        BusinessUnitVisible := false;
        Dim1Visible := false;
        Dim2Visible := false;
        Dim3Visible := false;
        Dim4Visible := false;
        case _ReportingType of
            0:
                begin
                    BusinessUnitFilter := _Filter;
                    BusinessUnitVisible := true;
                end;
            1:
                begin
                    Dim1Filter := _Filter;
                    Dim1Visible := true;
                end;
            2:
                begin
                    Dim2Filter := _Filter;
                    Dim2Visible := true;
                end;
            3:
                begin
                    Dim3Filter := _Filter;
                    Dim3Visible := true;
                end;
            4:
                begin
                    Dim4Filter := _Filter;
                    Dim4Visible := true;
                end;
        end;
        AsOfDate := _ToDate;
    end;

    procedure SetSchemaCode(_RowSchemaCode: Code[20]; _ColSchemaCode: Code[20]; _ColGroupSchemaCode: Code[20])
    begin
        RowSchemaCode := _RowSchemaCode;
        ColSchemaCode := _ColSchemaCode;
        ColGroupSchemaCode := _ColGroupSchemaCode;
    end;

    local procedure CalculateColumns()
    var
        ColumnLayout: Record lvngPeriodPerfLayoutColumn;
        TempColumnLayout: Record lvngPeriodPerfLayoutColumn temporary;
        AccountingPeriod: Record "Accounting Period";
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
        StartDate: Date;
        EndDate: Date;
        Multiplier: Integer;
    begin
        ColumnLayout.Reset();
        ColumnLayout.SetRange("Layout Code", ColSchema.Code);
        ColumnLayout.FindSet();
        repeat
            TempColumnLayout := ColumnLayout;
            TempColumnLayout.Insert();
            case ColumnLayout."Period Type" of
                ColumnLayout."Period Type"::MTD:
                    begin
                        StartDate := CalcDate('<-CM>', AsOfDate);
                        if ColumnLayout."Period Offset" <> 0 then
                            StartDate := CalcDate(StrSubstNo('<%1M>', ColumnLayout."Period Offset"), StartDate);
                        EndDate := CalcDate('<CM>', StartDate);
                        TempColumnLayout."Date From" := StartDate;
                        TempColumnLayout."Date To" := EndDate;
                        if TempColumnLayout."Dynamic Date Description" then
                            TempColumnLayout."Header Description" := Format(StartDate, 0, '<Month Text,3>-<Year4>');
                        TempColumnLayout.Modify();
                    end;
                ColumnLayout."Period Type"::QTD:
                    begin
                        StartDate := CalcDate('<-CQ>', AsOfDate);
                        if ColumnLayout."Period Offset" <> 0 then begin
                            StartDate := CalcDate(StrSubstNo('<%1Q>', ColumnLayout."Period Offset"), StartDate);
                            if Format(ColumnLayout."Period Length Formula") = '' then
                                EndDate := CalcDate('<CQ>', AsOfDate)
                            else
                                EndDate := CalcDate(ColumnLayout."Period Length Formula", StartDate);
                        end else begin
                            if Format(ColumnLayout."Period Length Formula") = '' then
                                EndDate := AsOfDate
                            else
                                EndDate := CalcDate(ColumnLayout."Period Length Formula", StartDate);
                        end;
                        TempColumnLayout."Date From" := StartDate;
                        TempColumnLayout."Date To" := EndDate;
                        if TempColumnLayout."Dynamic Date Description" then
                            TempColumnLayout."Header Description" := Format(StartDate, 0, 'Qtr. <Quarter>, <Year4>');
                        TempColumnLayout.Modify();
                    end;
                ColumnLayout."Period Type"::YTD:
                    begin
                        StartDate := CalcDate('<-CY>', AsOfDate);
                        if ColumnLayout."Period Offset" <> 0 then begin
                            StartDate := CalcDate(StrSubstNo('<%1Y>', ColumnLayout."Period Offset"), StartDate);
                            EndDate := CalcDate('<CY>', StartDate);
                        end else
                            EndDate := AsOfDate;
                        TempColumnLayout."Date From" := StartDate;
                        TempColumnLayout."Date To" := EndDate;
                        if TempColumnLayout."Dynamic Date Description" then
                            TempColumnLayout."Header Description" := Format(StartDate, 0, 'Year <Year4>');
                        TempColumnLayout.Modify();
                    end;
                ColumnLayout."Period Type"::"Fiscal QTD":
                    begin
                        AccountingPeriod.Reset();
                        AccountingPeriod.SetRange("Starting Date", 0D, AsOfDate);
                        AccountingPeriod.SetRange(lvngFiscalQuarter, true);
                        AccountingPeriod.FindLast();
                        StartDate := AccountingPeriod."Starting Date";
                        if ColumnLayout."Period Offset" <> 0 then begin
                            Multiplier := 3 * ColumnLayout."Period Offset";
                            StartDate := CalcDate(StrSubstNo('<%1M>', Multiplier), StartDate);
                            if Format(ColumnLayout."Period Length Formula") = '' then begin
                                AccountingPeriod.SetFilter("Starting Date", '>%1', StartDate);
                                AccountingPeriod.FindFirst();
                                EndDate := AccountingPeriod."Starting Date" - 1;
                            end else
                                EndDate := CalcDate(ColumnLayout."Period Length Formula", StartDate);
                        end else
                            if Format(ColumnLayout."Period Length Formula") = '' then
                                EndDate := AsOfDate
                            else
                                EndDate := CalcDate(ColumnLayout."Period Length Formula", StartDate);
                        TempColumnLayout."Date From" := StartDate;
                        TempColumnLayout."Date To" := EndDate;
                        if TempColumnLayout."Dynamic Date Description" then
                            if TempColumnLayout."Header Description" = '' then
                                TempColumnLayout."Header Description" := Format(StartDate, 0, '<Month,2>/<Day,2>/<Year4>') + ' to ' + Format(EndDate, 0, '<Month,2>/<Day,2>/<Year4>')
                            else
                                TempColumnLayout."Header Description" := Format(StartDate, 0, TempColumnLayout."Header Description");
                        TempColumnLayout.Modify();
                    end;
                ColumnLayout."Period Type"::"Fiscal YTD":
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
                        if ColumnLayout."Period Offset" <> 0 then begin
                            StartDate := CalcDate(StrSubstNo('<%1Y>', ColumnLayout."Period Offset"), StartDate);
                            if Format(ColumnLayout."Period Length Formula") = '' then begin
                                EndDate := CalcDate('<-1Y>', AsOfDate);
                                EndDate := CalcDate('<CM>', EndDate);
                            end else
                                EndDate := CalcDate(ColumnLayout."Period Length Formula", StartDate);
                        end else
                            EndDate := AsOfDate;
                        TempColumnLayout."Date From" := StartDate;
                        TempColumnLayout."Date To" := EndDate;
                        if TempColumnLayout."Dynamic Date Description" then
                            if TempColumnLayout."Header Description" = '' then
                                TempColumnLayout."Header Description" := Format(StartDate, 0, '<Year4>/<Month>') + ' to ' + Format(EndDate, 0, '<Year4>/<Month>')
                            else
                                TempColumnLayout."Header Description" := Format(EndDate, 0, TempColumnLayout."Header Description");
                        TempColumnLayout.Modify();
                    end;
                ColumnLayout."Period Type"::"Life to Date":
                    begin
                        StartDate := 00010101D;
                        EndDate := AsOfDate;
                        if Format(ColumnLayout."Period Length Formula") <> '' then
                            EndDate := CalcDate(ColumnLayout."Period Length Formula", EndDate);
                        EndDate := CalcDate('<CM>', EndDate);
                        if ColumnLayout."Header Description" <> '' then
                            TempColumnLayout."Header Description" := ColumnLayout."Header Description" + ' ';
                        TempColumnLayout."Header Description" := TempColumnLayout."Header Description" + Format(EndDate, 0, '<Month Text>/<Year4>');
                        TempColumnLayout."Date From" := StartDate;
                        TempColumnLayout."Date To" := EndDate;
                        TempColumnLayout.Modify();
                    end;
                ColumnLayout."Period Type"::"Custom Date Filter":
                    begin
                        TempColumnLayout.TestField("Date From");
                        TempColumnLayout.TestField("Date To");
                        if TempColumnLayout."Header Description" = '' then
                            TempColumnLayout."Header Description" := Format(TempColumnLayout."Date From") + '..' + Format(TempColumnLayout."Date To");
                        TempColumnLayout.Modify();
                    end;
            end;
        until ColumnLayout.Next() = 0;

        TempColumnLayout.Reset();
        TempColumnLayout.FindSet();
        repeat
            Clear(SystemFilter);
            SystemFilter."Date From" := TempColumnLayout."Date From";
            SystemFilter."Date To" := TempColumnLayout."Date To";
            SystemFilter."Shortcut Dimension 1" := Dim1Filter;
            SystemFilter."Shortcut Dimension 2" := Dim2Filter;
            SystemFilter."Shortcut Dimension 3" := Dim3Filter;
            SystemFilter."Shortcut Dimension 4" := Dim4Filter;
            SystemFilter."Business Unit" := BusinessUnitFilter;
            Clear(PerformanceMgmt);
            PerformanceMgmt.CalculatePeriod(Buffer, GroupSchema, RowSchema, SystemFilter);
        until TempColumnLayout.Next() = 0;
    end;

    local procedure InitializeDataGrid()
    var
        Json: JsonObject;
        Setting: JsonObject;
    begin
        SetupGridStyles();
        Json.Add('dataSource', GetData());
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

    local procedure GetColumns() Columns: JsonArray
    var
        ColGroup: JsonObject;
    begin
        ColGroup.Add('caption', '');
        ColGroup.Add('columns', GetColumn('Name', 'Name', 'desc'));
        Columns.Add(ColGroup);
        Clear(ColGroup);



        Error('Not Implemented');
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