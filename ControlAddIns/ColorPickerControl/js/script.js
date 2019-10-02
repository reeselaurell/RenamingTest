var control = undefined;
var picker = undefined;

function SetValue(value) {
    $(picker).dxColorView('option', 'value', value);
}

function ValueChanged(e) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ValueChanged', [e.value]);
}
