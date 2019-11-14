page 14135408 lvngBranchKPIChartPart
{
    PageType = CardPart;
    ShowFilter = false;

    layout
    {
        area(Content)
        {
            usercontrol(Chart; ChartControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    LoadChart();
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(ValueToCalculate)
            {
                Caption = 'Value to Calculate';
                Image = Calculate;

                action(Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    Visible = ByValueVisible;

                    trigger OnAction()
                    begin
                        case ChartType of
                            ChartType::lvngFundedCountByBranch:
                                ChartType := ChartType::lvngFundedAmountByBranch;
                            ChartType::lvngFundedCountByLO:
                                ChartType := ChartType::lvngFundedAmountByLO;
                            ChartType::lvngFundedCountByType:
                                ChartType := ChartType::lvngFundedAmountByType;
                            ChartType::lvngSoldCountByInvestor:
                                ChartType := ChartType::lvngSoldAmountByInvestor;
                        end;
                        LoadChart();
                    end;
                }
                action(NoOfLoans)
                {
                    ApplicationArea = All;
                    Caption = 'Loan Count';
                    Visible = ByValueVisible;

                    trigger OnAction()
                    begin
                        case ChartType of
                            ChartType::lvngFundedAmountByBranch:
                                ChartType := ChartType::lvngFundedCountByBranch;
                            ChartType::lvngFundedAmountByLO:
                                ChartType := ChartType::lvngFundedCountByLO;
                            ChartType::lvngFundedAmountByType:
                                ChartType := ChartType::lvngFundedCountByType;
                            ChartType::lvngSoldAmountByInvestor:
                                ChartType := ChartType::lvngSoldCountByInvestor;
                        end;
                        LoadChart();
                    end;
                }
                action(ByBranch)
                {
                    ApplicationArea = All;
                    Caption = 'By Branch';
                    Visible = ByDaysVisible;

                    trigger OnAction()
                    begin
                        case ChartType of
                            ChartType::lvngAvgDaysToFundByLO,
                            ChartType::lvngAvgDaysToFundByType:
                                ChartType := ChartType::lvngAvgDaysToFundByBranch;
                            ChartType::lvngAvgDaysToSellByLO,
                            ChartType::lvngAvgDaysToSellByType:
                                ChartType := ChartType::lvngAvgDaysToSellByBranch;
                        end;
                        LoadChart();
                    end;
                }
                action(ByType)
                {
                    ApplicationArea = All;
                    Caption = 'By Loan Type';
                    Visible = ByDaysVisible;

                    trigger OnAction()
                    begin
                        case ChartType of
                            ChartType::lvngAvgDaysToFundByLO,
                            ChartType::lvngAvgDaysToFundByBranch:
                                ChartType := ChartType::lvngAvgDaysToFundByType;
                            ChartType::lvngAvgDaysToSellByLO,
                            ChartType::lvngAvgDaysToSellByBranch:
                                ChartType := ChartType::lvngAvgDaysToSellByType;
                        end;
                        LoadChart();
                    end;
                }
                action(ByLO)
                {
                    ApplicationArea = All;
                    Caption = 'By Loan Officer';
                    Visible = ByDaysVisible;

                    trigger OnAction()
                    begin
                        case ChartType of
                            ChartType::lvngAvgDaysToFundByBranch,
                            ChartType::lvngAvgDaysToFundByType:
                                ChartType := ChartType::lvngAvgDaysToFundByLO;
                            ChartType::lvngAvgDaysToSellByBranch,
                            ChartType::lvngAvgDaysToSellByType:
                                ChartType := ChartType::lvngAvgDaysToSellByLO;
                        end;
                        LoadChart();
                    end;
                }
            }
            action(Refresh)
            {
                ApplicationArea = All;
                Image = Refresh;

                trigger OnAction()
                begin
                    LoadChart();
                end;
            }
        }
    }

    var
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        ChartType: Enum lvngDashboardChartType;
        ChartKind: Enum lvngChartKind;
        ByValueVisible: Boolean;
        ByDaysVisible: Boolean;

    procedure SetParams(var Filter: Record lvngSystemCalculationFilter; Type: Enum lvngDashboardChartType)
    begin
        SystemFilter := Filter;
        ChartType := Type;
        ChartKind := ChartKind::lvngDefault;
        SetActionVisibilityByChartType();
    end;

    local procedure SetActionVisibilityByChartType()
    begin
        ByDaysVisible := ChartType in [ChartType::lvngAvgDaysToSellByType.AsInteger() .. ChartType::lvngAvgDaysToFundByLO.AsInteger()];
        ByValueVisible := not ByDaysVisible;
    end;

    local procedure LoadChart()
    var
        BranchPortalMgmt: Codeunit lvngBranchPortalManagement;
        Json: JsonObject;
        Series: JsonObject;
        Legend: JsonObject;
    begin
        Clear(Json);
        Clear(Series);
        Json.Add('argumentDisplayField', 'z');
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
        CurrPage.Chart.LoadChart(Json);
    end;
}