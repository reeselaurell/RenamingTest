$('html').click(function () {
    $('div.combobox').removeClass('dd');
});
control = $('#controlAddIn');
var dom = $('<div></div>').append($.parseHTML(FormulaControl));
control.append(dom);
$('a').on('dragstart', function (e) { e.preventDefault(); });
$('.combobox.field').change(function () {
    var ctl = $(this);
    var obj = ctl.data('item');
    if (obj) {
        ctl.data('item', null);
        ctl.find('input').val('');
        ctl.find('li.selected').removeClass('selected');
        AddFormulaPart('[' + obj.n + ']');
    };
});
formula = $('div.formula > textarea');
formula.css('height', $(document).innerHeight() - $('div.toolbar').outerHeight() - 12 + 'px');
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddInReady');
