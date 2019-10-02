control = $('#controlAddIn');
picker = $('<div></div>');
control.append(picker);
picker.dxColorView({
    onValueChanged: ValueChanged
});
picker.children().css('margin', '16px auto');
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddInReady');
