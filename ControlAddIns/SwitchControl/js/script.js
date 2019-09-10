var control = undefined;
var condition_template = undefined;
var condition_host = undefined;
var condition_count = 0;
var is_loading_data = false;
var field_list = [];

function AppendCondition() {
    var clone = condition_template.clone(true).off();
    clone.attr('id', 'condition_' + condition_count++);
    clone.data('case', '');
    clone.data('returns', '');
    condition_host.append(clone);
    clone.find('button').click(function () {
        $(this).closest('.condition-control').remove();
        condition_count--;
    });
    InitControls(clone);
    clone.find('.case').change(function () {
        if (!is_loading_data) {
            var me = $(this);
            var ctl = me.closest('.condition-control');
            var data = me.data('item');
            var cancel = true;
            var newVal = '';
            if (typeof data === 'string') {
                if (data == '') {
                    newVal = '""';
                }
                else if (!isNaN(data) || IsWrappedTo(data, '(', ')') || IsWrappedTo(data, '"', '"')) {
                    newVal = data;
                }
                else {
                    newVal = '"' + data + '"';
                }
                cancel = false;
            }
            else {
                switch (data.type) {
                    case 'r':
                        var rng = ctl.data('case').split('..');
                        rng[0] = TrimChar(rng[0], '(', ')');
                        if (rng.length > 1)
                            rng[1] = TrimChar(rng[1], '(', ')');
                        else
                            rng.push('');
                        var rStart = prompt('Please, specify range start:', rng[0]);
                        if (rStart != null) {
                            var rEnd = prompt('Please, specify range end:', rng[1]);
                            if (rEnd != null) {
                                cancel = false;
                                newVal = '(' + rStart + '..' + rEnd + ')';
                            }
                        }
                        break;
                    case 's':
                        newVal = prompt('Please, specify a constant value:', TrimChar(ctl.data('case'), '"'));
                        if (newVal != null) {
                            cancel = false;
                            if (newVal == '' || isNaN(newVal))
                                newVal = '"' + newVal + '"';
                        }
                        break;
                    case 'c':
                        newVal = prompt('Please, specify pipe (\'|\') separated values:', TrimChar(ctl.data('case'), '(', ')'));
                        if (newVal != null) {
                            cancel = false;
                            newVal = '(' + newVal + ')';
                        }
                        break;
                }
            }
            if (cancel) {
                me.find('input').val(ctl.data('case'));
            }
            else {
                me.find('input').val(newVal);
                ctl.data('case', newVal);
            }
        }
    });
    clone.find('.case input').blur(function () {
        var me = $(this);
        var ctl = me.closest('.condition-control');
        me.val(ctl.data('case'));
    });
    clone.find('.returns').change(function () {
        if (!is_loading_data) {
            var me = $(this);
            var ctl = me.closest('.condition-control');
            var data = me.data('item');
            var cancel = true;
            var newVal = '';
            if (typeof data === 'string') {
                if (data == '') {
                    newVal = '""';
                }
                else if (!isNaN(data) || data.indexOf('[') != -1 || IsWrappedTo(data, '"', '"')) {
                    newVal = data;
                }
                else {
                    newVal = '"' + data + '"';
                }
                cancel = false;
            }
            else {
                switch (data.type) {
                    case 'v':
                        cancel = false;
                        newVal = '[' + data.n + ']';
                        break;
                    case 's':
                        newVal = prompt('Please, specify a constant value:', TrimChar(ctl.data('returns'), '"'));
                        if (newVal != null) {
                            cancel = false;
                            if (newVal == '' || isNaN(newVal))
                                newVal = '"' + newVal + '"';
                        }
                        break;
                    case 'f':
                        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('EditFormula', [ctl.attr('id'), ctl.data('returns')]);
                        break;
                }
            }
            if (cancel) {
                me.find('input').val(ctl.data('returns'));
            }
            else {
                me.find('input').val(newVal);
                ctl.data('returns', newVal);
            }
        }
    });
    clone.find('.returns input').blur(function () {
        var me = $(this);
        var ctl = me.closest('.condition-control');
        me.val(ctl.data('returns'));
    });
    clone.find('input').change(function (e) {
        e.stopPropagation();
    });
    return clone;
}
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
            if (ctl.hasClass('dd')) {
                ctl.removeClass('dd');
            }
            else {
                $('div.combobox').removeClass('dd');
                ctl.addClass('dd');
                if (item)
                    item[0].scrollIntoView(false);
            }
        });
        ctl.find('li').mousedown(function () {
            var me = $(this);
            if (!me.hasClass('disabled')) {
                if (sel)
                    sel.removeClass('selected');
                sel = me;
                sel.addClass('selected');
            }
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
                    }
                    ctl.find('li:not(.fixed)').each(function () {
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
                    reRunTimer();
                }
            }).keydown(function (e) {
                if (e.which == 27) {
                    //escape
                    e.preventDefault();
                    ctl.removeClass('dd');
                }
                else if (e.which == 13) {
                    //enter
                    e.preventDefault();
                    if (!ctl.hasClass('dd'))
                        sel = null;
                    ctl.removeClass('dd');
                    ctl.find('li').css('display', '');
                    if (sel) {
                        text.val(sel.text());
                        item = sel;
                        ctl.data('item', item.data('object'));
                    }
                    else {
                        ctl.data('item', text.val());
                    }
                    ctl.trigger('change');
                }
                else if (e.which == 40 || e.which == 38) {
                    if (!ctl.hasClass('dd'))
                        ctl.addClass('dd');
                    var next = e.which == 40 ? (sel ? sel.nextAll(':visible:not(.disabled)').first() : ctl.find('ul > li:visible:not(.disabled)').first()) : (sel ? sel.prevAll(':visible:not(.disabled)').first() : ctl.find('ul > li:visible:not(.disabled)').last());
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

/* Exposed methods */
function LoadFields(data) {
    try {
        //field_list.push({ n: name, type: 'v' });
        field_list = data;
        field_list.sort(function (a, b) { return a.n < b.n ? -1 : a.n > b.n ? 1 : 0; });
        var ul = condition_template.find('.returns ul');
        ul.find('li:first-child').data('object', { type: 's' })
        ul.find('li:nth-child(2)').data('object', { type: 'f' });
        for (var i = 0; i < field_list.length; i++) {
            var li = $('<li></li>');
            li.data('object', field_list[i]);
            li.text(field_list[i].n);
            ul.append(li);
        }
        ul = condition_template.find('.case ul');
        ul.find('li:first-child').data('object', { type: 's' });
        ul.find('li:nth-child(2)').data('object', { type: 'r' });
        ul.find('li:nth-child(3)').data('object', { type: 'c' });
    }
    catch (e) {
        alert(e);
    }
}
function AppendLine(predicate, returns) {
    try {
        is_loading_data = true;
        var cc = AppendCondition();
        if (predicate) {
            var pType = GetRecordType(predicate);
            SetComboboxValue(cc.find('.case'), function (obj) {
                return obj.type == pType;
            }, predicate);
        }
        cc.data('case', predicate);
        if (returns) {
            var rType = GetRecordType(returns);
            var val = rType != 'v' ? '' : returns.slice(1, returns.length - 1);
            SetComboboxValue(cc.find('.returns'), function (obj) {
                if (obj.type == 'v')
                    return obj.n == val;
                else
                    return obj.type == rType;
            }, returns);
        }
        cc.data('returns', returns);
    }
    catch (e) {
        alert(e);
    }
    finally {
        is_loading_data = false;
    }
}
function DumpLines() {
    var cd = [];
    var doPost = true;
    condition_host.find('div.condition-control').each(function () {
        try
        {
            var ctl = $(this);
            var c = { predicate: ctl.data('case'), returns: ctl.data('returns') };
            if (!c.returns)
                return doPost = ThrowConditionDataError(cd, 'You must specify a return value');
            if (!c.predicate)
                return doPost = ThrowConditionDataError(cd, 'You must specify case predicate');
            cd.push(c);
        }
        catch(e)
        {
            alert(e);
        }
    });

    if (doPost)
        PostConditionData(cd);
    return doPost;
}

function ApplyFormula(id, cancel, formula) {
    var ctl = $('#' + id);
    if (cancel)
        ctl.find('.returns input').val(ctl.data('returns'));
    else {
        ctl.find('.returns input').val(formula);
        ctl.data('returns', formula);
    }
}

function ApplyConstant(id, constant) {
    $('#' + id).data('constant', constant);
}

/* Helper functions */

function ThrowConditionDataError(cd, e) {
    var err = 'Switch case #' + (cd.length + 1) + ': ' + e;
    window.setTimeout(function () { Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('SwitchDataError', [err]); }, 10);
    return false;
}
function PostConditionData(cd) {
    window.setTimeout(function () {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ReportLines', [cd]);
    }, 10);
}

function SetComboboxValue(cb, comparer, text) {
    var isComparer = typeof comparer === 'function';
    cb.find('li').each(function () {
        var li = $(this);
        var obj = li.data('object');
        var found = false;
        if (obj == undefined || obj == null || obj === '')
            found = isComparer ? comparer(li.text()) : li.text() === comparer;
        else {
            found = isComparer ? comparer(obj) : obj === comparer;
        }
        if (found) {
            li.trigger('mousedown');
            li.trigger('mouseup');
            return false;
        }
    });
    if (text)
        cb.find('input').val(text);
}
function TrimChar(s, cStart, cEnd) {
    if (!s)
        return s;
    if (s[0] == cStart)
        s = s.slice(1);
    if (typeof cEnd === 'undefined')
        cEnd = cStart;
    if (s[s.length - 1] == cEnd)
        s = s.slice(0, s.length - 1);
    return s;
}
function GetRecordType(rec) {
    if (!isNaN(rec) || IsWrappedTo(rec, '"'))
        return 's';
    if (IsWrappedTo(rec, '(', ')')) {
        return rec.indexOf('..') != -1 ? 'r' : 'c';
    }
    if (IsWrappedTo(rec, '[', ']') && rec.indexOf('[', 1) == -1)
        return 'v';
    return 'f';
}
function IsWrappedTo(s, wStart, wEnd) {
    if (!s)
        return false;
    if (typeof wEnd === 'undefined')
        wEnd = wStart;
    return s[0] == wStart && s[s.length - 1] == wEnd;
}