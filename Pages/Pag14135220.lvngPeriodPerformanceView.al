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
        BandSchema: Record lvngPeriodPerfBandSchema;
        Buffer: Record lvngPerformanceValueBuffer temporary;
        TempBandLine: Record lvngPeriodPerfBandSchemaLine temporary;
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
        ExpressionEngine: Codeunit lvngExpressionEngine;
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
        StylesInUse: Dictionary of [Code[20], Boolean];
        BandIndexLookup: Dictionary of [Integer, Integer];
        GridExportMode: Enum lvngGridExportMode;
        DefaultBoolean: Enum lvngDefaultBoolean;
        CellHorizontalAlignment: Enum lvngCellHorizontalAlignment;
        CellVerticalAlignment: Enum lvngCellVerticalAlignment;
        UnsupportedBandTypeErr: Label 'Band type is not supported: %1';
        SchemaNameFormatTxt: Label '%1 - %2';
        BusinessUnitFilterTxt: Label 'Business Unit Filter';
        NameTxt: Label 'Name';
        IntranslatableRowFormulaErr: Label 'Unable to translate row formula';
        UnsupportedFormulaTypeErr: Label 'Formula type is not supported';

    trigger OnOpenPage()
    begin
        RowSchema.Get(RowSchemaCode);
        ColSchema.Get(RowSchema."Column Schema");
        BandSchema.Get(BandSchemaCode);
        if AsOfDate = 0D then
            AsOfDate := Today;
        SchemaName := StrSubstNo(SchemaNameFormatTxt, RowSchema.Description, BandSchema.Description);
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
        StartDate: Date;
        EndDate: Date;
        TotalStartDate: Date;
        TotalEndDate: Date;
        Multiplier: Integer;
        Idx: Integer;
    begin
        TempBandLine.Reset();
        TempBandLine.DeleteAll();
        Clear(BandIndexLookup);
        Idx := 0;
        BandLine.Reset();
        BandLine.SetRange("Schema Code", BandSchema.Code);
        BandLine.FindSet();
        repeat
            Clear(TempBandLine);
            TempBandLine := BandLine;
            TempBandLine.Insert();
            BandIndexLookup.Add(TempBandLine."Band No.", Idx);
            Idx += 1;
            case BandLine."Band Type" of
                BandLine."Band Type"::lvngNormal,
                BandLine."Band Type"::lvngFormula:  //In case expression formula refers to not cached row formula value it will be calculated as Normal
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
                else
                    Error(UnsupportedBandTypeErr, BandLine);
            end;
        until BandLine.Next() = 0;

        TempBandLine.Reset();
        TempBandLine.SetFilter("Band Type", '<>%1', TempBandLine."Band Type"::lvngFormula);
        TempBandLine.FindSet();
        repeat
            InitalizeSystemFilter(SystemFilter);
            PerformanceMgmt.CalculatePerformanceBand(Buffer, TempBandLine."Band No.", RowSchema, ColSchema, SystemFilter);
        until TempBandLine.Next() = 0;

        TempBandLine.Reset();
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::lvngFormula);
        if TempBandLine.FindSet() then
            repeat
                InitalizeSystemFilter(SystemFilter);
                PerformanceMgmt.CalculateFormulaBand(Buffer, TempBandLine."Band No.", RowSchema, ColSchema, SystemFilter, TempBandLine."Row Formula Code");
            until TempBandLine.Next() = 0;
    end;

    local procedure InitalizeSystemFilter(var SystemFilter: Record lvngSystemCalculationFilter)
    begin
        Clear(SystemFilter);
        SystemFilter."Date Filter" := StrSubstNo('%1..%2', TempBandLine."Date From", TempBandLine."Date To");
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

    local procedure ExportToExcel(Mode: Enum lvngGridExportMode)
    var
        ColLine: Record lvngPerformanceColSchemaLine;
        RowLine: Record lvngPerformanceRowSchemaLine;
        Cell: Record lvngPerformanceRowSchemaLine;
        CalcUnit: Record lvngCalculationUnit;
        ExpressionHeader: Record lvngExpressionHeader;
        ExcelExport: Codeunit lvngExcelExport;
        RowId: Integer;
        ColumnCount: Integer;
        Idx: Integer;
        IncludeRow: Boolean;
        DataColStartIdx: Integer;
        DataRowStartIdx: Integer;
        CurrentDataRowIdx: Integer;
        CurrentDataColIdx: Integer;
    begin
        ExcelExport.Init('PerformanceWorksheet', Mode);
        //Add header
        ExcelExport.NewRow(-10);
        ExcelExport.StyleColumn(DefaultBoolean::lvngTrue, DefaultBoolean::lvngDefault, DefaultBoolean::lvngDefault, -1, '', '', '');
        ExcelExport.StyleRow(DefaultBoolean::lvngTrue, DefaultBoolean::lvngDefault, DefaultBoolean::lvngDefault, 14, '', '', '');
        ExcelExport.BeginRange();
        ExcelExport.WriteString(SchemaName);
        ExcelExport.SkipCells(6);
        ExcelExport.MergeRange(false);
        ExcelExport.NewRow(-20);
        RowId := -30;
        if Dim1Visible then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('3,1,1'));
            ExcelExport.WriteString(Dim1Filter);
        end;
        if Dim2Visible then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('3,1,2'));
            ExcelExport.WriteString(Dim2Filter);
        end;
        if Dim3Visible then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('4,1,3'));
            ExcelExport.WriteString(Dim3Filter);
        end;
        if Dim4Visible then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('4,1,4'));
            ExcelExport.WriteString(Dim4Filter);
        end;
        if BusinessUnitVisible then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(BusinessUnitFilterTxt);
            ExcelExport.WriteString(BusinessUnitFilter);
        end;
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        //Add Grid Band Header
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        ExcelExport.StyleRow(DefaultBoolean::lvngTrue, DefaultBoolean::lvngTrue, DefaultBoolean::lvngTrue, -1, '', '', '');
        ExcelExport.AlignRow(CellHorizontalAlignment::lvngCenter, CellVerticalAlignment::lvngDefault, -1, 0, DefaultBoolean::lvngDefault, DefaultBoolean::lvngDefault);
        ExcelExport.SkipCells(1);
        ColLine.Reset();
        ColLine.SetRange("Schema Code", RowSchema."Column Schema");
        ColumnCount := ColLine.Count();
        TempBandLine.Reset();
        TempBandLine.FindSet();
        repeat
            if ColumnCount > 1 then
                ExcelExport.BeginRange();
            ExcelExport.WriteString(TempBandLine."Header Description");
            if ColumnCount > 2 then
                ExcelExport.SkipCells(ColumnCount - 2);
            if ColumnCount > 1 then
                ExcelExport.MergeRange(true);
        until TempBandLine.Next() = 0;
        //Add Grid Primary Header
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        ExcelExport.StyleRow(DefaultBoolean::lvngTrue, DefaultBoolean::lvngTrue, DefaultBoolean::lvngTrue, -1, '', '', '');
        ExcelExport.AlignRow(CellHorizontalAlignment::lvngCenter, CellVerticalAlignment::lvngDefault, -1, 0, DefaultBoolean::lvngDefault, DefaultBoolean::lvngDefault);
        ExcelExport.WriteString(NameTxt);
        DataRowStartIdx := 1; //Skip Name column
        DataColStartIdx := -RowId div 10; //Skip header columns
        for Idx := 1 to TempBandLine.Count do begin
            ColLine.Reset();
            ColLine.SetRange("Schema Code", RowSchema."Column Schema");
            ColLine.FindSet();
            repeat
                ExcelExport.WriteString(ColLine."Primary Caption");
            until ColLine.Next() = 0;
        end;
        //Add rows
        RowLine.Reset();
        RowLine.SetRange("Schema Code", RowSchema.Code);
        RowLine.SetRange("Column No.", 1);
        RowLine.FindSet();
        CurrentDataRowIdx := -1;
        repeat
            case RowLine."Row Type" of
                RowLine."Row Type"::lvngNormal:
                    begin
                        IncludeRow := true;
                        if RowLine."Hide Zero Line" then begin
                            Buffer.Reset();
                            Buffer.SetRange("Row No.", RowLine."Line No.");
                            Buffer.SetFilter(Value, '<>0');
                            if Buffer.IsEmpty then
                                IncludeRow := false;
                        end;
                        if IncludeRow then begin
                            ExcelExport.NewRow(RowLine."Line No.");
                            CurrentDataRowIdx += 1;
                            CurrentDataColIdx := 0;
                            if RowLine."Row Style" <> '' then
                                ExcelExport.StyleRow(RowLine."Row Style");
                            ExcelExport.WriteString(RowLine.Description);
                            TempBandLine.Reset();
                            TempBandLine.FindSet();
                            repeat
                                Cell.Reset();
                                Cell.SetRange("Schema Code", RowSchema."Column Schema");
                                Cell.SetRange("Line No.", RowLine."Line No.");
                                Cell.FindSet();
                                repeat
                                    if not CalcUnit.Get(Cell."Calculation Unit Code") then
                                        ExcelExport.WriteDecimal(0)
                                    else
                                        if (CalcUnit.Type <> CalcUnit.Type::lvngExpression) and (TempBandLine."Band Type" = TempBandLine."Band Type"::lvngFormula) then begin
                                            //Apply row formula
                                            ExpressionHeader.Get(TempBandLine."Row Formula Code");
                                            ExcelExport.WriteFormula(TranslateRowFormula(ExpressionEngine.GetFormulaFromLines(ExpressionHeader), DataRowStartIdx + CurrentDataRowIdx, Cell."Column No." - 1, DataColStartIdx, ColumnCount));
                                        end else begin
                                            if CalcUnit.Type = CalcUnit.Type::lvngExpression then begin
                                                //Apply column formula
                                                ExpressionHeader.Get(CalcUnit."Expression Code");
                                                case ExpressionHeader.Type of
                                                    ExpressionHeader.Type::Formula:
                                                        begin
                                                            ExcelExport.WriteFormula(TranslateColFormula(ExpressionEngine.GetFormulaFromLines(ExpressionHeader)));
                                                        end;
                                                    ExpressionHeader.Type::Condition:
                                                        begin
                                                            Error('Not Implemented');
                                                        end;
                                                    ExpressionHeader.Type::Iif:
                                                        begin
                                                            Error('Not Implemented');
                                                        end
                                                    else
                                                        Error(UnsupportedFormulaTypeErr);
                                                end
                                            end else begin
                                                //Write calculated value
                                            end;
                                        end;
                                    CurrentDataColIdx += 1;
                                until Cell.Next() = 0;
                            until TempBandLine.Next() = 0;
                        end;
                    end;
                RowLine."Row Type"::lvngHeader:
                    begin
                    end;
                RowLine."Row Type"::lvngEmpty:
                    begin
                    end;
            end;
        until RowLine.Next() = 0;


        Error('Not Implemented');
    end;

    local procedure TranslateRowFormula(Formula: Text; RowIdx: Integer; ColIdx: Integer; DataColOffset: Integer; BandSize: Integer): Text
    var
        FieldStart: Integer;
        FieldEnd: Integer;
    begin
        //[BAND1]+[BAND2]+[BAND3]+...
        //=>
        //=B7+E7+J7+...
        Formula := LowerCase(Formula);
        FieldStart := StrPos(Formula, '[');
        while FieldStart <> 0 do begin
            FieldEnd := StrPos(Formula, ']');
            if FieldEnd = 0 then
                Error(IntranslatableRowFormulaErr);
            Formula := CopyStr(Formula, 1, FieldStart - 1) + TranslateRowFormulaField(CopyStr(Formula, FieldStart + 1, FieldEnd - FieldStart - 1), RowIdx, ColIdx, DataColOffset, BandSize) + CopyStr(Formula, FieldEnd + 1);
            FieldStart := StrPos(Formula, '[');
        end;
        exit('=' + Formula);
    end;

    local procedure TranslateColFormula(Formula: Text): Text
    var
        FieldStart: Integer;
        FieldEnd: Integer;
    begin
        FieldStart := StrPos(Formula, '[');
        while FieldStart <> 0 do begin
            FieldEnd := StrPos(Formula, ']');
            if FieldEnd = 0 then
                Error(IntranslatableRowFormulaErr);
            //Formula := CopyStr(Formula, 1, FieldStart - 1) + TranslateColFormulaField(CopyStr(Formula, FieldStart + 1, FieldEnd - FieldStart - 1), RowIdx, ColIdx, DataColOffset, BandSize) + CopyStr(Formula, FieldEnd + 1);
            Error('Not Implemented');
            FieldStart := StrPos(Formula, '[');
        end;
        exit('=' + Formula);
    end;

    local procedure TranslateColFormulaField(Field: Text)
    begin

    end;

    local procedure TranslateRowFormulaField(Field: Text; RowIdx: Integer; ColIdx: Integer; DataColOffset: Integer; BandSize: Integer): Text
    var
        ExcelExport: Codeunit lvngExcelExport;
        FieldIdx: Integer;
    begin
        if StrPos(Field, 'band') <> 1 then
            Error(IntranslatableRowFormulaErr);
        if not Evaluate(FieldIdx, DelStr(Field, 1, 4)) then
            Error(IntranslatableRowFormulaErr);
        if not BandIndexLookup.Get(FieldIdx, FieldIdx) then
            Error(IntranslatableRowFormulaErr);
        exit(ExcelExport.GetExcelColumnName(DataColOffset + FieldIdx * BandSize + ColIdx) + Format(RowIdx + 1));
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
                BandColumns.Add(GetColumn(StrSubstNo(PerformanceMgmt.GetFieldFormat(), TempBandLine."Band No.", ColLine."Column No."), ColLine."Primary Caption", ''));
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
}