/* Global Variables */
var control;
var grid;
var buttons;
var GridColumnNames = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var currentGridData;

/* Internal functions */
function CreateInfrastructure() {
    control.empty();
    buttons = $('<div></div>');
    buttons.addClass('toolbar');
    control.append(buttons);
    grid = $('<div></div>');
    control.append(grid);
}
function GetCellType(colKind, rowKind) {
    if (colKind == -1 || rowKind == 'Header')
        return 'text';
    if (colKind == 3)
        return 'percentage';
    if (rowKind == 'Count')
        return 'integer';
    else if (rowKind == 'Summary') {
        switch (colKind) {
            case 0: return 'decimal';
            case 1: return 'integer';
            case 2: return 'percentage';
        }
    }
    if (colKind == 2) {
        return 'bps';
    }
    return 'decimal';
}
function RenderGridCell(source, options) {
    if (options.data.CssClass)
        source.parent().addClass(options.data.CssClass);
    if (options.data.IsSecondaryRow) {
        source.parent.addClass('dx-secondary-row');
    }
    source.attr('style', null);
    try {
        var value = options.value;
        var interactive = false;
        var colKind = options.column.colKind;
        var roundingOverride = -1;
        var negOverride = null;
        if (typeof value === 'object') {
            interactive = value.i;
            if (typeof value.r !== 'undefined')
                roundingOverride = value.r;
            if (value.t && value.t >= 0) {
                colKind = value.t;
            }
            negOverride = value.n;
            value = value.v;
        }
        var td = source;
        if (options.column.cssClass)
            td.addClass(options.column.cssClass);
        if (interactive)
            td.addClass('link');
        var colName = GenerateColumnName(options.columnIndex);
        var id = colName + options.data.rowId;
        td.attr('id', id);
        var cellType = GetCellType(colKind, options.data.Kind);
        if (cellType == 'text')
            td.html(value);
        else {
            var fmtOptions = { CellType: cellType, IfZero: options.data.IfZero, IfNegative: options.data.IfNegative };
            if (roundingOverride == 1)
                fmtOptions.Rounding = 'PointOne';
            else if (options.data.Rounding)
                fmtOptions.Rounding = options.data.Rounding;
            else if (cellType == 'integer')
                fmtOptions.Rounding = 'Round';
            if (negOverride)
                fmtOptions.IfNegative = negOverride;

            td.html(FormatCellValue(fmtOptions, value));
        }
    }
    catch (err) {
        alert(err);
    }
}
function RenderGridRow(source, options) {
    try {
        var tr = $('<tr></tr>');
        tr.addClass('dx-row dx-data-row')
        if (options.data.CssClass)
            tr.addClass(options.data.CssClass);
        if (options.data.IsSecondaryRow) {
            tr.addClass('dx-secondary-row');
        }
        for (var i = 0; i < options.values.length; i++) {
            var value = options.values[i];
            var interactive = false;
            var colKind = options.columns[i].colKind;
            if (typeof value === 'object') {
                interactive = value.i;
                value = value.v;
                if (value.t && value.t >= 0) {
                    colKind = value.t;
                }
            }
            var td = $('<td></td>');
            if (options.columns[i].cssClass)
                td.addClass(options.columns[i].cssClass);
            if (interactive)
                td.addClass('link');
            var colName = GenerateColumnName(i);
            var id = colName + options.data.rowId;
            td.attr('id', id);
            var cellType = GetCellType(colKind, options.data.Kind);
            if (cellType == 'text')
                td.html(value);
            else {
                var fmtOptions = { CellType: cellType, IfZero: options.data.IfZero, IfNegative: options.data.IfNegative };
                if (options.data.Rounding)
                    fmtOptions.Rounding = options.data.Rounding;
                else if (cellType == 'integer')
                    fmtOptions.Rounding = 'Round';

                td.html(FormatCellValue(fmtOptions, value));
            }
            tr.append(td);
        }
        source.append(tr);
    }
    catch (err) {
        alert(err);
    }
}
function GenerateColumnName(idx) {
    return idx < GridColumnNames.length ? GridColumnNames[idx] : GenerateColumnName(Math.floor(idx / GridColumnNames.length) - 1) + GridColumnNames[idx % GridColumnNames.length];
}

function DegenerateFieldName(name) {
    var idx = GridColumnNames.indexOf(name[name.length - 1]);
    for (i = name.length - 2; i >= 0; i--) {
        idx += (GridColumnNames.indexOf(name[i]) + 1) * Math.pow(GridColumnNames.length, name.length - i - 1);
    }
    return idx;
}

function ConvertToString(num, round) {
    var decimals = 2;
    switch (round) {
        case 'Round': decimals = 0; break;
        case 'PointOne': decimals = 1; break;
    }
    var n = num.toFixed(decimals);
    p = n.indexOf('.');
    return n.replace(/\d(?=(?:\d{3})+(?:\.|$))/g, function ($0, i) {
        return p < 0 || i < p ? ($0 + ',') : $0;
    });
}
function PrepareCellValue(options, value) {
    try {
        switch (options.Rounding) {
            case 'Round':
                return Math.round(value);
            case 'Thousands':
                return Math.round(value / 1000);
            case 'PointOne':
                return RoundToOne(typeof value === 'number' ? value : Number(value));
            default:
                return RoundToTwo(typeof value === 'number' ? value : Number(value));
        }
    }
    catch (err)
    {
        alert(err);
    }
}
function RoundToTwo(value) {
    if (isNaN(value) || !isFinite(value))
        return value;
    return +(Math.round(value + "e+2") + "e-2");
}
function RoundToOne(value) {
    if (isNaN(value) || !isFinite(value))
        return value;
    return +(Math.round(value + "e+1") + "e-1");
}
function StringifyCellValue(options, value) {
    try
    {
        var stringValue = '';
        if (value == 0 && options.IfZero) {
            switch (options.IfZero) {
                case 'Zero':
                    stringValue = '0';
                    break;
                case 'Blank':
                    stringValue = '&nbsp;';
                    break;
                case 'Dash':
                    stringValue = '-';
                    break;
            }
        }
        if (stringValue === '') {
            var neg = false;
            if (options.IfNegative && options.IfNegative != 'None' && value < 0) {
                neg = true;
                value = -value;
            }
            stringValue = ConvertToString(value, options.Rounding);
            if (neg) {
                switch (options.IfNegative) {
                    case 'Parenthesis':
                        switch (options.CellType) {
                            case 'decimal': stringValue = '$ (' + stringValue + ')'; break;
                            case 'percentage': stringValue = '(' + stringValue + ') %'; break;
                            default: stringValue = '(' + stringValue + ')'; break;
                        }
                    break;
                    case 'Red':
                        switch (options.CellType) {
                            case 'decimal': stringValue = '<span class="red">$ ' + stringValue + '</span>'; break;
                            case 'percentage': stringValue = '<span class="red">' + stringValue + '</span> %'; break;
                            default: stringValue = '<span class="red">' + stringValue + '</span>'; break;
                        }
                    break;
                    case 'RedParenthesis':
                        switch (options.CellType) {
                            case 'decimal': stringValue = '<span class="red">$ (' + stringValue + ')</span>'; break;
                            case 'percentage': stringValue = '<span class="red">(' + stringValue + ') %</span>'; break;
                            default: stringValue = '<span class="red">(' + stringValue + ')</span>'; break;
                        }
                    break;
                    default: stringValue = '-' + stringValue;
                }
            }
            else {
                switch (options.CellType) {
                    case 'decimal': stringValue = '$ ' + stringValue; break;
                    case 'percentage': stringValue += ' %'; break;
                }
            }
        }
        return stringValue;
    }
    catch (err) {
        alert(err);
    }
}
function FormatCellValue(options, value) {
    return StringifyCellValue(options, PrepareCellValue(options, value));
}
function FlattenDataObject(obj) {
    var result = {};
    for (var field in obj) {
        var value = obj[field];
        result[field] = typeof value === 'object' ? value.v : value;
    }
    return result;
}
function CalculateFormulae(data) {
    var cube = {};
    for (var i = 0; i < data.dataSource.length; i++) {
        cube['R' + data.dataSource[i].rowId] = FlattenDataObject(data.dataSource[i]);
    }
    for (var i = 0; i < data.dataSource.length; i++) {
        if (data.dataSource[i].Formula) {
            CalculateFormulaForColumns(data.dataSource[i], data.columns, cube);
        }
    }
}
function CalculateFormulaForColumns(dataRow, columns, cube) {
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].columns instanceof Array) {
            CalculateFormulaForColumns(dataRow, columns[i].columns, cube)
        }
        else {
            var colKind = columns[i].colKind;
            var value = dataRow[columns[i].dataField];
            if (typeof value === 'object') {
                if (value.t && value.t >= 0) {
                    colKind = value.t;
                }
            }
            if (colKind != -1) { //not text
                var formula = dataRow.Formula;
                switch (colKind) {
                    case 1:
                        if (dataRow.Formula2)
                            formula = dataRow.Formula2;
                        break;
                    case 2:
                        if (dataRow.Formula3)
                            formula = dataRow.Formula3;
                        else
                            formula = null;
                }
                if (formula) {
                    cube['R' + dataRow.rowId][columns[i].dataField] = dataRow[columns[i].dataField] = RoundToTwo(eval(formula.replace(/(R\d+)(O(-?\d+))?/g, function (all, g1, g2, g3) {
                        var result = 'cube.' + g1 + '.';
                        if (g3) {
                            result += 'Value' + columns[i].dataField.replace(/Value(\d+)/, function (all, g4) {
                                return (Number(g4) + Number(g3)).toString();
                            });
                        }
                        else
                            result += columns[i].dataField;
                        return result;
                    })));
                }
                else {
                    cube['R' + dataRow.rowId][columns[i].dataField] = dataRow[columns[i].dataField] = 0;
                }
            }
        }
    }
}

function SetCellTemplate(column) {
    if (column.columns) {
        for (var i = 0; i < column.columns.length; i++) {
            SetCellTemplate(column.columns[i]);
        }
    }
    else {
        column.cellTemplate = RenderGridCell;
    }
}

/* Exposed methods */
function InitializeDXGrid(json) {
    try {
        if (grid.isInitialized)
            grid.dxDataGrid('dispose');
        var data = JSON.parse(json);
        currentGridData = data;
        if (data.showToggleSecondaryDataButton) {
            var btn = $('<div></div>');
            buttons.append(btn);
            btn.dxButton({ text: 'Toggle branch data', onClick: toggleSecondaryData });
        }
        CalculateFormulae(data);
        //data.rowTemplate = RenderGridRow;

        data.onContentReady = function (e) {
            $('.dx-data-row td').click(function () {
                var me = $(this)
                if (me.hasClass('link')) {
                    var id = me.attr('id');
                    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CellClick', [DegenerateFieldName(/\D+/.exec(id)[0]), Number(/\d+/.exec(id)[0])]);
                }
            });
            if (data.fixRows) {
                var rows = this.element().find('.dx-datagrid-rowsview .dx-datagrid-content:not(.dx-datagrid-content-fixed) .dx-datagrid-table .dx-row:lt(' + data.fixRows + ')');
                var fixedRows = this.element().find('.dx-datagrid-rowsview .dx-datagrid-content.dx-datagrid-content-fixed .dx-datagrid-table .dx-row:lt(' + data.fixRows + ')');
                var head = this.element().find('.dx-datagrid-headers .dx-datagrid-content:not(.dx-datagrid-content-fixed) .dx-datagrid-table .dx-row:last');
                var fixedHead = this.element().find('.dx-datagrid-headers .dx-datagrid-content.dx-datagrid-content-fixed .dx-datagrid-table .dx-row:last');
                rows.detach();
                head.after(rows);
                fixedRows.detach();
                fixedHead.after(fixedRows);
            }
        }
        CreateInfrastructure();
        data.height = 670;
        data.scrolling = {
            useNative: true
        }
        for (var i = 0; i < data.columns.length; i++) {
            SetCellTemplate(data.columns[i]);
        }
        grid.dxDataGrid(data);
        grid.isInitialized = true;
    }
    catch (error) {
        alert(error);
    }
}

function SetupStyles(json) {
    try {
        var data = JSON.parse(json);
        jss.remove();
        for (s in data) {
            jss.set(s, data[s]);
        }
    }
    catch (error) {
        alert(error);
    }
}

function ExportToExcel() {
    grid.dxDataGrid('instance').exportToExcel(false);
}

function Print() {
    window.print();
}

var __SecondaryDataRowsVisible = false;
function toggleSecondaryData() {
    __SecondaryDataRowsVisible = !__SecondaryDataRowsVisible;
    $('tr.dx-secondary-row').css('display', __SecondaryDataRowsVisible ? 'table-row' : 'none');
}