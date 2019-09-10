_host = $('#controlAddIn');
_host.html(Dashboard);
_loadPanel = $('<div>').dxLoadPanel();
_host.append(_loadPanel);
_loadPanel = _loadPanel.dxLoadPanel('instance');
_infoBarList = $('#info-bar-list');
_infoBarList.scroll(FitBarDescription);
if (_descFitMode == 'wrap') {
    _infoBarList.addClass('wrap');
}
$('#prev-month-btn').dxButton({
    icon: 'arrowleft',
    text: 'Previous month',
    onClick: function (e) {
        var end = _monthSelector.endDate;
        var start = new Date(end.getFullYear(), end.getMonth() - 1, 1);
        end = new Date(start.getFullYear(), start.getMonth() + 1, 0);
        SetDateRange(start, end);
    }
});
$('#next-month-btn').dxButton({
    icon: 'arrowright',
    text: 'Next month',
    onClick: function (e) {
        var end = _monthSelector.endDate;
        var start = new Date(end.getFullYear(), end.getMonth() + 1, 1);
        end = new Date(start.getFullYear(), start.getMonth() + 1, 0);
        SetDateRange(start, end);
    }
});
var d = new Date();
$('#date-from-box').dxDateBox({
    min: _minDate,
    onValueChanged: function (e) {
        if (!_suspendEvents)
            SetDateRange(e.value, $('#date-to-box').dxDateBox('instance').option('value'));
    }
});
$('#date-to-box').dxDateBox({
    min: _minDate,
    onValueChanged: function (e) {
        if (!_suspendEvents)
            SetDateRange($('#date-from-box').dxDateBox('instance').option('value'), e.value);
    }
});
_monthSelector.Init('#date-part-selector', {
    onSelectedRangeChanged: function (e) {
        if (!_suspendEvents)
            SetDateRange(e.startValue, e.endValue);
    }
});
$('#ytd-btn').dxButton({
    text: 'YTD',
    onClick: function () {
        SetDateRange(new Date(d.getFullYear(), 0, 1), d);
    }
});
$('#year-btn').dxButton({
    text: 'Year',
    onClick: function () {
        SetDateRange(new Date(d.getFullYear() - 1, d.getMonth(), 1), new Date(d.getFullYear(), d.getMonth(), 1));
    }
});
$('#branch-filter-box').dxTextBox({
    placeholder: 'Filter branches',
    showClearButton: true,
    onValueChanged: function (e) {
        var v = e.value.toLowerCase();
        if (!v) {
            _infoBarList.find('.info-bar').show();
        }
        else {
            _infoBarList.find('.info-bar').each(function () {
                var me = $(this);
                if (me.data('id').toLowerCase().indexOf(v) >=0 || me.find('.desc').text().toLowerCase().indexOf(v) >= 0)
                    me.show();
                else
                    me.hide();
            });
        }
    },
    valueChangeEvent: 'keyup'
});
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddInReady');
SetDateRange(new Date(d.getFullYear(), d.getMonth(), 1), d);
