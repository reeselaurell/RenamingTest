controladdin DataGridControl
{
    Scripts = 'Resources/js/jquery.min.js',
        //'Resources/js/globalize.min.js',
        'Resources/js/dx.all.js',
        'ControlAddIns/DataGridControl/js/jss.min.js',
        'ControlAddIns/DataGridControl/js/jszip.min.js',
        'ControlAddIns/DataGridControl/js/script.js';
    StartupScript = 'ControlAddIns/DataGridControl/js/init.js';
    StyleSheets = 'Resources/css/dx.common.css',
        'Resources/css/dx.light.css',
        'ControlAddIns/DataGridControl/css/style.css';
    VerticalStretch = false;
    HorizontalStretch = true;
    RequestedHeight = 680;

    event AddInReady();
    event CellClick(BandIndex: Integer; ColIndex: Integer; RowIndex: Integer);
    procedure InitializeDXGrid(Json: JsonObject);
    procedure SetupStyles(Json: JsonObject);
    procedure ExportToExcel();
    procedure Print();
    procedure SetHeight(NewHeight: Integer);
}