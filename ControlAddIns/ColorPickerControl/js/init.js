control = $('#controlAddIn');
picker = $('<div></div>');
control.append(picker);
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddInReady');
