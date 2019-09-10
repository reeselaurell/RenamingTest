$('html').click(function () {
    $('div.combobox').removeClass('dd');
});
control = $('#controlAddIn');
condition_host = $('<div></div>');
control.append(condition_host);
var dom = $('<div></div>').append($.parseHTML(SwitchControl));
var nc = dom.find('#new-condition');
control.append(nc);
nc.find('button').click(function () {
    AppendCondition();
});
condition_template = dom.find('#condition-template');
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddInReady');
