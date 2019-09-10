/// <reference path="jquery-2.1.3.min.js" />
/// <reference path="globalize.min.js" />
/// <reference path="dx.all.js" />

//Settings: 
//var _descFitMode = 'wrap';
var _descFitMode = 'fit';
var _minDate = undefined;//new Date(2017, 1, 1);

var _host;
var _loadPanel;
var _suspendEvents = false;
var _infoBarList = undefined;
var _selectedDateRange = undefined;
var _selectedBar = undefined;
var _savedBarSelection = undefined;
var _barCount = 0;
var _monthSelector = {
    Init: function (selector, options) {
        var me = this;
        $.extend(me, options);
        me.$ = $(selector);
        me._list = me.$.find('.list');
        me._range = me.$.find('.range');
        me._switch = me.$.find('.switch');
        me._yearMode = false;
        me._width = me._list.innerWidth();
        $(window).resize(me, me._onResize);
        me._switch.click(me, me._onSwitchClick);
    },
    ApplyRange: function (startDate, endDate, tryFit) {
        var me = this;
        if (me.startDate != startDate || me.endDate != endDate) {
            me.startDate = startDate;
            me.endDate = endDate;
            if (!tryFit || !me._tryFitRange()) {
                me._switchMode(false);
                me._resetRange();
                me._extendRange();
            }
            me._drawTiles();
            if (typeof me.onSelectedRangeChanged === 'function')
                me.onSelectedRangeChanged({ startValue: startDate, endValue: endDate });
        }
    },
    _tryFitRange: function () {
        var me = this;
        if (me._yearMode || !me._start || !me._end)
            return false;
        start = { y: me.startDate.getFullYear(), m: me.startDate.getMonth(), idx: function () { return this.y * 12 + this.m }, inc: function () { this.m++; if (this.m >= 12) { this.m = 0; this.y++; } }, dec: function () { this.m--; if (this.m < 0) { this.m = 11; this.y--; } }, date: function () { return new Date(this.y, this.m) } };
        end = $.extend({}, me._start, { y: me.endDate.getFullYear(), m: me.endDate.getMonth() });
        if (end.idx() - start.idx() > me._end.idx() - me._start.idx() - 2)
            return false;
        while (me._end.idx() < end.idx()) {
            me._end.inc();
            me._start.inc();
        }
        while (me._start.idx() > start.idx() - 1) {
            me._end.dec();
            me._start.dec();
        }
        return true;
    },
    _resetRange: function () {
        var me = this;
        if (me._yearMode) {
            me._start = { y: me.startDate.getFullYear(), idx: function () { return this.y; }, inc: function () { this.y++; }, dec: function () { this.y--; }, date: function () { return new Date(this.y, 0, 1) } };
            me._end = $.extend({}, me._start, { y: me.endDate.getFullYear()})
        }
        else {
            me._start = { y: me.startDate.getFullYear(), m: me.startDate.getMonth(), idx: function () { return this.y * 12 + this.m }, inc: function () { this.m++; if (this.m >= 12) { this.m = 0; this.y++; } }, dec: function () { this.m--; if (this.m < 0) { this.m = 11; this.y--; } }, date: function () { return new Date(this.y, this.m) } };
            me._end = $.extend({}, me._start, { y: me.endDate.getFullYear(), m: me.endDate.getMonth() });
        }
    },
    _extendRange: function(){
        var me = this;
        //count original tiles
        var count = me._end.idx() - me._start.idx() + 1;
        //count how many we may have
        var possible = Math.floor(me._width / 64);
        if (count > possible) {
            //fall back to year select
            if (!me._yearMode)
                me._switchMode(true);
            me._resetRange();
            count = me._end.idx() - me._start.idx() + 1;
            possible = Math.floor(me._width / 128);
        }
        for (var i = 0; i < possible - count; i++) {
            if (i == 1 || i == 3 || i == 5)
                me._end.inc();
            else
                me._start.dec();
        }
    },
    _daysInMonth: function (date) {
        return new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
    },
    _dayOfYear: function (date){
        var start = new Date(date.getFullYear(), 0, 0);
        var diff = date - start;
        return Math.floor(diff / 86400000);
    },
    _daysInYear: function (date) {
        var year = date.getFullYear();
        if (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)) {
            return 366;
        } else {
            return 365;
        }
    },
    _drawTiles: function () {
        var me = this;
        var count = me._end.idx() - me._start.idx() + 1;
        var width = Math.floor(me._width / count);
        me._list.empty();
        var cur = $.extend({}, me._start);
        if (!me._yearMode) {
            while (count-- > 0) {
                me._list.append($('<div>').click(me, me._onMonthClick).data('month', cur.idx()).addClass('button').css('width', width + 'px').text(Globalize.format(cur.date(), "MMM\\' yy")).append($('<div>').addClass('marker').html('&nbsp;')));
                cur.inc();
            }
            var idx = me.startDate.getFullYear() * 12 + me.startDate.getMonth();
            me._range.css('left', Math.floor((idx - me._start.idx() + (me.startDate.getDate() - 1) / (me._daysInMonth(me.startDate) - 1)) * width) + 'px');
            var left = me._width % count;
            idx = me.endDate.getFullYear() * 12 + me.endDate.getMonth();
            me._range.css('right', Math.ceil(me._width - left - (idx - me._start.idx() + (me.endDate.getDate() - 1) / (me._daysInMonth(me.endDate) - 1)) * width) + 'px');
        }
        else {
            while (count-- > 0) {
                me._list.append($('<div>').click(me, me._onYearClick).data('year', cur.idx()).addClass('button').css('width', width + 'px').text(cur.idx()).append($('<div>').addClass('marker').html('&nbsp;')));
                cur.inc();
            }
            var idx = me.startDate.getFullYear();
            me._range.css('left', Math.floor((idx - me._start.idx() + (me._dayOfYear(me.startDate) - 1) / (me._daysInYear(me.startDate) - 1)) * width) + 'px');
            var left = me._width % count;
            idx = me.endDate.getFullYear();
            me._range.css('right', Math.ceil(me._width - left - (idx - me._start.idx() + (me._dayOfYear(me.endDate) - 1) / (me._daysInYear(me.endDate) - 1)) * width) + 'px');
        }
    },
    _onMonthClick: function(e) {
        var me = e.data;
        var btn = $(this);
        var idx = new Number(btn.data('month'));
        var start = new Date(Math.floor(idx / 12), idx % 12);
        me.ApplyRange(start, new Date(start.getFullYear(), start.getMonth() + 1, 0), true);
    },
    _onYearClick: function(e){
        var me = e.data;
        var btn = $(this);
        var idx = new Number(btn.data('year'));
        var start = new Date(idx, 0, 1);
        me.ApplyRange(start, new Date(idx + 1, 0, 1));
    },
    _onResize: function (e) {
        var me = e.data;
        var w = me._list.innerWidth();
        if (w != me._width) {
            me._width = w;
            me._resetRange();
            me._extendRange();
            me._drawTiles();
        }
    },
    _onSwitchClick: function (e) {
        var me = e.data;
        me._switchMode(!me._yearMode);
        me._resetRange();
        me._extendRange();
        me._drawTiles();
    },
    _switchMode: function (yearMode) {
        var me = this;
        me._yearMode = yearMode;
        if (me._yearMode) {
            me._switch.removeClass('dx-icon-chevronup');
            me._switch.addClass('dx-icon-chevrondown');
        }
        else {
            me._switch.removeClass('dx-icon-chevrondown');
            me._switch.addClass('dx-icon-chevronup');
        }
    }
};

function IsDifferentDateRange(range) {
    if (!_selectedDateRange)
        return true;
    return _selectedDateRange.startValue.getTime() != range.startValue.getTime() || _selectedDateRange.endValue.getTime() != range.endValue.getTime();
}
function SetDateRange(dateFrom, dateTo) {
    if (!(dateFrom instanceof Date))
        dateFrom = new Date(dateFrom);
    if (!(dateTo instanceof Date))
        dateTo = new Date(dateTo);
    if (_minDate) {
        if (dateFrom < _minDate || dateTo < _minDate) {
            alert('Date was adjusted to not go beyond minimum possible value');
            if (dateFrom < _minDate)
                dateFrom = _minDate;
            if (dateTo < _minDate)
                dateTo = _minDate;
        }
    }
    var NewDateRange = { startValue: dateFrom, endValue: dateTo };
    if (IsDifferentDateRange(NewDateRange)) {
        _suspendEvents = true;
        $('#date-from-box').dxDateBox('instance').option('value', dateFrom);
        $('#date-to-box').dxDateBox('instance').option('value', dateTo);
        _monthSelector.ApplyRange(NewDateRange.startValue, NewDateRange.endValue);
        _suspendEvents = false;
        dateFrom = Globalize.format(dateFrom, 'd');
        dateTo = Globalize.format(dateTo, 'd');
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('DateRangeChanged', [dateFrom, dateTo]);
        _selectedDateRange = NewDateRange;
    }
}

function SelectBar(bar) {
    if (_selectedBar) {
        _selectedBar.removeClass('sel');
    }
    bar.addClass('sel');
    _selectedBar = bar;
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('BarClicked', [bar.data('type'), bar.data('id')]);
}

var _addBarDeferPromise = undefined;
var _addBarQueue = [];
var _infoBars = undefined;
var _infoBarListScrollPromise = undefined;

function MakeWrapped(txt) {
    var center = Math.floor(txt.length / 2);
    var br = center;
    for (var i = 0; i <= center; i++) {
        if (txt[center - i] == ' ') {
            br = center - i;
            break;
        }
        if (txt[center + i] == ' ') {
            br = center + i;
            break;
        }
    }
    return txt.substring(0, br) + '<br />' + txt.substring(br, txt.length);
}

function FitBarDescription() {
    if (_infoBarListScrollPromise) {
        window.clearTimeout(_infoBarListScrollPromise);
        _infoBarListScrollPromise = undefined;
    }
    _infoBarListScrollPromise = window.setTimeout(function () {
        _infoBarListScrollPromise = undefined;
        var leftIdx = Math.floor(_infoBarList.scrollLeft() / 168);
        var count = Math.ceil(_infoBarList.innerWidth() / 168);
        for (var i = leftIdx; i < leftIdx + count; i++) {
            var bar = $(_infoBars[i]);
            if (!bar.hasClass('fit')) {
                bar.addClass('fit');
                var desc = bar.find('.desc');
                switch (_descFitMode)
                {
                    case 'fit':
                        var scroll = desc[0].scrollWidth;
                        var client = desc[0].clientWidth - 2;
                        if (scroll > client)
                            desc.css('font-size', Math.floor(15 * client / scroll) + 'px');
                        break;
                    case 'wrap':
                        var scroll = desc[0].scrollWidth;
                        var client = desc[0].clientWidth - 2;
                        if (scroll > client) {
                            desc.css('line-height', '17px');
                            desc.html(MakeWrapped(desc.text()));
                        }
                        break;
                }
            }
        }
    }, 150);
}

/* Exposed methods */
function AddBarContainer(id) {
    alert('not implemented');
    //$('<div>').addClass('container').attr('id', id);
}

function AddBarToContainer(containerId, colorIdx, type, id, description, amt1, amt2, amt3, colorAmt3, boldAmt3) {
    alert('not implemented');
}

function AddColorBarToContainer(containerId, htmlColor, type, id, description, amt1, amt2, amt3, colorAmt3, boldAmt3) {
    alert('not implemented');
}
/*
function AddColorBar(htmlColor, type, id, description, amt1, amt2, amt3, colorAmt3, boldAmt3) {
    AddBar(htmlColor, type, id, description, amt1, amt2, amt3, colorAmt3, boldAmt3);
}
*/
function AddBar(colorIdx, type, id, description, amt1, amt2, amt3, colorAmt3, boldAmt3) {
    if (_addBarDeferPromise) {
        window.clearTimeout(_addBarDeferPromise);
        _addBarDeferPromise = undefined;
    }
    var bar = $('#info-bar-template').clone();
    bar.attr('id', type + '-' + id);
    if (isNaN(colorIdx))
        bar.css('background', colorIdx);
    else
        bar.addClass('color' + colorIdx);
    bar.data('type', type);
    bar.data('id', id);
    var desc = bar.find('.desc');
    desc.text(description);
    bar.find('.amt1').text(amt1);
    bar.find('.amt2').text(amt2);
    var a3 = bar.find('.amt3').text(amt3);
    if (colorAmt3)
        a3.css('color', colorAmt3);
    if (boldAmt3)
        a3.css('font-weight', 'bold');
    bar.click(function () {
        SelectBar($(this));
    });
    if (_savedBarSelection) {
        if (_savedBarSelection === id) {
            _savedBarSelection = undefined;
            SelectBar(bar);
        }
    }
    else if (_barCount == 0)
        SelectBar(bar);
    _barCount++;
    _addBarQueue.push(bar);
    _addBarDeferPromise = window.setTimeout(function () {
        _addBarDeferPromise = undefined;
        _infoBarList.append(_addBarQueue);
        _addBarQueue = [];
        _infoBars = _infoBarList.children();
        FitBarDescription();
    }, 100);
}

function ClearBars() {
    if (_barCount > 0) {
        _savedBarSelection = _selectedBar ? _selectedBar.data('id') : undefined;
        _infoBarList.empty();
        _barCount = 0;
    }
}

function SetMainParameters(name1, value1, name2, value2, name3, value3, name4, value4, name5, value5) {
    var box = $('#param-1-box');
    box.children('.name').text(name1);
    box.children('.value').text(value1);
    box = $('#param-2-box');
    box.children('.name').text(name2);
    box.children('.value').text(value2);
    box = $('#param-3-box');
    box.children('.name').text(name3);
    box.children('.value').text(value3);
    box = $('#param-4-box');
    box.children('.name').text(name4);
    box.children('.value').text(value4);
    if (!name4)
        box.hide();
    else
        box.show();
    box = $('#param-5-box');
    box.children('.name').text(name5);
    box.children('.value').text(value5);
    if (!name5)
        box.hide();
    else
        box.show();
    var container = $('#parameter-container');
    if (!name4) {
        container.attr('class', 'container3');
    }
    else if (!name5)
        container.attr('class', 'container4');
    else
        container.attr('class', 'container5');
}

function LoadChart(id, json) {
    var data = JSON.parse(json);
    $('#chart-container').css('display', 'block');
    var isPie = data.commonSeriesSettings.type == 'pie' || data.commonSeriesSettings.type == 'doughnut';
    var clicky = function (e) {
        if (data.tooltip && data.tooltip.showOnClick) {
            e.showTooltip();
        }
        if (data.clientClickTemplate) {
            eval(data.clientClickTemplate);
        }
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ChartClicked', [data._id, e.series.name, e.originalArgument, e.originalValue]);
    };
    if (!isPie)
        data.pointClick = clicky;
    else
        data.onPointClick = clicky;
    var chart = $('#' + id + '-chart');
    if (data.tooltip && data.tooltip.customizeTextTemplate) {
        data.tooltip.customizeText = function (e) {
            return eval(data.tooltip.customizeTextTemplate);
        }
    }
    if (data.argumentAxis && data.argumentAxis.label && data.argumentAxis.label.customizeTextTemplate) {
        data.argumentAxis.label.customizeText = function (e) {
            return eval(data.argumentAxis.label.customizeTextTemplate);
        }
    }
    if (data.valueAxis && data.valueAxis.label && data.valueAxis.label.customizeTextTemplate) {
        data.valueAxis.label.customizeText = function (e) {
            return eval(data.valueAxis.label.customizeTextTemplate);
        }
    }
    if (data.commonSeriesSettings.label && data.commonSeriesSettings.label.customizeTextTemplate) {
        data.commonSeriesSettings.label.customizeText = function (e) {
            return eval(data.commonSeriesSettings.label.customizeTextTemplate);
        }
    }
    if (!isPie)
        chart.dxChart(data);
    else
        chart.dxPieChart(data);
}

function AttemptLoadingPanel() {
    var container = $('.spa-container', window.parent.document);
    if (container.length > 0) {
        _loadPanel.show();
        var int = window.setInterval(function () {
            if (container.children('.spa-view').length > 1) {
                window.clearInterval(int);
                _loadPanel.hide();
            }
        }, 100);
    }
}

function LoadButtons(data) {
    var container = $('#dynamic-btn-container');
    for (var i = 0; i < data.length; i++) {
        var btn = data[i];
        if (!btn.dropdown) {
            btn.onClick = function (e) {
                AttemptLoadingPanel();
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ActionInvoked', [e.element.attr('data-tag'), _selectedBar.data('type'), _selectedBar.data('id')]);
            }
        }
        var elem = $('<div>').appendTo(container).dxButton(btn).attr('data-tag', btn.tag);
        if (btn.dropdown) {
            $('<div>').appendTo(_host).dxContextMenu({
                dataSource: btn.dropdown,
                target: elem,
                position: { my: 'left top', at: 'left bottom' },
                showEvent: 'dxclick',
                onItemClick: function (e) {
                    AttemptLoadingPanel();
                    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ActionInvoked', [e.itemData.id, _selectedBar.data('type'), _selectedBar.data('id')]);
                }
            })
        }
    }
}
