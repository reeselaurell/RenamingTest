_host = $('#controlAddIn');
_host.html(Dashboard);
_loadPanel = $('<div>').dxLoadPanel();
_host.append(_loadPanel);
_loadPanel = _loadPanel.dxLoadPanel('instance');
_tileContainer = $('#info-bar-list');
_tileContainer.scroll(LazyLoadTileData);
if (_descFitMode == 'wrap') {
    _tileContainer.addClass('wrap');
}
$('#prev-month-btn').dxButton({
    icon: 'arrowleft',
    text: 'Previous month',
    onClick: function (e) {
        var end = _monthSelector.endDate;
        var start = new Date(end.getFullYear(), end.getMonth() - 1, 1);
        end = new Date(start.getFullYear(), start.getMonth() + 1, 0);
        AttemptDateRange(start, end);
    }
});
$('#next-month-btn').dxButton({
    icon: 'arrowright',
    text: 'Next month',
    onClick: function (e) {
        var end = _monthSelector.endDate;
        var start = new Date(end.getFullYear(), end.getMonth() + 1, 1);
        end = new Date(start.getFullYear(), start.getMonth() + 1, 0);
        AttemptDateRange(start, end);
    }
});
$('#date-from-box').dxDateBox({
    onValueChanged: function (e) {
        if (!_suspendEvents)
            AttemptDateRange(e.value, $('#date-to-box').dxDateBox('instance').option('value'));
    }
});
$('#date-to-box').dxDateBox({
    onValueChanged: function (e) {
        if (!_suspendEvents)
            AttemptDateRange($('#date-from-box').dxDateBox('instance').option('value'), e.value);
    }
});
_monthSelector.Init('#date-part-selector', {
    onSelectedRangeChanged: function (e) {
        if (!_suspendEvents)
            AttemptDateRange(e.startValue, e.endValue);
    }
});
$('#ytd-btn').dxButton({
    text: 'YTD',
    onClick: function () {
        var d = new Date();
        AttemptDateRange(new Date(d.getFullYear(), 0, 1), d);
    }
});
$('#year-btn').dxButton({
    text: 'Year',
    onClick: function () {
        var d = new Date();
        AttemptDateRange(new Date(d.getFullYear() - 1, d.getMonth(), 1), new Date(d.getFullYear(), d.getMonth(), 1));
    }
});
$('#branch-filter-box').dxTextBox({
    placeholder: 'Filter branches',
    showClearButton: true,
    onValueChanged: function (e) {
        var v = e.value.toLowerCase();
        if (!v) {
            _tileContainer.find('.info-bar').show();
        }
        else {
            _tileContainer.find('.info-bar').each(function () {
                var me = $(this);
                if (me.attr('id').toLowerCase().indexOf(v) >=0 || me.find('.desc').text().toLowerCase().indexOf(v) >= 0)
                    me.show();
                else
                    me.hide();
            });
        }
    },
    valueChangeEvent: 'keyup'
});
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddInReady');
