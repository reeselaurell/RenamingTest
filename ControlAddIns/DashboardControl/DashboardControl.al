controladdin DashboardControl
{
    Scripts = 'CommonResources/js/jquery-2.1.4.min.js',
        'CommonResources/js/globalize.min.js',
        'CommonResources/js/dx.all.js',
        'ControlAddIns/DashboardControl/js/Dashboard.js',
        'ControlAddIns/DashboardControl/js/script.js';
    StartupScript = 'ControlAddIns/DashboardControl/js/init.js';
    StyleSheets = 'CommonResources/css/dx.common.css',
        'CommonResources/css/dx.light.css',
        'ControlAddIns/DashboardControl/css/style.css';
    VerticalStretch = false;
    HorizontalStretch = false;
    RequestedHeight = 350;
    RequestedWidth = 1200;

    event AddInReady();
    event DateRangeChanged(DateFrom: Text; DateTo: Text);
    event BarClicked(Type: Integer; Id: Text);
    event ChartClicked(Name: Text; Series: Text; Argument: Text; Value: Text);
    event ActionInvoked(ActionId: Text; BarType: Integer; BarId: Text);
    procedure ClearBars();
    procedure AddBar(ColorIndex: Integer; Type: Integer; Id: Text; Description: Text; Amt1: Text; Amt2: Text; Amt3: Text; ColorAmt3: Text; BoldAmt3: Boolean);
    procedure AddBar(HtmlColor: Text; Type: Integer; Id: Text; Description: Text; Amt1: Text; Amt2: Text; Amt3: Text; ColorAmt3: Text; BoldAmt3: Boolean);
    procedure LoadChart(Id: Text; Json: JsonObject);
    procedure SetMainParameters(Name1: Text; Value1: Text; Name2: Text; Value2: Text; Name3: Text; Value3: Text; Name4: Text; Value4: Text; Name5: Text; Value5: Text);
    procedure LoadButtons(Json: JsonArray);
    procedure SetDateRange(DateFrom: Date; DateTo: Date);
    procedure AddBarContainer(Id: Text);
    procedure AddBarToContainer(ContainerId: Text; ColorIndex: Integer; Type: Integer; Id: Text; Description: Text; Amt1: Text; Amt2: Text; Amt3: Text; ColorAmt3: Text; BoldAmt3: Boolean);
    procedure AddColorBarToContainer(ContainerId: Text; HtmlColor: Text; Type: Integer; Id: Text; Description: Text; Amt1: Text; Amt2: Text; Amt3: Text; ColorAmt3: Text; BoldAmt3: Boolean);
}