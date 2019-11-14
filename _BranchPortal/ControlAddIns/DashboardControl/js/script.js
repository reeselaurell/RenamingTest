//Settings: 
//var _descFitMode = 'wrap';
var _descFitMode = 'fit';

var _host;
var _loadPanel;
var _suspendEvents = false;
var _tileContainer = undefined;
var _tileSet = {};
var _selectedTile = undefined;
var _tileScrollPromise = undefined;
var _selectedDateRange = undefined;
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
                me._list.append($('<div>').click(me, me._onMonthClick).data('month', cur.idx()).addClass('button').css('width', width + 'px').text(Globalize.formatDate(cur.date(), {raw: "MMM yy"})).append($('<div>').addClass('marker').html('&nbsp;')));
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

function AttemptDateRange(dateFrom, dateTo) {
    dateFrom.setMinutes(-dateFrom.getTimezoneOffset());
    dateTo.setMinutes(-dateTo.getTimezoneOffset());
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AttemptDateRange', [dateFrom, dateTo]);
}

function LazyLoadTileData(timeout) {
    if (typeof timeout !== 'number')
        timeout = 150;
    if (_tileScrollPromise) {
        window.clearTimeout(_tileScrollPromise);
        _tileScrollPromise = undefined;
    }
    _tileScrollPromise = window.setTimeout(function() {
        _tileScrollPromise = undefined;
        var leftIdx = Math.floor(_tileContainer.scrollLeft() / 168);
        var count = Math.ceil(_tileContainer.innerWidth() / 168);
        var items = _tileContainer.children();
        for (var i = leftIdx; i < leftIdx + count; i++) {
            var bar = $(items[i]);
            if (bar.hasClass('empty')) {
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('TileDataNeeded', [bar.data('type'), bar.data('code')]);
                bar.removeClass('empty');
            }
        }
    }, timeout);
}

function FitBarDescription(bar) {
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

function TileClicked(tile) {
    if (_selectedTile)
        _selectedTile.removeClass('sel');
    tile.addClass('sel');
    _selectedTile = tile;
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('TileClicked', [tile.data('type'), tile.data('code')]);
}

/* Exposed functions */
function AdviceDateRange(dateFrom, dateTo) {
    if (!(dateFrom instanceof Date))
        dateFrom = new Date(dateFrom);
    if (!(dateTo instanceof Date))
        dateTo = new Date(dateTo);
    var NewDateRange = { startValue: dateFrom, endValue: dateTo };
    if (IsDifferentDateRange(NewDateRange)) {
        _suspendEvents = true;
        $('#date-from-box').dxDateBox('instance').option('value', dateFrom);
        $('#date-to-box').dxDateBox('instance').option('value', dateTo);
        _monthSelector.ApplyRange(NewDateRange.startValue, NewDateRange.endValue);
        _suspendEvents = false;
        _selectedDateRange = NewDateRange;
    }
}

function LoadTiles(data) {
    var first;
    for (var i = 0; i < data.length; i++) {
        var bar = $('#info-bar-template').clone();
        if (!first)
            first = bar;
        var id = data[i].type + '-' + data[i].code;
        bar.attr('id', id);
        if (data[i].color)
            bar.css('background', data[i].color);
        else
            bar.addClass('color' + data[i].type);
        bar.data('type', data[i].type);
        bar.data('code', data[i].code);
        var desc = bar.find('.desc');
        desc.text(data[i].description);
        bar.click(function () {
            TileClicked($(this));
        });
        _tileContainer.append(bar);
        _tileSet[id] = bar;
        FitBarDescription(bar);
    }
    if (first)
        TileClicked(first);
}

function ResetTiles(loadingTxt) {
    for (const id in _tileSet) {
        if (_tileSet.hasOwnProperty(id)) {
            const bar = _tileSet[id];
            bar.find('.amt1').html('&nbsp;');
            bar.find('.amt2').text(loadingTxt);
            bar.find('.amt3').html('&nbsp;');
            bar.addClass('empty');
        }
    }
    LazyLoadTileData(1);
}

function LoadButtons(data) {
    var container = $('#dynamic-btn-container');
    for (var i = 0; i < data.length; i++) {
        var btn = data[i];
        if (!btn.dropdown) {
            btn.onClick = function (e) {
                var obj = e.element.data('btn');
                //AttemptLoadingPanel();
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ButtonClicked', [obj.bd_group, obj.bd_id, obj.bd_metadata]);
            }
        }
        var elem = $('<div>').appendTo(container).data('btn', btn).dxButton(btn);
        if (btn.dropdown) {
            $('<div>').appendTo(_host).dxContextMenu({
                dataSource: btn.dropdown,
                target: elem,
                position: { my: 'left top', at: 'left bottom' },
                showEvent: 'dxclick',
                onItemClick: function (e) {
                    //AttemptLoadingPanel();
                    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ButtonClicked', [e.itemData.bd_group, e.itemData.bd_id, e.itemData.bd_metadata]);
                }
            })
        }
    }
}

function SetTileData(type, code, value1, value2, value3) {
    var tile = _tileSet[type + '-' + code];
    tile.find('.amt1').html(value1);
    tile.find('.amt2').html(value2);
    tile.find('.amt3').html(value3);
}

function SetMainParameters(name1, value1, name2, value2, name3, value3, name4, value4, name5, value5) {
    var box = $('#param-1-box');
    box.children('.name').text(name1);
    box.children('.value').html(value1);
    box = $('#param-2-box');
    box.children('.name').text(name2);
    box.children('.value').html(value2);
    box = $('#param-3-box');
    box.children('.name').text(name3);
    box.children('.value').html(value3);
    box = $('#param-4-box');
    box.children('.name').text(name4);
    box.children('.value').html(value4);
    if (!name4)
        box.hide();
    else
        box.show();
    box = $('#param-5-box');
    box.children('.name').text(name5);
    box.children('.value').html(value5);
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
var _chartDisplayValLookup = {};
function LoadChart(id, data) {
    $('#chart-container').css('display', 'block');
    var chart = $('#' + id + '-chart');
    var isPie = data.commonSeriesSettings.type == 'pie' || data.commonSeriesSettings.type == 'doughnut';
    if (data.argumentDisplayField) {
        _chartDisplayValLookup[id] = {};
        for (var i = 0; i < data.dataSource.length; i++){
            _chartDisplayValLookup[id][data.dataSource[i][data.commonSeriesSettings.argumentField]] = data.dataSource[i][data.argumentDisplayField];
        }
        if (!data.argumentAxis)
            data.argumentAxis = {};
        if (!data.argumentAxis.label)
            data.argumentAxis.label = {};
        data.argumentAxis.label.customizeText = function() {
            var value = _chartDisplayValLookup[id][this.value];
            return value ? value : this.value;
        }
    }
    if (!isPie)
        chart.dxChart(data);
    else
        chart.dxPieChart(data);
}
/*

function LoadChart(id, data) {
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
*/
