controladdin "FormulaControl"
{
    Scripts = 'ControlAddIns/FormulaControl/js/FormulaControl.js',
        'Resources/js/jquery.min.js',
        'ControlAddIns/FormulaControl/js/rangyinputs-jquery-1.1.2.min.js',
        'ControlAddIns/FormulaControl/js/script.js';
    StartupScript = 'ControlAddIns/FormulaControl/js/init.js';
    StyleSheets = 'ControlAddIns/FormulaControl/css/style.css';
    VerticalStretch = false;
    HorizontalStretch = true;
    RequestedWidth = 800;
    RequestedHeight = 300;

    event AddInReady();
    procedure LoadFields(Data: JsonArray);
    procedure LoadFormula(Formula: Text);
    procedure PrepareFormulaData();
    event FormulaDataReady(Data: Text);
    event VerifyFormula(Formula: Text);
}