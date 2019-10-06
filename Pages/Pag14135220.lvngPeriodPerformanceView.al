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
            action(Export)
            {
                Caption = 'Excel Export';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.DataGrid.ExportToExcel();
                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                begin
                    CurrPage.DataGrid.Print();
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
        StylesInUse: Dictionary of [Code[20], Boolean];
        UnsupportedBandTypeErr: Label 'Band type is not supported: %1';
        FieldFormatTxt: Label 'b%1c%2';
        SchemaNameFormatTxt: Label '%1 - %2';

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
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
        StartDate: Date;
        EndDate: Date;
        TotalStartDate: Date;
        TotalEndDate: Date;
        Multiplier: Integer;
    begin
        BandLine.Reset();
        BandLine.SetRange("Band Code", BandSchema.Code);
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
                    begin
                        Error('Not Implemented');
                    end
                else
                    Error(UnsupportedBandTypeErr, BandLine);
            end;
        until BandLine.Next() = 0;

        TempBandLine.Reset();
        TempBandLine.SetFilter("Band Type", '<>%1', TempBandLine."Band Type"::lvngFormula);
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
        TempBandLine.Reset();
        TempBandLine.SetRange("Band Type", TempBandLine."Band Type"::lvngFormula);
        if TempBandLine.FindSet() then
            repeat
                Error('Not Implemented');
            until TempBandLine.Next() = 0;
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
        SetupGridStyles();
        CurrPage.DataGrid.InitializeDXGrid(Json);
    end;

    local procedure ProcessCellClick(BandIndex: Integer; ColIndex: Integer; RowIndex: Integer)
    var
        RowLine: Record lvngPerformanceRowSchemaLine;
        CalcUnit: Record lvngCalculationUnit;
        Loan: Record lvngLoan;
        GLEntry: Record "G/L Entry";
        LoanList: Page lvngLoanList;
        GLEntries: Page lvngPerformanceGLEntries;
    begin
        TempBandLine.Get(BandSchema.Code, BandIndex);
        if TempBandLine."Band Type" = TempBandLine."Band Type"::lvngNormal then begin
            RowLine.Get(RowSchema.Code, RowIndex, ColIndex);
            CalcUnit.Get(RowLine."Calculation Unit Code");
            case CalcUnit."Lookup Source" of
                CalcUnit."Lookup Source"::lvngLoanCard:
                    begin
                        Loan.Reset();
                        ApplyLoanFilter(Loan, CalcUnit, TempBandLine."Date From", TempBandLine."Date To");
                        LoanList.SetTableView(Loan);
                        LoanList.RunModal();
                    end;
                CalcUnit."Lookup Source"::lvngLedgerEntries:
                    begin
                        GLEntry.Reset();
                        ApplyGLFilter(GLEntry, CalcUnit, TempBandLine."Date From", TempBandLine."Date To");
                        GLEntries.SetTableView(GLEntry);
                        GLEntries.RunModal();
                    end;
            end;
        end;
    end;

    local procedure ApplyLoanFilter(var Loan: Record lvngLoan; var CalcUnit: Record lvngCalculationUnit; DateFrom: Date; DateTo: Date)
    begin
        Loan.FilterGroup(2);
        if CalcUnit."Dimension 1 Filter" <> '' then
            Loan.SetRange(lvngGlobalDimension1Code, CalcUnit."Dimension 1 Filter")
        else
            if Dim1Filter <> '' then
                Loan.SetRange(lvngGlobalDimension1Code, Dim1Filter);
        if CalcUnit."Dimension 2 Filter" <> '' then
            Loan.SetRange(lvngGlobalDimension2Code, CalcUnit."Dimension 2 Filter")
        else
            if Dim2Filter <> '' then
                Loan.SetRange(lvngGlobalDimension2Code, Dim2Filter);
        if CalcUnit."Dimension 3 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension3Code, CalcUnit."Dimension 3 Filter")
        else
            if Dim3Filter <> '' then
                Loan.SetRange(lvngShortcutDimension3Code, Dim3Filter);
        if CalcUnit."Dimension 4 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension4Code, CalcUnit."Dimension 4 Filter")
        else
            if Dim4Filter <> '' then
                Loan.SetRange(lvngShortcutDimension4Code, Dim4Filter);
        if CalcUnit."Dimension 5 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension5Code, CalcUnit."Dimension 5 Filter");
        if CalcUnit."Dimension 6 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension6Code, CalcUnit."Dimension 6 Filter");
        if CalcUnit."Dimension 7 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension7Code, CalcUnit."Dimension 7 Filter");
        if CalcUnit."Dimension 8 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension8Code, CalcUnit."Dimension 8 Filter");
        if CalcUnit."Business Unit Filter" <> '' then
            Loan.SetRange(lvngBusinessUnitCode, CalcUnit."Business Unit Filter")
        else
            if BusinessUnitFilter <> '' then
                Loan.SetRange(lvngBusinessUnitCode, BusinessUnitFilter);
        case CalcUnit."Based On Date" of
            CalcUnit."Based On Date"::lvngApplication:
                Loan.SetRange(lvngApplicationDate, DateFrom, DateTo);
            CalcUnit."Based On Date"::lvngClosed:
                Loan.SetRange(lvngDateClosed, DateFrom, DateTo);
            CalcUnit."Based On Date"::lvngFunded:
                Loan.SetRange(lvngDateFunded, DateFrom, DateTo);
            CalcUnit."Based On Date"::lvngLocked:
                Loan.SetRange(lvngDateLocked, DateFrom, DateTo);
            CalcUnit."Based On Date"::lvngSold:
                Loan.SetRange(lvngDateSold, DateFrom, DateTo);
        end;
        Loan.FilterGroup(0);
    end;

    local procedure ApplyGLFilter(var GLEntry: Record "G/L Entry"; var CalcUnit: Record lvngCalculationUnit; DateFrom: Date; DateTo: Date)
    begin
        GLEntry.FilterGroup(2);
        GLEntry.SetFilter("G/L Account No.", CalcUnit."Account No. Filter");
        if CalcUnit."Dimension 1 Filter" <> '' then
            GLEntry.SetRange("Global Dimension 1 Code", CalcUnit."Dimension 1 Filter")
        else
            if Dim1Filter <> '' then
                GLEntry.SetRange("Global Dimension 1 Code", Dim1Filter);
        if CalcUnit."Dimension 2 Filter" <> '' then
            GLEntry.SetRange("Global Dimension 2 Code", CalcUnit."Dimension 2 Filter")
        else
            if Dim2Filter <> '' then
                GLEntry.SetRange("Global Dimension 2 Code", Dim2Filter);
        if CalcUnit."Dimension 3 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension3Code, CalcUnit."Dimension 3 Filter")
        else
            if Dim3Filter <> '' then
                GLEntry.SetRange(lvngShortcutDimension3Code, Dim3Filter);
        if CalcUnit."Dimension 4 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension4Code, CalcUnit."Dimension 4 Filter")
        else
            if Dim4Filter <> '' then
                GLEntry.SetRange(lvngShortcutDimension4Code, Dim4Filter);
        if CalcUnit."Dimension 5 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension5Code, CalcUnit."Dimension 5 Filter");
        if CalcUnit."Dimension 6 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension6Code, CalcUnit."Dimension 6 Filter");
        if CalcUnit."Dimension 7 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension7Code, CalcUnit."Dimension 7 Filter");
        if CalcUnit."Dimension 8 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension8Code, CalcUnit."Dimension 8 Filter");
        if CalcUnit."Business Unit Filter" <> '' then
            GLEntry.SetRange("Business Unit Code", CalcUnit."Business Unit Filter")
        else
            if BusinessUnitFilter <> '' then
                GLEntry.SetRange("Business Unit Code", BusinessUnitFilter);
        GLEntry.SetRange("Posting Date", DateFrom, DateTo);
        GLEntry.FilterGroup(0);
    end;

    local procedure GetData() DataSource: JsonArray
    var
        RowLine: Record lvngPerformanceRowSchemaLine;
        ColLine: Record lvngPerformanceColSchemaLine;
        RowData: JsonObject;
        ValueData: JsonObject;
        ShowLine: Boolean;
    begin
        RowLine.Reset();
        RowLine.SetRange("Schema Code", RowSchema.Code);
        RowLine.SetRange("Column No.", 1);
        RowLine.FindSet();
        repeat
            case RowLine."Row Type" of
                RowLine."Row Type"::lvngNormal:
                    begin
                        ShowLine := true;
                        if RowLine."Hide Zero Line" then begin
                            Buffer.Reset();
                            Buffer.SetRange("Row No.", RowLine."Line No.");
                            Buffer.SetFilter(Value, '<>%1', 0);
                            if Buffer.IsEmpty then
                                ShowLine := false;
                        end;
                        if ShowLine then begin
                            Clear(RowData);
                            RowData.Add('rowId', RowLine."Line No.");
                            RowData.Add('Name', RowLine.Description);
                            if RowLine."Row Style" <> '' then begin
                                StylesInUse.Set(RowLine."Row Style", true);
                                RowData.Add('CssClass', 'pw-' + LowerCase(RowLine."Row Style"));
                            end;
                            Buffer.Reset();
                            Buffer.SetRange("Row No.", RowLine."Line No.");
                            Buffer.FindSet();
                            repeat
                                if (not Buffer.Interactive) and (Buffer."Style Code" = '') then
                                    RowData.Add(StrSubstNo(FieldFormatTxt, Buffer."Band No.", Buffer."Column No."), FormatValue(Buffer))
                                else begin
                                    Clear(ValueData);
                                    ValueData.Add('v', FormatValue(Buffer));
                                    if Buffer.Interactive then
                                        ValueData.Add('i', Buffer.Interactive);
                                    if Buffer."Style Code" <> '' then begin
                                        StylesInUse.Set(Buffer."Style Code", true);
                                        ValueData.Add('c', 'pw-' + LowerCase(Buffer."Style Code"));
                                    end;
                                    RowData.Add(StrSubstNo(FieldFormatTxt, Buffer."Band No.", Buffer."Column No."), ValueData);
                                end;
                            until Buffer.Next() = 0;
                            DataSource.Add(RowData);
                        end;
                    end;
                RowLine."Row Type"::lvngHeader:
                    begin
                        Clear(RowData);
                        RowData.Add('rowId', RowLine."Line No.");
                        RowData.Add('CssClass', 'secondary-header');
                        TempBandLine.Reset();
                        TempBandLine.FindSet();
                        repeat
                            ColLine.Reset();
                            ColLine.SetRange("Schema Code", ColSchema.Code);
                            ColLine.FindSet();
                            repeat
                                RowData.Add(StrSubstNo(FieldFormatTxt, TempBandLine."Line No.", ColLine."Column No."), ColLine."Secondary Caption");
                            until ColLine.Next() = 0;
                        until TempBandLine.Next() = 0;
                        DataSource.Add(RowData);
                    end;
                RowLine."Row Type"::lvngEmpty:
                    begin
                        Clear(RowData);
                        RowData.Add('rowId', RowLine."Line No.");
                        DataSource.Add(RowData);
                    end;
            end;
        until RowLine.Next() = 0;
    end;

    local procedure FormatValue(var Buffer: Record lvngPerformanceValueBuffer) TextValue: Text
    var
        NumberFormat: Record lvngNumberFormat;
        NumericValue: Decimal;
    begin
        if not NumberFormat.Get(Buffer."Number Format Code") then
            Clear(NumberFormat);
        NumericValue := Buffer.Value;
        if NumericValue = 0 then
            case NumberFormat."Blank Zero" of
                NumberFormat."Blank Zero"::lvngZero:
                    exit('0');
                NumberFormat."Blank Zero"::lvngDash:
                    exit('-');
                NumberFormat."Blank Zero"::lvngBlank:
                    exit('&nbsp;');
            end;
        if NumberFormat."Invert Sign" then
            NumericValue := -NumericValue;
        if (NumericValue < 0) and (NumberFormat."Negative Formatting" = NumberFormat."Negative Formatting"::lvngSuppressSign) then
            NumericValue := Abs(NumericValue);
        case NumberFormat.Rounding of
            NumberFormat.Rounding::lvngNone:
                NumericValue := Round(NumericValue, 0.01);
            NumberFormat.Rounding::lvngOne:
                NumericValue := Round(NumericValue, 0.1);
            NumberFormat.Rounding::lvngRound:
                NumericValue := Round(NumericValue, 1);
            NumberFormat.Rounding::lvngThousands:
                NumericValue := Round(NumericValue, 1000);
        end;
        if NumberFormat."Suppress Thousand Separator" then
            TextValue := Format(NumericValue, 0, 9)
        else
            TextValue := Format(NumericValue);
        case NumberFormat."Value Type" of
            NumberFormat."Value Type"::Currency:
                TextValue := '$' + TextValue;
            NumberFormat."Value Type"::Percentage:
                TextValue := TextValue + '%';
        end;
        if NumberFormat."Negative Formatting" = NumberFormat."Negative Formatting"::lvngParenthesis then
            if NumericValue < 0 then
                TextValue := '(' + TextValue + ')'
            else
                TextValue := '&nbsp;' + TextValue + '&nbsp;';
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
                BandColumns.Add(GetColumn(StrSubstNo(FieldFormatTxt, TempBandLine."Line No.", ColLine."Column No."), ColLine."Primary Caption", ''));
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
        StyleCode: Code[20];
        Style: Record lvngStyle;
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
        foreach StyleCode in StylesInUse.Keys do
            if Style.Get(StyleCode) then begin
                Clear(CssClass);
                case Style.Bold of
                    Style.Bold::lvngTrue:
                        CssClass.Add('font-weight', 'bold');
                    Style.Bold::lvngFalse:
                        CssClass.Add('font-weight', 'normal');
                end;
                case Style.Italic of
                    Style.Italic::lvngTrue:
                        CssClass.Add('font-style', 'italic');
                    Style.Italic::lvngFalse:
                        CssClass.Add('font-style', 'normal');
                end;
                case Style.Underline of
                    Style.Underline::lvngTrue:
                        CssClass.Add('text-decoration', 'underline');
                    Style.Underline::lvngFalse:
                        CssClass.Add('text-decoration', 'none');
                end;
                if Style."Font Size" > 0 then
                    CssClass.Add('font-size', StrSubstNo('%1px', Style."Font Size"));
                if Style."Font Color" <> '' then
                    CssClass.Add('color', Style."Font Color");
                if Style."Background Color" <> '' then
                    CssClass.Add('background-color', Style."Background Color");
                Json.Add('.pw-' + LowerCase(StyleCode), CssClass);
            end;
        CurrPage.DataGrid.SetupStyles(Json);
    end;
}