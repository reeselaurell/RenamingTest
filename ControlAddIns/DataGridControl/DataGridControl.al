controladdin DataGridControl
{
    Scripts = 'CommonResources/js/jquery.min.js',
        'CommonResources/js/globalize.min.js',
        'CommonResources/js/dx.all.js',
        'ControlAddIns/DataGridControl/js/jss.min.js',
        'ControlAddIns/DataGridControl/js/jszip.min.js',
        'ControlAddIns/DataGridControl/js/script.js';
    StartupScript = 'ControlAddIns/DataGridControl/js/init.js';
    StyleSheets = 'CommonResources/css/dx.common.css',
        'CommonResources/css/dx.light.css',
        'ControlAddIns/DataGridControl/css/style.css';
    VerticalStretch = false;
    HorizontalStretch = true;
    RequestedHeight = 680;

    event AddInReady();
    event CellClick(ColIndex: Integer; RowIndex: Integer);
    procedure InitializeDXGrid(Json: JsonObject);
    procedure SetupStyles(Json: JsonObject);
    procedure ExportToExcel();
    procedure Print();
}