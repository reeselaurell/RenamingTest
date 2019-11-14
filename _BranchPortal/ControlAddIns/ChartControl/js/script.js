var _host;
var _displayValLookup = {};

/* Exposed functions */
function LoadChart(data) {
    var isPie = data.commonSeriesSettings.type == 'pie' || data.commonSeriesSettings.type == 'doughnut';
    if (data.argumentDisplayField) {
        _displayValLookup = {};
        for (var i = 0; i < data.dataSource.length; i++){
            _displayValLookup[data.dataSource[i][data.commonSeriesSettings.argumentField]] = data.dataSource[i][data.argumentDisplayField];
        }
        if (!data.argumentAxis)
            data.argumentAxis = {};
        if (!data.argumentAxis.label)
            data.argumentAxis.label = {};
        data.argumentAxis.label.customizeText = function() {
            var value = _displayValLookup[this.value];
            return value ? value : this.value;
        }
    }
    if (!isPie)
        _host.dxChart(data);
    else
        _host.dxPieChart(data);
}
/*
function LoadChart(id, data) {
    var isPie = data.commonSeriesSettings.type == 'pie' || data.commonSeriesSettings.type == 'doughnut';
    var clicky = function (e) {
        if (data.tooltip && data.tooltip.showOnClick) {
            e.showTooltip();
        }
        if (data.clientClickTemplate) {
            eval(data.clientClickTemplate);
        }
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ChartClicked', [e.series.name, e.originalArgument, e.originalValue]);
    };
    if (!isPie)
        data.pointClick = clicky;
    else
        data.onPointClick = clicky;
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
        _host.dxChart(data);
    else
        _host.dxPieChart(data);
}
*/
