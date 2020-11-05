controladdin "lvnPredicateControl"
{
    Scripts = 'Resources/js/jquery.min.js',
        'ControlAddIns/PredicateControl/js/script.js',
        'ControlAddIns/PredicateControl/js/PredicateControl.js';
    StartupScript = 'ControlAddIns/PredicateControl/js/init.js';
    StyleSheets = 'ControlAddIns/PredicateControl/css/style.css';
    VerticalStretch = false;
    HorizontalStretch = true;
    RequestedWidth = 800;
    RequestedHeight = 200;

    event AddInReady();
    procedure LoadFields(Data: JsonArray);
    procedure SetPredicate(Left: Text; Comparison: Text; Right: Text);
    procedure RequestPredicate();
    event PredicateResponse(Left: Text; Comparison: Text; Right: Text);
    event PredicateDataError(Data: Text);
    event EditFormula(Left: Boolean; Value: Text);
    procedure ApplyFormula(Left: Boolean; Formula: Text);
    procedure RestoreFormula(Left: Boolean);
}