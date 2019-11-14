page 14135407 lvngBranchPortalKPI
{
    PageType = Card;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    Caption = 'Branch Portal KPI';

    layout
    {
        area(Content)
        {
            group(Parameters)
            {
                field(DateFilter; SystemFilter."Date Filter") { ApplicationArea = All; Editable = false; Caption = 'Date Filter'; }
                field(Dim1Filter; SystemFilter."Shortcut Dimension 1") { ApplicationArea = All; Editable = false; CaptionClass = '1,3,1'; Visible = Dim1Visible; }
                field(Dim2Filter; SystemFilter."Shortcut Dimension 2") { ApplicationArea = All; Editable = false; CaptionClass = '1,3,2'; Visible = Dim2Visible; }
                field(Dim3Filter; SystemFilter."Shortcut Dimension 3") { ApplicationArea = All; Editable = false; CaptionClass = '1,2,3'; Visible = Dim3Visible; }
                field(Dim4Filter; SystemFilter."Shortcut Dimension 4") { ApplicationArea = All; Editable = false; CaptionClass = '1,2,4'; Visible = Dim4Visible; }
                field(BUFilter; SystemFilter."Business Unit") { ApplicationArea = All; Editable = false; Caption = 'Business Unit Filter'; Visible = BUVisible; }
            }
            part(LoansByLoanType; lvngBranchKPIChartPart) { ApplicationArea = All; Caption = 'Funded by Loan Type'; }
            part(LoansByLO; lvngBranchKPIChartPart) { ApplicationArea = All; Caption = 'Funded by Loan Officer'; }
            part(LoansByBranch; lvngBranchKPIChartPart) { ApplicationArea = All; Caption = 'Funded by Branch'; }
            part(LoansByInvestor; lvngBranchKPIChartPart) { ApplicationArea = All; Caption = 'Sold by Investor'; }
            part(DaysAvgToFund; lvngBranchKPIChartPart) { ApplicationArea = All; Caption = 'Average Days to Fund'; }
            part(DaysAvgToSell; lvngBranchKPIChartPart) { ApplicationArea = All; Caption = 'Average Days to Sell'; }
        }
    }

    var
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        BUVisible: Boolean;
        Dim1Visible: Boolean;
        Dim2Visible: Boolean;
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;

    procedure SetParams(var Filter: Record lvngSystemCalculationFilter)
    var
        ChartType: Enum lvngDashboardChartType;
    begin
        SystemFilter := Filter;
        BUVisible := SystemFilter."Business Unit" <> '';
        Dim1Visible := SystemFilter."Shortcut Dimension 1" <> '';
        Dim2Visible := SystemFilter."Shortcut Dimension 2" <> '';
        Dim3Visible := SystemFilter."Shortcut Dimension 3" <> '';
        Dim4Visible := SystemFilter."Shortcut Dimension 4" <> '';
        CurrPage.LoansByLoanType.Page.SetParams(SystemFilter, ChartType::lvngFundedAmountByType);
        CurrPage.LoansByLO.Page.SetParams(SystemFilter, ChartType::lvngFundedAmountByLO);
        CurrPage.LoansByBranch.Page.SetParams(SystemFilter, ChartType::lvngFundedAmountByBranch);
        CurrPage.LoansByInvestor.Page.SetParams(SystemFilter, ChartType::lvngSoldAmountByInvestor);
        CurrPage.DaysAvgToFund.Page.SetParams(SystemFilter, ChartType::lvngAvgDaysToFundByBranch);
        CurrPage.DaysAvgToSell.Page.SetParams(SystemFilter, ChartType::lvngAvgDaysToSellByBranch);
    end;
}