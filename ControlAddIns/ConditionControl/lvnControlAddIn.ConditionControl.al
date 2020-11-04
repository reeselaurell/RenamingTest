controladdin "lvnConditionControl"
{
    Scripts = 'Resources/js/jquery.min.js',
        'ControlAddIns/ConditionControl/js/script.js',
        'ControlAddIns/ConditionControl/js/ConditionControl.js';
    StartupScript = 'ControlAddIns/ConditionControl/js/init.js';
    StyleSheets = 'ControlAddIns/ConditionControl/css/style.css';
    VerticalStretch = false;
    HorizontalStretch = true;
    RequestedWidth = 800;
    RequestedHeight = 300;

    event AddInReady();
    procedure LoadFields(Data: JsonArray);
    procedure AppendLine(LeftHand: Text; Comparisson: Text; RightHand: Text);
    procedure DumpLines();
    event ConditionDataError(Data: Text);
    event ReportLines(Data: JsonArray);
    event EditFormula(Id: Text; Left: Boolean; Value: Text);
    procedure ApplyFormula(Id: Text; Left: Boolean; Formula: Text);
    procedure RestoreFormula(Id: Text; Left: Boolean);
    event ItemAdded();
    event ItemRemoved();
}