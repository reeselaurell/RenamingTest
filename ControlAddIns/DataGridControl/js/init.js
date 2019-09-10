control = $('#controlAddIn');
CreateInfrastructure();
try {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddInReady');
}
catch (error) {
    alert(error);
}
