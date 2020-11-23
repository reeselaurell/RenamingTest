controladdin "lvnColorPickerControl"
{
    Scripts = 'Resources/js/jquery.min.js',
        'Resources/js/dx.all.js',
        'ControlAddIns/ColorPickerControl/js/script.js';
    StartupScript = 'ControlAddIns/ColorPickerControl/js/init.js';
    StyleSheets = 'Resources/css/dx.common.css',
        'Resources/css/dx.light.css';
    VerticalStretch = false;
    HorizontalStretch = true;
    RequestedHeight = 400;

    event AddInReady();
    event ValueChanged(Value: Text);
    procedure SetValue(Value: Text);
}