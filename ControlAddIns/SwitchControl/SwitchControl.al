controladdin SwitchControl
{
    Scripts = 'CommonResources/js/jquery.min.js',
        'ControlAddIns/SwitchControl/js/script.js',
        'ControlAddIns/SwitchControl/js/SwitchControl.js';
    StartupScript = 'ControlAddIns/SwitchControl/js/init.js';
    StyleSheets = 'ControlAddIns/SwitchControl/css/style.css';
    VerticalStretch = false;
    HorizontalStretch = true;
    RequestedWidth = 800;
    RequestedHeight = 300;

    event AddInReady();
    procedure LoadFields(Data: JsonArray);
    procedure OptimizeForPredicate();
    procedure AppendLine(Predicate: Text; Returns: Text);
    procedure DumpLines();
    event SwitchDataError(Data: Text);
    event ReportLines(Data: JsonArray);
    event EditFormula(Id: Text; Value: Text);
    procedure ApplyFormula(Id: Text; Cancel: Boolean; Formula: Text);
}