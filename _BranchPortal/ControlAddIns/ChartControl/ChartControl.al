controladdin ChartControl
{
    VerticalStretch = true;
    HorizontalStretch = true;
    RequestedHeight = 350;

    event AddInReady();
    procedure LoadChart(Json: JsonObject);
    //event ChartClicked(Series: Text; Argument: Text; Value: Text);
}