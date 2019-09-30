controladdin ColorPickerControl
{
    Scripts = 'CommonResources/js/jquery.min.js',
        'CommonResources/js/dx.all.js',
        'ControlAddIns/ColorPickerControl/js/script.js';
    StartupScript = 'ControlAddIns/ColorPickerControl/js/init.js';
    StyleSheets = 'CommonResources/css/dx.common.css',
        'CommonResources/css/dx.light.css';
    VerticalStretch = false;
    HorizontalStretch = true;
    RequestedHeight = 400;

    event AddInReady();
    event ValueChanged(Value: Text);
    procedure SetValue(Value: Text);
}