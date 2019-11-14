page 14135405 lvngBranchDashboardPart
{
    PageType = CardPart;
    Caption = 'Dashboard';

    layout
    {
        area(Content)
        {
            usercontrol(Dashboard; DashboardControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    InitializeDashboard();
                end;

                trigger AttemptDateRange(DateFrom: Text; DateTo: Text)
                var
                    NewDateFrom: Date;
                    NewDateTo: Date;
                begin
                    Evaluate(NewDateFrom, CopyStr(DateFrom, 1, 10), 9);
                    Evaluate(NewDateTo, CopyStr(DateTo, 1, 10), 9);
                    if AdjustCurrentDateRange(NewDateFrom, NewDateTo) then begin
                        CurrPage.Dashboard.AdviceDateRange(CurrentDateFrom, CurrentDateTo);
                        CurrPage.Dashboard.ResetTiles(LoadingTxt);
                        SetDashboardInfo();
                    end;
                end;

                trigger TileDataNeeded(Type: Integer; Code: Text)
                begin
                    CalculateTile(Type, Code);
                end;

                trigger TileClicked(Type: Integer; Code: Text)
                begin
                    CurrentLevel := Type;
                    CurrentCode := Code;
                    SetDashboardInfo();
                end;

                trigger ButtonClicked(Group: Text; Id: Text; Metadata: Text)
                begin
                    //Message(Group + ' - ' + Id + ' - ' + Metadata);
                    case Group of
                        'default':
                            ProcessDefaultButton(Id, Metadata);
                        'performance':
                            ProcessPerformanceButton(Id, Metadata);
                        'loanlevel':
                            ProcessLoanLevelButton(Id, Metadata)
                        else
                            Error(UnsupportedDashboardActionGroupErr, Group);
                    end;
                end;
            }
        }
    }

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        BranchPortalSetup: Record lvngBranchPortalSetup;
        LoanVisionSetup: Record lvngLoanVisionSetup;
        BranchUser: Record lvngBranchUser;
        BranchPortalMgmt: Codeunit lvngBranchPortalManagement;
        CurrentDateFrom: Date;
        CurrentDateTo: Date;
        CurrentLevel: Integer;
        CurrentCode: Code[20];
        DimensionCodeLookup: array[4] of Code[20];
        LevelMetricLookup: array[5] of Enum lvngHierarchyLevels;
        TileColorLookup: array[5] of Text;
        BlockDataFromDate: Date;
        BlockDataToDate: Date;
        PerformanceWorksheetLbl: Label 'Performance Worksheet';
        KPILbl: Label 'KPI';
        GeneralLedgerLbl: Label 'General Ledger';
        LoanLevelReportLbl: Label 'Loan Fundings';
        CorporateTxt: Label 'Corporate';
        LoadingTxt: Label 'Loading...';
        UnsupportedDashboardActionGroupErr: Label 'Unsupported dashboard action group: %1';
        UnsupportedDashboardActionButtonErr: Label 'Unsupported dashboard action button: %1';

    trigger OnOpenPage()
    var
        AccountingPeriod: Record "Accounting Period";
        InitialPeriod: Enum lvngInitialDashboardPeriod;
        InitialFromDate: Date;
        InitialToDate: Date;
    begin
        GeneralLedgerSetup.Get();
        BranchPortalSetup.Get();
        LoanVisionSetup.Get();
        BranchUser.Get(UserId());
        DimensionCodeLookup[1] := GeneralLedgerSetup."Global Dimension 1 Code";
        DimensionCodeLookup[2] := GeneralLedgerSetup."Global Dimension 2 Code";
        DimensionCodeLookup[3] := GeneralLedgerSetup."Shortcut Dimension 3 Code";
        DimensionCodeLookup[4] := GeneralLedgerSetup."Shortcut Dimension 4 Code";
        LevelMetricLookup[1] := LoanVisionSetup."Level 1";
        LevelMetricLookup[2] := LoanVisionSetup."Level 2";
        LevelMetricLookup[3] := LoanVisionSetup."Level 3";
        LevelMetricLookup[4] := LoanVisionSetup."Level 4";
        LevelMetricLookup[5] := LoanVisionSetup."Level 5";
        TileColorLookup[1] := BranchPortalSetup."Level 1 Tile Color";
        TileColorLookup[2] := BranchPortalSetup."Level 2 Tile Color";
        TileColorLookup[3] := BranchPortalSetup."Level 3 Tile Color";
        TileColorLookup[4] := BranchPortalSetup."Level 4 Tile Color";
        TileColorLookup[5] := BranchPortalSetup."Level 5 Tile Color";
        BlockDataFromDate := BranchPortalSetup."Block Data From Date";
        BlockDataToDate := BranchPortalSetup."Block Data To Date";
        if BranchUser."Block Data From Date" <> 0D then
            BlockDataFromDate := BranchUser."Block Data From Date";
        if BranchUser."Block Data To Date" <> 0D then
            BlockDataToDate := BranchUser."Block Data To Date";
        InitialPeriod := BranchPortalSetup."Initial Dashboard Period";
        if BranchUser."Initial Dashboard Period" <> InitialPeriod::lvngDefault then
            InitialPeriod := BranchUser."Initial Dashboard Period";
        InitialToDate := Today();
        InitialFromDate := DMY2Date(1, 1);
        case InitialPeriod of
            InitialPeriod::lvngMTD:
                InitialFromDate := DMY2Date(1);
            InitialPeriod::lvngPrevMonth:
                begin
                    InitialToDate := DMY2Date(1) - 1;
                    InitialFromDate := CalcDate('<-CM>', InitialToDate);
                end;
            InitialPeriod::lvngFiscalYTD:
                begin
                    AccountingPeriod.Reset();
                    AccountingPeriod.SetRange("New Fiscal Year", true);
                    AccountingPeriod.SetRange("Starting Date", 0D, InitialToDate);
                    if AccountingPeriod.FindLast() then
                        InitialFromDate := AccountingPeriod."Starting Date"
                    else begin
                        AccountingPeriod.Reset();
                        AccountingPeriod.FindFirst();
                        InitialFromDate := AccountingPeriod."Starting Date";
                    end;
                end;
        end;
        AdjustCurrentDateRange(InitialFromDate, InitialToDate);
    end;

    local procedure AdjustCurrentDateRange(NewDateFrom: Date; NewDateTo: Date): Boolean
    begin
        if BlockDataToDate <> 0D then begin
            if NewDateFrom <= BlockDataToDate then begin
                NewDateFrom := BlockDataToDate + 1;
            end;
            if NewDateTo <= BlockDataToDate then begin
                NewDateTo := BlockDataToDate + 1;
            end;
        end;
        if BlockDataFromDate <> 0D then begin
            if NewDateFrom >= BlockDataFromDate then begin
                NewDateFrom := BlockDataFromDate - 1;
            end;
            if NewDateTo >= BlockDataFromDate then begin
                NewDateTo := BlockDataFromDate - 1;
            end;
        end;
        if (CurrentDateFrom <> NewDateFrom) or (CurrentDateTo <> NewDateTo) then begin
            CurrentDateFrom := NewDateFrom;
            CurrentDateTo := NewDateTo;
            exit(true);
        end;
        exit(false);
    end;

    local procedure InitializeDashboard()
    begin
        CurrPage.Dashboard.AdviceDateRange(CurrentDateFrom, CurrentDateTo);
        CurrPage.Dashboard.LoadTiles(CreateTiles());
        CurrPage.Dashboard.ResetTiles(LoadingTxt);
        CurrPage.Dashboard.LoadButtons(CreateButtons());
    end;

    local procedure Yes(What: Boolean; Why: Enum lvngDefaultBoolean): Boolean
    begin
        case Why of
            Why::lvngDefault:
                exit(What)
            else
                exit(Why = Why::lvngTrue);
        end;
    end;

    local procedure CreateButtons() Json: JsonArray
    var
        BranchPerfSchemaMapping: Record lvngBranchPerfSchemaMapping;
        TempBranchPerfSchemaMapping: Record lvngBranchPerfSchemaMapping temporary;
        LoanLevelSchemaMapping: Record lvngLoanLevelSchemaMapping;
        TempLoanLevelSchemaMapping: Record lvngLoanLevelSchemaMapping temporary;
        Dropdown: JsonArray;
        Button: JsonObject;
    begin
        Clear(Json);
        BeforeAddBranchDashboardButton(Json, 'default', 'performance');
        if Yes(BranchPortalSetup."Show Performance Worksheet", BranchUser."Show Performance Worksheet") then begin
            Clear(Dropdown);
            BranchPerfSchemaMapping.Reset();
            BranchPerfSchemaMapping.SetRange("User ID", '');
            if BranchPerfSchemaMapping.FindSet() then
                repeat
                    TempBranchPerfSchemaMapping := BranchPerfSchemaMapping;
                    TempBranchPerfSchemaMapping.Insert();
                until BranchPerfSchemaMapping.Next() = 0;
            BranchPerfSchemaMapping.Reset();
            BranchPerfSchemaMapping.SetRange("User ID", UserId());
            if BranchPerfSchemaMapping.FindSet() then
                repeat
                    if TempBranchPerfSchemaMapping.Get('', BranchPerfSchemaMapping."Row Schema Code", BranchPerfSchemaMapping."Band Schema Code") then begin
                        TempBranchPerfSchemaMapping.Sequence := BranchPerfSchemaMapping.Sequence;
                        if BranchPerfSchemaMapping.Description <> '' then
                            TempBranchPerfSchemaMapping.Description := BranchPerfSchemaMapping.Description;
                        TempBranchPerfSchemaMapping.Modify();
                    end else begin
                        TempBranchPerfSchemaMapping := BranchPerfSchemaMapping;
                        TempBranchPerfSchemaMapping.Insert();
                    end;
                until BranchPerfSchemaMapping.Next() = 0;
            TempBranchPerfSchemaMapping.Reset();
            TempBranchPerfSchemaMapping.SetCurrentKey(Sequence);
            TempBranchPerfSchemaMapping.SetFilter(Sequence, '<>0');
            if TempBranchPerfSchemaMapping.FindSet() then begin
                repeat
                    CreatePerformanceButton(Dropdown, TempBranchPerfSchemaMapping);
                until TempBranchPerfSchemaMapping.Next() = 0;
                Button := BranchPortalMgmt.CreateDashboardButton(Json, 'default', 'performance', '', PerformanceWorksheetLbl, 'contained', 'default', 220);
                BranchPortalMgmt.AddDashboardButtonDropdown(Button, Dropdown);
            end;
        end;
        AfterAddBranchDashboardButton(Json, 'default', 'performance');
        BeforeAddBranchDashboardButton(Json, 'default', 'kpi');
        if Yes(BranchPortalSetup."Show KPI", BranchUser."Show KPI") then
            BranchPortalMgmt.CreateDashboardButton(Json, 'default', 'kpi', '', KPILbl, 'contained', 'default', 160);
        AfterAddBranchDashboardButton(Json, 'default', 'kpi');
        BeforeAddBranchDashboardButton(Json, 'default', 'gl');
        if Yes(BranchPortalSetup."Show General Ledger", BranchUser."Show General Ledger") then
            BranchPortalMgmt.CreateDashboardButton(Json, 'default', 'gl', '', GeneralLedgerLbl, 'contained', 'default', 160);
        AfterAddBranchDashboardButton(Json, 'default', 'gl');
        BeforeAddBranchDashboardButton(Json, 'default', 'loanlevel');
        if Yes(BranchPortalSetup."Show Loan Level Report", BranchUser."Show Loan Level Report") then begin
            Clear(Dropdown);
            LoanLevelSchemaMapping.Reset();
            LoanLevelSchemaMapping.SetRange("User ID", '');
            if LoanLevelSchemaMapping.FindSet() then
                repeat
                    TempLoanLevelSchemaMapping := LoanLevelSchemaMapping;
                    TempLoanLevelSchemaMapping.Insert();
                until LoanLevelSchemaMapping.Next() = 0;
            LoanLevelSchemaMapping.Reset();
            LoanLevelSchemaMapping.SetRange("User ID", UserId());
            if LoanLevelSchemaMapping.FindSet() then
                repeat
                    if TempLoanLevelSchemaMapping.Get('', LoanLevelSchemaMapping."Schema Code") then begin
                        TempLoanLevelSchemaMapping.Sequence := LoanLevelSchemaMapping.Sequence;
                        if LoanLevelSchemaMapping."Base Date" <> LoanLevelSchemaMapping."Base Date"::lvngDefault then
                            TempLoanLevelSchemaMapping."Base Date" := LoanLevelSchemaMapping."Base Date";
                        TempLoanLevelSchemaMapping.Modify();
                    end else begin
                        TempLoanLevelSchemaMapping := LoanLevelSchemaMapping;
                        TempLoanLevelSchemaMapping.Insert();
                    end;
                until LoanLevelSchemaMapping.Next() = 0;
            TempLoanLevelSchemaMapping.Reset();
            TempLoanLevelSchemaMapping.SetCurrentKey(Sequence);
            TempLoanLevelSchemaMapping.SetFilter(Sequence, '<>0');
            if TempLoanLevelSchemaMapping.FindSet() then begin
                repeat
                    CreateLoanLevelButton(Dropdown, TempLoanLevelSchemaMapping);
                until TempLoanLevelSchemaMapping.Next() = 0;
                Button := BranchPortalMgmt.CreateDashboardButton(Json, 'default', 'loanlevel', '', LoanLevelReportLbl, 'contained', 'default', 160);
                BranchPortalMgmt.AddDashboardButtonDropdown(Button, Dropdown);
            end;
        end;
        AfterAddBranchDashboardButton(Json, 'default', 'loanlevel');
    end;

    local procedure CreatePerformanceButton(var ToArray: JsonArray; var BranchPerformanceSchemaMapping: Record lvngBranchPerfSchemaMapping) Button: JsonObject
    var
        Caption: Text;
    begin
        if BranchPerformanceSchemaMapping.Description = '' then
            Caption := BranchPerformanceSchemaMapping."Row Schema Code" + '-' + BranchPerformanceSchemaMapping."Band Schema Code"
        else
            Caption := BranchPerformanceSchemaMapping.Description;
        Button := BranchPortalMgmt.CreateDashboardButtonDropdownItem(ToArray, 'performance', BranchPerformanceSchemaMapping."Row Schema Code", BranchPerformanceSchemaMapping."Band Schema Code", Caption)
    end;

    local procedure CreateLoanLevelButton(var ToArray: JsonArray; var LoanLevelSchemaMapping: Record lvngLoanLevelSchemaMapping) Button: JsonObject
    begin
        LoanLevelSchemaMapping.CalcFields(Description);
        Button := BranchPortalMgmt.CreateDashboardButtonDropdownItem(ToArray, 'loanlevel', LoanLevelSchemaMapping."Schema Code", Format(LoanLevelSchemaMapping."Base Date"), LoanLevelSchemaMapping.Description);
    end;

    [IntegrationEvent(false, false)]
    local procedure BeforeAddBranchDashboardButton(var Buttons: JsonArray; GroupId: Text; ButtonId: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterAddBranchDashboardButton(var Buttons: JsonArray; GroupId: Text; ButtonId: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBranchDashboardButtonClicked(GroupId: Text; ButtonId: Text; Metadata: Text; var SystemFilter: Record lvngSystemCalculationFilter; var Handled: Boolean)
    begin
    end;

    local procedure CreateTiles() Json: JsonArray
    var
        BranchUserMapping: Record lvngBranchUserMapping;
        BusinessUnit: Record "Business Unit";
        DimensionValue: Record "Dimension Value";
        HierarchyLevel: Enum lvngHierarchyLevels;
        Description: Text;
    begin
        if Yes(BranchPortalSetup."Show Corporate Tile", BranchUser."Show Corporate Tile") then
            CreateDashboardTile(Json, 0, 'CORP', '', CorporateTxt);
        BranchUserMapping.Reset();
        BranchUserMapping.SetCurrentKey(Sequence);
        BranchUserMapping.SetFilter(Sequence, '<>0');
        if BranchUserMapping.FindSet() then
            repeat
                if LevelMetricLookup[BranchUserMapping.Type] = HierarchyLevel::lvngBusinessUnit then begin
                    BusinessUnit.Get(BranchUserMapping.Code);
                    Description := BusinessUnit.Name;
                end else begin
                    DimensionValue.Get(DimensionCodeLookup[LevelMetricLookup[BranchUserMapping.Type]], BranchUserMapping.Code);
                    Description := DimensionValue.Name;
                end;
                CreateDashboardTile(Json, BranchUserMapping.Type, BranchUserMapping.Code, TileColorLookup[BranchUserMapping.Type], Description)
            until BranchUserMapping.Next() = 0;
    end;

    local procedure CreateDashboardTile(var ToArray: JsonArray; Type: Integer; Code: Text; Color: Text; Description: Text) Tile: JsonObject;
    begin
        Clear(Tile);
        ToArray.Add(Tile);
        Tile.Add('type', Type);
        Tile.Add('code', Code);
        if Color <> '' then
            Tile.Add('color', Color);
        Tile.Add('description', Description);
    end;

    local procedure ApplySystemFilter(var SystemFilter: Record lvngSystemCalculationFilter)
    begin
        ApplySystemFilter(SystemFilter, CurrentLevel, CurrentCode);
    end;

    local procedure ApplySystemFilter(var SystemFilter: Record lvngSystemCalculationFilter; Type: Integer; Code: Text)
    var
        BranchHierarchy: Enum lvngHierarchyLevels;
    begin
        SystemFilter."Date Filter" := StrSubstNo('%1..%2', CurrentDateFrom, CurrentDateTo);
        SystemFilter."As Of Date" := CurrentDateTo;
        SystemFilter."Block Data From Date" := BlockDataFromDate;
        SystemFilter."Block Data To Date" := BlockDataToDate;
        if Type <> 0 then begin
            case LevelMetricLookup[Type] of
                BranchHierarchy::lvngBusinessUnit:
                    SystemFilter."Business Unit" := Code;
                BranchHierarchy::lvngDimension1:
                    SystemFilter."Shortcut Dimension 1" := Code;
                BranchHierarchy::lvngDimension2:
                    SystemFilter."Shortcut Dimension 2" := Code;
                BranchHierarchy::lvngDimension3:
                    SystemFilter."Shortcut Dimension 3" := Code;
                BranchHierarchy::lvngDimension4:
                    SystemFilter."Shortcut Dimension 4" := Code;
            end;
        end;
    end;

    local procedure CalculateTile(Type: Integer; Code: Text)
    var
        BranchMetric: Record lvngBranchMetric;
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
        CalculationUnit: Record lvngCalculationUnit;
        Cache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]];
        Values: array[3] of Text;
        Value: Decimal;
    begin
        ApplySystemFilter(SystemFilter, Type, Code);
        Values[1] := '&nbsp;';
        Values[2] := '&nbsp;';
        Values[3] := '&nbsp;';
        BranchMetric.Reset();
        BranchMetric.SetRange(Type, BranchMetric.Type::lvngTile);
        if BranchMetric.FindSet() then
            repeat
                CalculationUnit.Get(BranchMetric."Calculation Unit Code");
                Value := PerformanceMgmt.CalculateSingleValue(CalculationUnit, SystemFilter, Cache, Path);
                if BranchMetric.Description.IndexOf('%') <> 0 then
                    Values[BranchMetric."No."] := StrSubstNo(BranchMetric.Description, PerformanceMgmt.FormatValue(Value, BranchMetric."Number Format Code"))
                else
                    Values[BranchMetric."No."] := BranchMetric.Description + ': ' + PerformanceMgmt.FormatValue(Value, BranchMetric."Number Format Code");
            until BranchMetric.Next() = 0;
        CurrPage.Dashboard.SetTileData(Type, Code, Values[1], Values[2], Values[3]);
    end;

    local procedure SetDashboardInfo()
    var
        BranchMetric: Record lvngBranchMetric;
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
        CalculationUnit: Record lvngCalculationUnit;
        Cache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]];
        Names: array[5] of Text;
        Values: array[5] of Text;
    begin
        ApplySystemFilter(SystemFilter);
        BranchMetric.Reset();
        BranchMetric.SetRange(Type, BranchMetric.Type::lvngDashboard);
        if BranchMetric.FindSet() then
            repeat
                CalculationUnit.Get(BranchMetric."Calculation Unit Code");
                Values[BranchMetric."No."] := PerformanceMgmt.FormatValue(PerformanceMgmt.CalculateSingleValue(CalculationUnit, SystemFilter, Cache, Path), BranchMetric."Number Format Code");
                Names[BranchMetric."No."] := BranchMetric.Description;
            until BranchMetric.Next() = 0;
        CurrPage.Dashboard.SetMainParameters(Names[1], Values[1], Names[2], Values[2], Names[3], Values[3], Names[4], Values[4], Names[5], Values[5]);
        UpdateChart(1, SystemFilter);
        UpdateChart(2, SystemFilter);
    end;

    local procedure UpdateChart(ChartIdx: Integer; var SystemFilter: Record lvngSystemCalculationFilter)
    var
        Json: JsonObject;
        Series: JsonObject;
        Legend: JsonObject;
        ChartType: Enum lvngDashboardChartType;
        ChartKind: Enum lvngChartKind;
    begin
        Clear(Json);
        if ChartIdx = 1 then begin
            ChartType := BranchPortalSetup."Chart 1 Type";
            ChartKind := BranchPortalSetup."Chart 1 Kind";
        end else begin
            ChartType := BranchPortalSetup."Chart 2 Type";
            ChartKind := BranchPortalSetup."Chart 2 Kind";
        end;
        Json.Add('argumentDisplayField', 'z');
        Clear(Series);
        Json.Add('commonSeriesSettings', Series);
        Series.Add('argumentField', 'x');
        Series.Add('type', BranchPortalMgmt.DevExtremeChartKind(ChartKind));
        Clear(Series);
        Json.Add('series', Series);
        Series.Add('valueField', 'y');
        Json.Add('dataSource', BranchPortalMgmt.GetDashboardChartData(ChartType, SystemFilter, 'x', 'y', 'z'));
        Clear(Legend);
        Json.Add('legend', Legend);
        Legend.Add('visible', false);
        if ChartIdx = 1 then
            CurrPage.Dashboard.LoadChart('left', Json)
        else
            CurrPage.Dashboard.LoadChart('right', Json);
    end;

    local procedure ProcessDefaultButton(Id: Text; Metadata: Text)
    begin
        case Id of
            'kpi':
                ProcessKPIButton();
            'gl':
                ProcessGeneralLedgerButton()
            else
                Error(UnsupportedDashboardActionButtonErr, Id);
        end;
    end;

    local procedure ProcessPerformanceButton(RowSchemaCode: Code[20]; BandSchemaCode: Code[20])
    var
        RowSchema: Record lvngPerformanceRowSchema;
        SystemFilter: Record lvngSystemCalculationFilter;
        PeriodPerformanceView: Page lvngPeriodPerformanceView;
        DimensionPerformanceView: Page lvngDimensionPerformanceView;
        BranchHierarchy: Enum lvngHierarchyLevels;
    begin
        ApplySystemFilter(SystemFilter);
        RowSchema.Get(RowSchemaCode);
        if RowSchema."Schema Type" = RowSchema."Schema Type"::lvngPeriod then begin
            Clear(PeriodPerformanceView);
            PeriodPerformanceView.SetParams(RowSchemaCode, BandSchemaCode, SystemFilter);
            PeriodPerformanceView.RunModal();
        end else begin
            Clear(DimensionPerformanceView);
            DimensionPerformanceView.SetParams(RowSchemaCode, BandSchemaCode, SystemFilter);
            DimensionPerformanceView.RunModal();
        end;
    end;

    local procedure ProcessLoanLevelButton(SchemaCode: Code[20]; Metadata: Text)
    var
        SystemFilter: Record lvngSystemCalculationFilter;
        BaseDate: Enum lvngLoanLevelReportBaseDate;
        LoanFundingsWorksheet: Page lvngLoanValuesView;
    begin
        if not Evaluate(BaseDate, Metadata) then
            BaseDate := BaseDate::lvngDefault;
        ApplySystemFilter(SystemFilter);
        LoanFundingsWorksheet.SetParams(SchemaCode, BaseDate, SystemFilter, true);
        LoanFundingsWorksheet.RunModal();
    end;

    local procedure ProcessKPIButton()
    var
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        BranchPortalKPI: Page lvngBranchPortalKPI;
    begin
        ApplySystemFilter(SystemFilter);
        BranchPortalKPI.SetParams(SystemFilter);
        BranchPortalKPI.Run();
    end;

    local procedure ProcessGeneralLedgerButton()
    var
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        BranchReport: Report lvngGeneralLedgerDetails;
    begin
        ApplySystemFilter(SystemFilter);
        BranchReport.SetParams(SystemFilter);
        BranchReport.Run();
    end;
}