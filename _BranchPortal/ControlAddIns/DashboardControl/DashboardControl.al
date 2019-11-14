controladdin DashboardControl
{
    VerticalStretch = true;
    HorizontalStretch = false;
    RequestedHeight = 900;
    RequestedWidth = 1200;

    event AddInReady();
    event AttemptDateRange(DateFrom: Text; DateTo: Text);
    event TileDataNeeded(Type: Integer; Code: Text);
    event TileClicked(Type: Integer; Code: Text);
    event ButtonClicked(Group: Text; Id: Text; Metadata: Text);
    procedure SetTileData(Type: Integer; Code: Text; Amount1: Text; Amount2: Text; Amount3: Text);
    procedure AdviceDateRange(DateFrom: Date; DateTo: Date);
    procedure LoadTiles(Json: JsonArray);
    procedure LoadButtons(Json: JsonArray);
    procedure ResetTiles(LoadingTxt: Text);
    procedure SetMainParameters(Name1: Text; Value1: Text; Name2: Text; Value2: Text; Name3: Text; Value3: Text; Name4: Text; Value4: Text; Name5: Text; Value5: Text);
    procedure LoadChart(Id: Text; Json: JsonObject);
    //event ChartClicked(Name: Text; Series: Text; Argument: Text; Value: Text);
}