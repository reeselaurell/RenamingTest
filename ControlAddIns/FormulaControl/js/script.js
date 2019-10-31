var control = undefined;
var formula = undefined;
var field_list = [];

function InitControls(dom) {
    InitCombobox(dom);
}
function InitCombobox(dom) {
    dom.find('div.combobox').each(function () {
        var ctl = $(this);
        var sel = undefined;
        var item = undefined;
        var text = ctl.find('input[type=text]');
        ctl.find('div.button-overlay').click(function (e) {
            if (ctl.hasClass('dd'))
                ctl.removeClass('dd');
            else {
                $('div.combobox').removeClass('dd');
                ctl.addClass('dd');
                if (item)
                    item[0].scrollIntoView(false);
            }
        });
        ctl.find('li').mousedown(function () {
            if (sel)
                sel.removeClass('selected');
            sel = $(this);
            sel.addClass('selected');
        }).mouseup(function () {
            if (sel && (sel[0] === this)) {
                ctl.removeClass('dd');
                if (ctl.hasClass('autofilter'))
                    ctl.find('li').css('display', '');
                item = sel;
                ctl.data('item', item.data('object'));
                text.val(item.text());
                ctl.trigger('change');
            }
        });
        ctl.click(function (e) {
            if (ctl.hasClass('dd'))
                e.stopPropagation();
        });
        text.focus(function () {
            ctl.removeClass('dd');
        });
        if (ctl.hasClass('autofilter')) {
            var timer = null;
            function reRunTimer() {
                if (timer)
                    window.clearTimeout(timer);
                window.setTimeout(function () {
                    if (sel) {
                        sel.removeClass('selected');
                        sel = null;
                        item = null;
                        ctl.data('item', null);
                        ctl.trigger('change');
                    }
                    ctl.find('li').each(function () {
                        var li = $(this);
                        li.css('display', li.text().toLowerCase().indexOf(text.val().toLowerCase()) == -1 ? 'none' : '');
                    });
                }, 200);
            }
            text.keypress(function () {
                if (!ctl.hasClass('dd'))
                    ctl.addClass('dd');
                reRunTimer();
            }).keyup(function (e) {
                if (e.which == 8 || e.which == 46) {
                    //backspace and delete
                    if (!ctl.hasClass('dd'))
                        ctl.addClass('dd');
                    reRunTimer();
                }
            }).keydown(function (e) {
                if (e.which == 13) {
                    //enter
                    e.preventDefault();
                    if (sel) {
                        ctl.removeClass('dd');
                        ctl.find('li').css('display', '');
                        text.val(sel.text());
                        item = sel;
                        ctl.data('item', item.data('object'));
                        ctl.trigger('change');
                    }
                }
                else if (e.which == 40 || e.which == 38) {
                    var next = e.which == 40 ? (sel ? sel.nextAll(':visible').first() : ctl.find('ul > li:visible').first()) : (sel ? sel.prevAll(':visible').first() : ctl.find('ul > li:visible').last());
                    if (sel)
                        sel.removeClass('selected');
                    sel = null;
                    if (next.length > 0) {
                        sel = next;
                        sel.addClass('selected');
                        sel[0].scrollIntoView(false);
                    }
                }
            });
        }
    });
}

/* Implementation of exposed methods */
function LoadFields(data) {
    try {
        field_list = data;
        field_list.sort(function (a, b) { return a.n < b.n ? -1 : a.n > b.n ? 1 : 0; });
        var ul = control.find('.field ul');
        for (var i = 0; i < field_list.length; i++) {
            var li = $('<li></li>');
            li.data('object', field_list[i]);
            if (field_list[i].n == '')
                li.html('&nbsp;');
            else
                li.text(field_list[i].n);
            ul.append(li);
        }
        InitControls(control);
    }
    catch (e) {
        alert(e);
    }
}
function LoadFormula(f)
{
    formula.val(f);
}

function PrepareFormulaData() {
    PostFormulaData();
}

/* Helper functions */
function PostFormulaData() {
    window.setTimeout(function () { Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('FormulaDataReady', [formula.val()]); }, 10);
}
function ValidateFormula() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('VerifyFormula', [formula.val()]);
}
function AddFormulaPart(p) {
    var val = formula.val();
    var sel = formula.getSelection();
    if (sel.start > 0 && val[sel.start - 1] != ' ')
        p = ' ' + p;
    if (sel.end < val.length && val[sel.end + 1] != ' ')
        p += ' ';
    formula.replaceSelectedText(p, 'collapseToEnd');
    formula.focus();
}
function SurroundWithParenthesis() {
    formula.surroundSelectedText('(', ')', 'collapseToEnd');
    formula.focus();
}