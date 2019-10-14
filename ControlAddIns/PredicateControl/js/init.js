$('html').click(function () {
    $('div.combobox').removeClass('dd');
});
control = $('#controlAddIn');
var dom = $('<div></div>').append($.parseHTML(PredicateControl));
predicate = dom.find('#predicate');
control.append(predicate);
Initialize();
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddInReady');
