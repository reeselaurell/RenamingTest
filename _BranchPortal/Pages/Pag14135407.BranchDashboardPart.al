page 14135407 lvngBranchDashboardPart
{
    PageType = CardPart;
    Caption = 'Dashboard';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            usercontrol(Dashboard; DashboardControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    ProgressReadyState();
                end;

                trigger DateRangeChanged(DateFrom: Text; DateTo: Text)
                var
                    DateChanged: Boolean;
                begin
                    Evaluate(FromDate, DateFrom);
                    Evaluate(ToDate, DateTo);
                    if BranchPortalSetup."Block Data To Date" <> 0D then begin
                        if FromDate <= BranchPortalSetup."Block Data To Date" then begin
                            FromDate := BranchPortalSetup."Block Data To Date" + 1;
                            DateChanged := true;
                        end;
                        if ToDate <= BranchPortalSetup."Block Data To Date" then begin
                            ToDate := BranchPortalSetup."Block Data To Date" + 1;
                            DateChanged := true;
                        end;
                    end;
                    if BranchPortalSetup."Block Data From Date" <> 0D then begin
                        if FromDate >= BranchPortalSetup."Block Data From Date" then begin
                            FromDate := BranchPortalSetup."Block Data From Date" - 1;
                            DateChanged := true;
                        end;
                        if ToDate >= BranchPortalSetup."Block Data From Date" then begin
                            ToDate := BranchPortalSetup."Block Data From Date" - 1;
                            DateChanged := true;
                        end;
                    end;
                    if DateChanged then begin
                        CurrPage.Dashboard.SetDateRange(FromDate, ToDate);
                        exit;
                    end;
                    CurrPage.Dashboard.ClearBars();
                    UpdateData();
                end;

                trigger BarClicked(Type: Integer; Id: Text)
                var
                    Dim: Integer;
                    SystemFilter: Record lvngSystemCalculationFilter temporary;
                    Idx: Integer;
                    StatisticNames: array[5] of Text;
                    StatisticValues: array[5] of Text;
                    CalculationUnit: Record lvngCalculationUnit;
                    NumberFormat: Record lvngPerformanceNumberFormat;
                begin
                    SystemFilter."Date From" := FromDate;
                    SystemFilter."Date To" := ToDate;
                    if Type = -1 then
                        Dim := -1
                    else begin
                        Dim := BranchPortalLevels[Type + 1];
                        if Dim = 0 then
                            Dim := 5;
                    end;
                    if Dim <> -1 then
                        SetSystemDimensionFilter(SystemFilter, Dim, Id);
                    for Idx := 1 to 5 do begin
                        if CalculationUnit.Get(BranchPortalMgmt.GetCalcUnitConsumerId(), MetricCodes[Idx]) then begin
                            if not NumberFormat.Get(MetricNumberFormats[Idx]) then
                                Clear(NumberFormat);
                            StatisticNames[Idx] := CalculationUnit.Description;
                            StatisticValues[Idx] := BranchPortalMgmt.FormatNumber(NumberFormat, BranchPortalMgmt.CalculateSingleValue(CalculationUnit, SystemFilter));
                        end;
                    end;
                    CurrPage.Dashboard.SetMainParameters(StatisticNames[1], StatisticValues[1], StatisticNames[2], StatisticValues[2], StatisticNames[3], StatisticValues[3], StatisticNames[4], StatisticValues[4], StatisticNames[5], StatisticValues[5]);
                    UpdateChart(1, SystemFilter);
                    UpdateChart(2, SystemFilter);
                end;

                trigger ActionInvoked(ActionId: Text; BarType: Integer; BarId: Text)
                var
                    Int: Integer;
                begin
                    case ActionId[1] of
                        'B':
                            begin
                                //button
                                Evaluate(Int, DelStr(ActionId, 1, 1));
                                DashboardActionInvoked(Int, BarType, BarId);
                            end;
                        'P':
                            DashboardPerfDropdownItemSelected(ActionId, BarType, BarId)
                        else
                            DashboardDropdownItemSelected(ActionId, BarType, BarId);

                    end;
                end;
            }
            fixed(Fix)
            {
                grid(Charts)
                {
                    GridLayout = Columns;

                    group(LeftChart)
                    {
                        ShowCaption = false;

                        field(StatusText1; StatusText[1]) { ApplicationArea = All; }
                        usercontrol(BusinessChart1; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                        {
                            trigger AddInReady()
                            begin
                                ProgressReadyState();
                            end;
                        }
                    }
                    group(RightChart)
                    {
                        ShowCaption = false;

                        field(StatusText2; StatusText[2]) { ApplicationArea = All; }
                        usercontrol(BusinessChart2; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                        {
                            trigger AddInReady()
                            begin
                                ProgressReadyState();
                            end;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        BranchPortalSetup: Record lvngBranchPortalSetup;
        LoanVisionSetup: Record lvngLoanVisionSetup;
        BranchUser: Record lvngBranchUser;
        TempBranchUserMapping: Record lvngBranchUserMapping temporary;
        CorporateLbl: Label 'Corporate';
        PerformanceWorksheetLbl: Label 'Performance Worksheet';
        KPILbl: Label 'KPI';
        GeneralLedgerLbl: Label 'General Ledger';
        LoanLevelReportLbl: Label 'Loan Fundings';
        BranchPortalMgmt: Codeunit lvngBranchPortalManagement;
        StatusText: array[2] of Text;
        LineValues: array[3] of Text;
        Description: Text;
        BranchPortalLevels: array[5] of Integer;
        MetricCodes: array[5] of Code[20];
        MetricNumberFormats: array[5] of Code[20];
        TileCodes: array[3] of Code[20];
        TileNumberFormats: array[3] of Code[20];
        LineNames: array[3] of Text;
        DimensionCodeLookup: array[6] of Code[20];
        FromDate: Date;
        ToDate: Date;
        ReadyState: Integer;
        ValueToCalculate: Enum lvngChartCalculatedValue;

    trigger OnOpenPage()
    var
        BranchUserMapping: Record lvngBranchUserMapping;
    begin
        GeneralLedgerSetup.Get();
        BranchPortalSetup.Get();
        LoanVisionSetup.Get();
        BranchPortalLevels[1] := BranchPortalMgmt.EnumToInt(LoanVisionSetup.lvngLevel1);
        BranchPortalLevels[2] := BranchPortalMgmt.EnumToInt(LoanVisionSetup.lvngLevel2);
        BranchPortalLevels[3] := BranchPortalMgmt.EnumToInt(LoanVisionSetup.lvngLevel3);
        BranchPortalLevels[4] := BranchPortalMgmt.EnumToInt(LoanVisionSetup.lvngLevel4);
        BranchPortalLevels[5] := BranchPortalMgmt.EnumToInt(LoanVisionSetup.lvngLevel5);
        MetricCodes[1] := BranchPortalSetup."Metric 1 Calculation Code";
        MetricCodes[2] := BranchPortalSetup."Metric 2 Calculation Code";
        MetricCodes[3] := BranchPortalSetup."Metric 3 Calculation Code";
        MetricCodes[4] := BranchPortalSetup."Metric 4 Calculation Code";
        MetricCodes[5] := BranchPortalSetup."Metric 5 Calculation Code";
        MetricNumberFormats[1] := BranchPortalSetup."Metric 1 Number Format";
        MetricNumberFormats[2] := BranchPortalSetup."Metric 2 Number Format";
        MetricNumberFormats[3] := BranchPortalSetup."Metric 3 Number Format";
        MetricNumberFormats[4] := BranchPortalSetup."Metric 4 Number Format";
        MetricNumberFormats[5] := BranchPortalSetup."Metric 5 Number Format";
        TileCodes[1] := BranchPortalSetup."Tile Metric 1 Calculation Code";
        TileCodes[2] := BranchPortalSetup."Tile Metric 2 Calculation Code";
        TileCodes[3] := BranchPortalSetup."Tile Metric 3 Calculation Code";
        TileNumberFormats[1] := BranchPortalSetup."Tile Metric 1 Number Format";
        TileNumberFormats[2] := BranchPortalSetup."Tile Metric 2 Number Format";
        TileNumberFormats[3] := BranchPortalSetup."Tile Metric 3 Number Format";
        LineNames[1] := BranchPortalSetup."Tile 1 Name" + ': ';
        LineNames[2] := BranchPortalSetup."Tile 2 Name" + ': ';
        LineNames[3] := BranchPortalSetup."Tile 3 Name" + ': ';
        StatusText[1] := Format(BranchPortalSetup."Default Chart 1");
        StatusText[2] := Format(BranchPortalSetup."Default Chart 2");
        BranchUserMapping.Reset();
        BranchUserMapping.SetRange("User ID", UserId());
        if BranchUserMapping.FindSet() then
            repeat
                TempBranchUserMapping := BranchUserMapping;
                TempBranchUserMapping.Insert();
            until BranchUserMapping.Next() = 0;
        BranchUser.Get(UserId());
        FromDate := DMY2Date(1, 1, Date2DMY(WorkDate(), 3));
        ToDate := WorkDate();
        if BranchPortalSetup."Block Data To Date" <> 0D then begin
            if FromDate <= BranchPortalSetup."Block Data To Date" then
                FromDate := BranchPortalSetup."Block Data To Date" + 1;
            if ToDate <= BranchPortalSetup."Block Data To Date" then
                ToDate := BranchPortalSetup."Block Data To Date" + 1;
        end;
        if BranchPortalSetup."Block Data From Date" <> 0D then begin
            if FromDate >= BranchPortalSetup."Block Data From Date" then
                FromDate := BranchPortalSetup."Block Data From Date" - 1;
            if ToDate >= BranchPortalSetup."Block Data From Date" then
                ToDate := BranchPortalSetup."Block Data From Date" - 1;
        end;
        DimensionCodeLookup[1] := ''; //Empty value for Business Unit
        DimensionCodeLookup[2] := GeneralLedgerSetup."Global Dimension 1 Code";
        DimensionCodeLookup[3] := GeneralLedgerSetup."Global Dimension 2 Code";
        DimensionCodeLookup[4] := GeneralLedgerSetup."Shortcut Dimension 3 Code";
        DimensionCodeLookup[5] := GeneralLedgerSetup."Shortcut Dimension 4 Code";
        DimensionCodeLookup[6] := ''; //Empty value for Business Unit where it is used as 5th dimension
        ValueToCalculate := ValueToCalculate::Amount;
    end;

    local procedure ProgressReadyState()
    begin
        ReadyState := ReadyState + 1;
        if ReadyState = 3 then
            CurrPage.Dashboard.LoadButtons(CreateButtons());
    end;

    local procedure UpdateData()
    begin
        if BranchUser."Show Corporate Tile" then begin
            CalcTileMetrics(-1, '');
            AddBar(0, -1, 'corporate', Description, LineValues[1], LineValues[2], LineValues[3], '', true);
        end;
        TempBranchUserMapping.Reset();
        TempBranchUserMapping.SetCurrentKey(Sequence);
        TempBranchUserMapping.SetFilter(Sequence, '<>0');
        if TempBranchUserMapping.FindSet() then
            repeat
                CalcTileMetrics(BranchPortalMgmt.EnumToInt(TempBranchUserMapping.Type), TempBranchUserMapping.Code);
                AddBar(BranchPortalMgmt.EnumToInt(TempBranchUserMapping.Type) + 1, BranchPortalMgmt.EnumToInt(TempBranchUserMapping.Type), TempBranchUserMapping.Code, Description, LineValues[1], LineValues[2], LineValues[3], '', true);
            until TempBranchUserMapping.Next() = 0;
    end;

    local procedure AddBar(ColorIdx: Integer; Type: Integer; Id: Text; Description: Text; Amt1: Text; Amt2: Text; Amt3: Text; ColorAmt3: Text; BoldAmt3: Boolean)
    var
        CustomColor: Text;
    begin
        case ColorIdx of
            0:
                CustomColor := BranchPortalSetup."Corporate Tile Color";
            1:
                CustomColor := BranchPortalSetup."Level 1 Tile Color";
            2:
                CustomColor := BranchPortalSetup."Level 2 Tile Color";
            3:
                CustomColor := BranchPortalSetup."Level 3 Tile Color";
            4:
                CustomColor := BranchPortalSetup."Level 4 Tile Color";
            5:
                CustomColor := BranchPortalSetup."Level 5 Tile Color";
        end;
        if CustomColor = '' then
            CurrPage.Dashboard.AddBar(ColorIdx, Type, Id, Description, Amt1, Amt2, Amt3, ColorAmt3, BoldAmt3)
        else
            CurrPage.Dashboard.AddBar(CustomColor, Type, Id, Description, Amt1, Amt2, Amt3, ColorAmt3, BoldAmt3);
    end;

    local procedure CalcTileMetrics(Level: Integer; MappingCode: Code[20])
    var
        CalculationUnit: Record lvngCalculationUnit;
        BusinessUnit: Record "Business Unit";
        DimensionValue: Record "Dimension Value";
        LevelType: Integer;
        DimensionCode: Code[20];
        Idx: Integer;
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        NumberFormat: Record lvngPerformanceNumberFormat;
    begin
        Clear(LineValues);
        Description := '';
        if Level = -1 then
            LevelType := -1
        else
            LevelType := BranchPortalLevels[Level + 1];
        case LevelType of
            -1:
                Description := CorporateLbl;
            0:
                begin
                    BusinessUnit.Get(MappingCode);
                    Description := BusinessUnit.Name;
                end
            else begin
                    DimensionCode := DimensionCodeLookup[LevelType + 1];
                    DimensionValue.Get(DimensionCode, MappingCode);
                    Description := DimensionValue.Name;
                end;
        end;
        for Idx := 1 to 3 do begin
            if CalculationUnit.Get(BranchPortalMgmt.GetCalcUnitConsumerId(), TileCodes[Idx]) then begin
                if not NumberFormat.Get(TileNumberFormats[Idx]) then
                    Clear(NumberFormat);
                Clear(SystemFilter);
                SystemFilter."Date From" := FromDate;
                SystemFilter."Date To" := ToDate;
                case LevelType of
                    -1:
                        ;
                    0:
                        SystemFilter."Business Unit" := BusinessUnit.Code
                    else
                        SetSystemDimensionFilter(SystemFilter, LevelType, DimensionValue.Code);
                end;
                LineValues[Idx] := LineNames[Idx] + BranchPortalMgmt.FormatNumber(NumberFormat, BranchPortalMgmt.CalculateSingleValue(CalculationUnit, SystemFilter));
            end;
        end;
    end;

    local procedure SetSystemDimensionFilter(var SystemFilter: Record lvngSystemCalculationFilter; Dimension: Integer; Filter: Text)
    begin
        case Dimension of
            1:
                SystemFilter."Shortcut Dimension 1" := Filter;
            2:
                SystemFilter."Shortcut Dimension 2" := Filter;
            3:
                SystemFilter."Shortcut Dimension 3" := Filter;
            4:
                SystemFilter."Shortcut Dimension 4" := Filter;
            0, 5:
                SystemFilter."Business Unit" := Filter;
        end;
    end;

    local procedure CreateButtons() Json: JsonArray
    var
        Obj: JsonObject;
        Arr: JsonArray;
        BranchPerfSchemaMapping: Record lvngBranchPerfSchemaMapping;
    begin
        Clear(Json);
        if (not BranchUser."Hide Performance Worksheet") and (not BranchPortalSetup."Hide Performance Worksheet") then begin
            Clear(Obj);
            Json.Add(Obj);
            Obj.Add('text', PerformanceWorksheetLbl);
            Obj.Add('type', 'default');
            Obj.Add('width', 220);
            Clear(Arr);
            Obj.Add('dropdown', Arr);
            BranchPerfSchemaMapping.Reset();
            BranchPerfSchemaMapping.SetCurrentKey(Sequence);
            BranchPerfSchemaMapping.SetRange("User ID", UserId());
            if BranchPerfSchemaMapping.IsEmpty() then
                BranchPerfSchemaMapping.SetRange("User ID", '');
            if BranchPerfSchemaMapping.FindSet() then
                repeat
                    Arr.Add(CreatePerformanceButton(BranchPerfSchemaMapping));
                until BranchPerfSchemaMapping.Next() = 0;
        end;
        if (not BranchUser."Hide KPI") and (not BranchPortalSetup."Hide KPI") then
            Json.Add(CreateSimpleButton(KPILbl, 'default', 160, 'B2'));
        if (not BranchUser."Hide General Ledger") and (not BranchPortalSetup."Hide General Ledger") then
            Json.Add(CreateSimpleButton(GeneralLedgerLbl, 'default', 160, 'B3'));
        if BranchPortalSetup."Show Loan Level Report" or BranchUser."Show Loan Funding Report" then
            Json.Add(CreateSimpleButton(LoanLevelReportLbl, 'default', 160, 'B4'));
    end;

    local procedure CreatePerformanceButton(var BranchPerformanceSchemaMapping: Record lvngBranchPerfSchemaMapping) Obj: JsonObject
    begin
        Clear(Obj);
        if BranchPerformanceSchemaMapping.Description = '' then
            Obj.Add('text', BranchPerformanceSchemaMapping."Schema Code" + '-' + BranchPerformanceSchemaMapping."Layout Code")
        else
            Obj.Add('text', BranchPerformanceSchemaMapping.Description);
        Obj.Add('id', 'P' + Format(BranchPerformanceSchemaMapping."Unique ID"));
    end;

    local procedure CreateSimpleButton(Text: Text; Type: Text; Width: Integer; Tag: Text) Obj: JsonObject
    begin
        Clear(Obj);
        Obj.Add('text', Text);
        Obj.Add('type', Type);
        Obj.Add('width', Width);
        Obj.Add('tag', tag);
    end;

    local procedure UpdateChart(ChartIdx: Integer; var SystemFilter: Record lvngSystemCalculationFilter)
    var
        ChartType: Enum lvngPerformanceChartType;
        ChartKind: Enum lvngChartKind;
        BranchPortalChartMgmt: Codeunit lvngBranchPortalChartMgmt;
        BusinessChartBuffer: Record "Business Chart Buffer" temporary;
    begin
        SetActionButtonsVisible(ChartIdx, false);
        if ChartIdx = 1 then begin
            ChartType := BranchPortalSetup."Default Chart 1";
            ChartKind := BranchPortalSetup."Chart 1 Type";
        end else begin
            ChartType := BranchPortalSetup."Default Chart 2";
            ChartKind := BranchPortalSetup."Chart 2 Type";
        end;
        case ChartType of
            ChartType::"Loans Funded By Loan Type":
                BranchPortalChartMgmt.UpdateDataForLoansFundedByLoanType(BusinessChartBuffer, ChartKind, ValueToCalculate, SystemFilter);
            ChartType::"Loans Funded By LO":
                BranchPortalChartMgmt.UpdateDataForLoansFundedByLO(BusinessChartBuffer, ChartKind, ValueToCalculate, SystemFilter);
            ChartType::"Loans Funded By Branch":
                BranchPortalChartMgmt.UpdateDataForLoansFundedByBranch(BusinessChartBuffer, ChartKind, ValueToCalculate, SystemFilter);
            ChartType::"Average Days To Sell":
                begin
                    BranchPortalChartMgmt.UpdateDataForLoansByAverageDaysToSell();
                    SetActionButtonsVisible(ChartIdx, true);
                end;
            ChartType::"Average Days To Fund":
                begin
                    BranchPortalChartMgmt.UpdateDataForLoansByAverageDaysToFund();
                    SetActionButtonsVisible(ChartIdx, true);
                end;
        end;
        if ChartIdx = 1 then
            BusinessChartBuffer.Update(CurrPage.BusinessChart1)
        else
            BusinessChartBuffer.Update(CurrPage.BusinessChart2);
        CurrPage.Update(false);
    end;

    local procedure SetActionButtonsVisible(ChartIdx: Integer; Visible: Boolean)
    begin
        Error('Not Implemented');
    end;

    local procedure DashboardActionInvoked(Action: Integer; BarType: Integer; Id: Text)
    begin
        case Action of
            4:
                begin
                    Error('Not Implemented');
                end;
            3:
                begin
                    Error('Not Implemented');
                end;
            2:
                begin
                    Error('Not Implemented');
                end;
        end;
    end;

    local procedure DashboardPerfDropdownItemSelected(Id: Text; BarType: Integer; Code: Text)
    var
        BranchPerfSchemaMapping: Record lvngBranchPerfSchemaMapping;
        BranchPerformance: Page lvngBranchPerformanceView;
        Idx: Integer;
    begin
        Evaluate(Idx, CopyStr(Id, 2));
        BranchPerfSchemaMapping.Reset();
        BranchPerfSchemaMapping.SetRange("Unique ID", Idx);
        BranchPerfSchemaMapping.FindFirst();
        if BranchPerfSchemaMapping."Based On" = BranchPerfSchemaMapping."Based On"::Periods then begin
            Clear(BranchPerformance);
            if BarType = -1 then
                BranchPerformance.SetParams(-1, Code, ToDate)
            else
                BranchPerformance.SetParams(BranchPortalLevels[BarType + 1], Code, ToDate);
            BranchPerformance.SetSchemaCode(BranchPerfSchemaMapping."Schema Code", BranchPerfSchemaMapping."Layout Code", BranchPerfSchemaMapping."Column Grouping Code");
            BranchPerformance.Run();
        end else begin
            Error('Not Implemented');
        end;
    end;

    local procedure DashboardDropdownItemSelected(Id: Text; BarType: Integer; Code: Text)
    begin
        Error('Not Implemented');
    end;
}