var control = undefined;
var picker = undefined;

function SetValue(value) {
    if (picker.isInitialized)
        picker.dxColorBox('dispose');
    picker.dxColorBox({
        applyValueMode: 'instantly',
        hoverStateEnabled: false,
        opened: true,
        value: value,
        onValueChanged: ValueChanged
    });
    picker.isInitialized = true;
}

function ValueChanged(e) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ValueChanged', [e.value]);
}
