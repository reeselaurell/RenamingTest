codeunit 14135124 "lvnPerformanceMgmt"
{
    SingleInstance = true;

    var
        BandExpressionConsumerId: Guid;
        PeriodRowExpressionConsumerId: Guid;
        DimensionRowExpressionConsumerId: Guid;
        CircularReferenceErr: Label 'Circular reference detected!';
        BandCountTxt: Label '$BANDCOUNT';
        ColCountTxt: Label '$COLCOUNT';
        FieldFormatTxt: Label 'b%1c%2', Comment = '%1 - Band Index; %2 - Column Index';
        FilterRangeTxt: Label '%1..%2', Comment = '%1 - Filter Range Start; %2 - Filter Range End';
        PixelSizeTxt: Label '%1px', Comment = '%1 - CSS Size in pixels';
        DateOffsetMonthTxt: Label '<%1M>', Comment = '%1 - Month Count to Add or Substract';
        DateOffsetQuarterTxt: Label '<%1Q>', Comment = '%1 - Quarter Count to Add or Substract';
        DateOffsetYearTxt: Label '<%1Y>', Comment = '%1 - Year Count to Add or Substract';
        UnsupportedExpressionTypeErr: Label 'Unsupported expression type %1', Comment = '%1 - Type of Expression';
        UnsupportedBandTypeErr: Label 'Band type is not supported: %1', Comment = '%1 - Type of Band';

    procedure GetFieldFormat(): Text
    begin
        exit(FieldFormatTxt);
    end;

    procedure GetBandExpressionConsumerId(): Guid
    begin
        if IsNullGuid(BandExpressionConsumerId) then
            Evaluate(BandExpressionConsumerId, '3def5809-ac44-44c2-a1bb-1b4ced82881d');
        exit(BandExpressionConsumerId);
    end;

    procedure GetPeriodRowExpressionConsumerId(): Guid
    begin
        if IsNullGuid(PeriodRowExpressionConsumerId) then
            Evaluate(PeriodRowExpressionConsumerId, 'f48eb3f6-14d0-4d99-8137-9ff950f223f9');
        exit(PeriodRowExpressionConsumerId)
    end;

    procedure GetDimensionRowExpressionConsumerId(): Guid
    begin
        if IsNullGuid(DimensionRowExpressionConsumerId) then
            Evaluate(DimensionRowExpressionConsumerId, '44398a3f-5733-4e2d-afb8-4aaaa378fc1c');
        exit(DimensionRowExpressionConsumerId);
    end;

    procedure CalculatePerformanceBand(
        var Buffer: Record lvnPerformanceValueBuffer;
        BandNo: Integer;
        var RowSchema: Record lvnPerformanceRowSchema;
        var ColSchema: Record lvnPerformanceColSchema;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter)
    var
        Cache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]];
    begin
        CalculatePerformanceBand(Buffer, BandNo, RowSchema, ColSchema, TempSystemCalcFilter, Cache, Path);
    end;

    procedure CalculateFormulaBand(
        var Buffer: Record lvnPerformanceValueBuffer;
        BandNo: Integer;
        var RowSchema: Record lvnPerformanceRowSchema;
        var ColSchema: Record lvnPerformanceColSchema;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter;
        RowFormulaCode: Code[20];
        ExpressionConsumerId: Guid)
    var
        ColLine: Record lvnPerformanceColSchemaLine;
        RowLine: Query lvnPerformanceRowLiteralLine;
        Cache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]];
    begin
        ColLine.Reset();
        ColLine.SetRange("Schema Code", ColSchema.Code);
        ColLine.FindSet();
        //The catch here is the following:
        //First those cells which are legible for row formula are just calculated and pushed to cache
        //Then regular Calculate PerformanceBand is called to calculate the rest of cells while already calculated will be taken from cache
        repeat
            RowLine.SetRange(SchemaCode, RowSchema.Code);
            RowLine.SetRange(ColumnNo, ColLine."Column No.");
            RowLine.Open();
            while RowLine.Read() do
                CalculateSingleRowValue(RowLine.LineNo, ColLine."Column No.", RowLine.CalcUnitCode, RowFormulaCode, ExpressionConsumerId, Buffer, Cache, Path);
            RowLine.Close();
        until ColLine.Next() = 0;
        CalculatePerformanceBand(Buffer, BandNo, RowSchema, ColSchema, TempSystemCalcFilter, Cache, Path);
    end;

    procedure ApplyLoanFilter(
        var Loan: Record lvnLoan;
        var CalcUnit: Record lvnCalculationUnit;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter)
    begin
        Loan.FilterGroup(2);
        if CalcUnit."Dimension 1 Filter" <> '' then
            Loan.SetFilter("Global Dimension 1 Code", CalcUnit."Dimension 1 Filter")
        else
            if TempSystemCalcFilter."Global Dimension 1" <> '' then
                Loan.SetFilter("Global Dimension 1 Code", TempSystemCalcFilter."Global Dimension 1");
        if CalcUnit."Dimension 2 Filter" <> '' then
            Loan.SetFilter("Global Dimension 2 Code", CalcUnit."Dimension 2 Filter")
        else
            if TempSystemCalcFilter."Global Dimension 2" <> '' then
                Loan.SetFilter("Global Dimension 2 Code", TempSystemCalcFilter."Global Dimension 2");
        if CalcUnit."Dimension 3 Filter" <> '' then
            Loan.SetFilter("Shortcut Dimension 3 Code", CalcUnit."Dimension 3 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 3" <> '' then
                Loan.SetFilter("Shortcut Dimension 3 Code", TempSystemCalcFilter."Shortcut Dimension 3");
        if CalcUnit."Dimension 4 Filter" <> '' then
            Loan.SetFilter("Shortcut Dimension 4 Code", CalcUnit."Dimension 4 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 4" <> '' then
                Loan.SetFilter("Shortcut Dimension 4 Code", TempSystemCalcFilter."Shortcut Dimension 4");
        if CalcUnit."Dimension 5 Filter" <> '' then
            Loan.SetFilter("Shortcut Dimension 5 Code", CalcUnit."Dimension 5 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 5" <> '' then
                Loan.SetFilter("Shortcut Dimension 5 Code", TempSystemCalcFilter."Shortcut Dimension 5");
        if CalcUnit."Dimension 6 Filter" <> '' then
            Loan.SetFilter("Shortcut Dimension 6 Code", CalcUnit."Dimension 6 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 6" <> '' then
                Loan.SetFilter("Shortcut Dimension 6 Code", TempSystemCalcFilter."Shortcut Dimension 6");
        if CalcUnit."Dimension 7 Filter" <> '' then
            Loan.SetFilter("Shortcut Dimension 7 Code", CalcUnit."Dimension 7 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 7" <> '' then
                Loan.SetFilter("Shortcut Dimension 7 Code", TempSystemCalcFilter."Shortcut Dimension 7");
        if CalcUnit."Dimension 8 Filter" <> '' then
            Loan.SetFilter("Shortcut Dimension 8 Code", CalcUnit."Dimension 8 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 8" <> '' then
                Loan.SetFilter("Shortcut Dimension 8 Code", TempSystemCalcFilter."Shortcut Dimension 8");
        if CalcUnit."Business Unit Filter" <> '' then
            Loan.SetFilter("Business Unit Code", CalcUnit."Business Unit Filter")
        else
            if TempSystemCalcFilter."Business Unit" <> '' then
                Loan.SetFilter("Business Unit Code", TempSystemCalcFilter."Business Unit");
        case CalcUnit."Based On Date" of
            CalcUnit."Based On Date"::Application:
                Loan.SetFilter("Application Date", TempSystemCalcFilter."Date Filter");
            CalcUnit."Based On Date"::Closed:
                Loan.SetFilter("Date Closed", TempSystemCalcFilter."Date Filter");
            CalcUnit."Based On Date"::Funded:
                Loan.SetFilter("Date Funded", TempSystemCalcFilter."Date Filter");
            CalcUnit."Based On Date"::Locked:
                Loan.SetFilter("Date Locked", TempSystemCalcFilter."Date Filter");
            CalcUnit."Based On Date"::Sold:
                Loan.SetFilter("Date Sold", TempSystemCalcFilter."Date Filter");
            CalcUnit."Based On Date"::Commission:
                Loan.SetFilter("Commission Date", TempSystemCalcFilter."Date Filter");
        end;
        Loan.FilterGroup(0);
    end;

    procedure ApplyGLFilter(
        var GLEntry: Record "G/L Entry";
        var CalcUnit: Record lvnCalculationUnit;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter)
    begin
        GLEntry.FilterGroup(2);
        GLEntry.SetFilter("G/L Account No.", CalcUnit."Account No. Filter");
        if CalcUnit."Dimension 1 Filter" <> '' then
            GLEntry.SetFilter("Global Dimension 1 Code", CalcUnit."Dimension 1 Filter")
        else
            if TempSystemCalcFilter."Global Dimension 1" <> '' then
                GLEntry.SetFilter("Global Dimension 1 Code", TempSystemCalcFilter."Global Dimension 1");
        if CalcUnit."Dimension 2 Filter" <> '' then
            GLEntry.SetFilter("Global Dimension 2 Code", CalcUnit."Dimension 2 Filter")
        else
            if TempSystemCalcFilter."Global Dimension 2" <> '' then
                GLEntry.SetFilter("Global Dimension 2 Code", TempSystemCalcFilter."Global Dimension 2");
        if CalcUnit."Dimension 3 Filter" <> '' then
            GLEntry.SetFilter(lvnShortcutDimension3Code, CalcUnit."Dimension 3 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 3" <> '' then
                GLEntry.SetFilter(lvnShortcutDimension3Code, TempSystemCalcFilter."Shortcut Dimension 3");
        if CalcUnit."Dimension 4 Filter" <> '' then
            GLEntry.SetFilter(lvnShortcutDimension4Code, CalcUnit."Dimension 4 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 4" <> '' then
                GLEntry.SetFilter(lvnShortcutDimension4Code, TempSystemCalcFilter."Shortcut Dimension 4");
        if CalcUnit."Dimension 5 Filter" <> '' then
            GLEntry.SetFilter(lvnShortcutDimension5Code, CalcUnit."Dimension 5 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 5" <> '' then
                GLEntry.SetFilter(lvnShortcutDimension5Code, TempSystemCalcFilter."Shortcut Dimension 5");
        if CalcUnit."Dimension 6 Filter" <> '' then
            GLEntry.SetFilter(lvnShortcutDimension6Code, CalcUnit."Dimension 6 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 6" <> '' then
                GLEntry.SetFilter(lvnShortcutDimension6Code, TempSystemCalcFilter."Shortcut Dimension 6");
        if CalcUnit."Dimension 7 Filter" <> '' then
            GLEntry.SetFilter(lvnShortcutDimension7Code, CalcUnit."Dimension 7 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 7" <> '' then
                GLEntry.SetFilter(lvnShortcutDimension7Code, TempSystemCalcFilter."Shortcut Dimension 7");
        if CalcUnit."Dimension 8 Filter" <> '' then
            GLEntry.SetFilter(lvnShortcutDimension8Code, CalcUnit."Dimension 8 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 8" <> '' then
                GLEntry.SetFilter(lvnShortcutDimension8Code, TempSystemCalcFilter."Shortcut Dimension 8");
        if CalcUnit."Business Unit Filter" <> '' then
            GLEntry.SetFilter("Business Unit Code", CalcUnit."Business Unit Filter")
        else
            if TempSystemCalcFilter."Business Unit" <> '' then
                GLEntry.SetFilter("Business Unit Code", TempSystemCalcFilter."Business Unit");
        GLEntry.SetFilter("Posting Date", TempSystemCalcFilter.GetGLPostingDateFilter());
        GLEntry.FilterGroup(0);
    end;

    procedure GetData(
        var Buffer: Record lvnPerformanceValueBuffer;
        var StylesInUse: Dictionary of [Code[20], Boolean];
        RowSchemaCode: Code[20];
        ColSchemaCode: Code[20]) DataSource: JsonArray
    var
        RowLine: Record lvnPerformanceRowSchemaLine;
        ColLine: Record lvnPerformanceColSchemaLine;
        RowData: JsonObject;
        ValueData: JsonObject;
        ShowLine: Boolean;
        FirstRowNo: Integer;
    begin
        RowLine.Reset();
        RowLine.SetRange("Schema Code", RowSchemaCode);
        RowLine.SetRange("Column No.", 1);
        RowLine.FindSet();
        repeat
            case RowLine."Row Type" of
                RowLine."Row Type"::Normal:
                    begin
                        ShowLine := true;
                        if RowLine."Hide Zero Line" then begin
                            Buffer.Reset();
                            Buffer.SetRange("Row No.", RowLine."Line No.");
                            Buffer.SetFilter(Value, '<>%1', 0);
                            if Buffer.IsEmpty then
                                ShowLine := false;
                        end;
                        if ShowLine then begin
                            Clear(RowData);
                            RowData.Add('rowId', RowLine."Line No.");
                            RowData.Add('Name', RowLine.Description);
                            if RowLine."Row Style" <> '' then begin
                                StylesInUse.Set(RowLine."Row Style", true);
                                RowData.Add('CssClass', 'pw-' + LowerCase(RowLine."Row Style"));
                            end;
                            Buffer.Reset();
                            Buffer.SetRange("Row No.", RowLine."Line No.");
                            Buffer.FindSet();
                            repeat
                                if (not Buffer.Interactive) and (Buffer."Style Code" = '') then
                                    RowData.Add(StrSubstNo(FieldFormatTxt, Buffer."Band No.", Buffer."Column No."), FormatValue(Buffer))
                                else begin
                                    Clear(ValueData);
                                    ValueData.Add('v', FormatValue(Buffer));
                                    if Buffer.Interactive then
                                        ValueData.Add('i', Buffer.Interactive);
                                    if Buffer."Style Code" <> '' then begin
                                        StylesInUse.Set(Buffer."Style Code", true);
                                        ValueData.Add('c', 'pw-' + LowerCase(Buffer."Style Code"));
                                    end;
                                    RowData.Add(StrSubstNo(FieldFormatTxt, Buffer."Band No.", Buffer."Column No."), ValueData);
                                end;
                            until Buffer.Next() = 0;
                            DataSource.Add(RowData);
                        end;
                    end;
                RowLine."Row Type"::Header:
                    begin
                        Clear(RowData);
                        RowData.Add('rowId', RowLine."Line No.");
                        RowData.Add('CssClass', 'secondary-header');
                        Buffer.Reset();
                        Buffer.FindFirst();
                        FirstRowNo := Buffer."Row No.";
                        Buffer.Reset();
                        Buffer.SetRange("Row No.", FirstRowNo);
                        Buffer.SetRange("Column No.", 1);
                        Buffer.FindSet();
                        repeat
                            ColLine.Reset();
                            ColLine.SetRange("Schema Code", ColSchemaCode);
                            ColLine.FindSet();
                            repeat
                                RowData.Add(StrSubstNo(FieldFormatTxt, Buffer."Band No.", ColLine."Column No."), ColLine."Secondary Caption");
                            until ColLine.Next() = 0;
                        until Buffer.Next() = 0;
                        DataSource.Add(RowData);
                    end;
                RowLine."Row Type"::Empty:
                    begin
                        Clear(RowData);
                        RowData.Add('rowId', RowLine."Line No.");
                        RowData.Add('Name', RowLine.Description);
                        if RowLine."Row Style" <> '' then begin
                            StylesInUse.Set(RowLine."Row Style", true);
                            RowData.Add('CssClass', 'pw-' + LowerCase(RowLine."Row Style"));
                        end;
                        DataSource.Add(RowData);
                    end;
            end;
        until RowLine.Next() = 0;
    end;

    procedure FormatValue(NumericValue: Decimal; FormatCode: Code[20]) TextValue: Text
    var
        NumberFormat: Record lvnNumberFormat;
    begin
        if not NumberFormat.Get(FormatCode) then
            Clear(NumberFormat);
        TextValue := NumberFormat.FormatValue(NumericValue);
    end;

    procedure GetGridStyles(StylesInUse: List of [Code[20]]) Json: JsonObject
    var
        Style: Record lvnStyle;
        CssClass: JsonObject;
        StyleCode: Code[20];
    begin
        Clear(CssClass);
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('font-style', 'italic');
        CssClass.Add('font-size', '14px');
        CssClass.Add('text-decoration', 'underline');
        CssClass.Add('text-align', 'center !important');
        CssClass.Add('border-left', 'none !important');
        CssClass.Add('border-right', 'none !important');
        Json.Add('.dx-header-row td', CssClass);
        Clear(CssClass);
        CssClass.Add('text-align', 'center');
        CssClass.Add('font-style', 'italic');
        CssClass.Add('text-decoration', 'underline');
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('color', '#959595');
        Json.Add('tr.secondary-header', CssClass);
        Clear(CssClass);
        CssClass.Add('border', '1px solid #ddd');
        Json.Add('tr.secondary-header td', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '12px');
        CssClass.Add('text-align', 'right');
        Json.Add('.dx-data-row', CssClass);
        Clear(CssClass);
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('text-align', 'left');
        CssClass.Add('border-right', '1px solid #808080');
        CssClass.Add('white-space', 'nowrap');
        Json.Add('td.desc', CssClass);
        Clear(CssClass);
        CssClass.Add('text-align', 'right');
        Json.Add('.right', CssClass);
        Clear(CssClass);
        CssClass.Add('color', 'red');
        Json.Add('.red', CssClass);
        Clear(CssClass);
        CssClass.Add('font-weight', 'bold');
        Json.Add('.bold', CssClass);
        Clear(CssClass);
        CssClass.Add('font-style', 'italic');
        Json.Add('.italic', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '14px');
        Json.Add('.big', CssClass);
        Clear(CssClass);
        CssClass.Add('color', 'blue');
        Json.Add('.font-blue', CssClass);
        Clear(CssClass);
        CssClass.Add('background-color', '#CCFFCC');
        Json.Add('.background-honeydew', CssClass);
        Clear(CssClass);
        CssClass.Add('background-color', '#99CCFF');
        Json.Add('.background-columbia-blue', CssClass);
        Clear(CssClass);
        CssClass.Add('border-bottom', '1px solid #808080');
        Json.Add('.border-bottom-thin td', CssClass);
        Clear(CssClass);
        CssClass.Add('border-bottom', '3px solid #808080');
        Json.Add('.border-bottom-thick td', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '2px');
        CssClass.Add('line-height', '1');
        Json.Add('td.third-size', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '16px');
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('font-style', 'italic');
        CssClass.Add('border-top', '3px double #000');
        CssClass.Add('border-bottom', '3px double #000');
        CssClass.Add('background-color', '#C0C0C0');
        Json.Add('.heading td', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '12px');
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('border-top', '1px solid #000');
        CssClass.Add('border-bottom', 'solid #000');
        Json.Add('.subtotals td', CssClass);
        Clear(CssClass);
        CssClass.Add('font-size', '12px');
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('border-top', '1px solid #000');
        CssClass.Add('border-bottom', 'double #000');
        Json.Add('.totals td', CssClass);
        Clear(CssClass);
        CssClass.Add('padding-left', '15px !important');
        Json.Add('.indent1 td:first-child', CssClass);
        Clear(CssClass);
        CssClass.Add('padding-left', '25px !important');
        Json.Add('.indent2 td:first-child', CssClass);
        Clear(CssClass);
        CssClass.Add('padding-left', '35px !important');
        Json.Add('.ident3 td:first-child', CssClass);
        foreach StyleCode in StylesInUse do
            if Style.Get(StyleCode) then begin
                Clear(CssClass);
                case Style.Bold of
                    Style.Bold::Yes:
                        CssClass.Add('font-weight', 'bold');
                    Style.Bold::No:
                        CssClass.Add('font-weight', 'normal');
                end;
                case Style.Italic of
                    Style.Italic::Yes:
                        CssClass.Add('font-style', 'italic');
                    Style.Italic::No:
                        CssClass.Add('font-style', 'normal');
                end;
                case Style.Underline of
                    Style.Underline::Yes:
                        CssClass.Add('text-decoration', 'underline');
                    Style.Underline::No:
                        CssClass.Add('text-decoration', 'none');
                end;
                if Style."Font Size" > 0 then
                    CssClass.Add('font-size', StrSubstNo(PixelSizeTxt, Style."Font Size"));
                if Style."Font Color" <> '' then
                    CssClass.Add('color', Style."Font Color");
                if Style."Background Color" <> '' then
                    CssClass.Add('background-color', Style."Background Color");
                Json.Add('.pw-' + LowerCase(StyleCode), CssClass);
            end;
    end;

    procedure CalculateSingleValue(
        var RowLine: Record lvnPerformanceRowSchemaLine;
        var CalculationUnit: Record lvnCalculationUnit;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter;
        var BandCache: Dictionary of [Code[20], Decimal];
        var CellCache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]];
        var IsVolatile: Boolean) Result: Decimal
    var
        RefRowLine: Record lvnPerformanceRowSchemaLine;
        RefCalculationUnit: Record lvnCalculationUnit;
    begin
        if CellCache.Get(CalculationUnit.Code, Result) then
            exit;
        if BandCache.Get(CalculationUnit.Code, Result) then
            exit;
        if Path.IndexOf(CalculationUnit.Code) <> 0 then
            Error(CircularReferenceErr);
        case CalculationUnit.Type of
            CalculationUnit.Type::Constant:
                Result := CalculationUnit."Constant Value";
            CalculationUnit.Type::"Amount Lookup", CalculationUnit.Type::"Count Lookup":
                case CalculationUnit."Lookup Source" of
                    CalculationUnit."Lookup Source"::"Loan Card":
                        Result := LookupLoanCard(CalculationUnit, TempSystemCalcFilter);
                    CalculationUnit."Lookup Source"::"Ledger Entries":
                        Result := LookupGeneralLedger(CalculationUnit, TempSystemCalcFilter);
                    CalculationUnit."Lookup Source"::"Loan Values":
                        Result := LookupLoanValue(CalculationUnit, TempSystemCalcFilter);
                end;
            CalculationUnit.Type::Expression:
                begin
                    Path.Add(CalculationUnit.Code);
                    Result := CalculateBandExpression(RowLine, CalculationUnit, TempSystemCalcFilter, BandCache, CellCache, Path, IsVolatile);
                    Path.RemoveAt(Path.Count());
                end;
            CalculationUnit.Type::"Cell Reference":
                begin
                    if (CalculationUnit."Row No." = 0) or (CalculationUnit."Column No." = 0) then
                        IsVolatile := true;
                    if CalculationUnit."Row No." = 0 then
                        CalculationUnit."Row No." := RowLine."Line No.";
                    if CalculationUnit."Column No." = 0 then
                        CalculationUnit."Column No." := RowLine."Column No.";
                    if (CalculationUnit."Row No." = RowLine."Line No.") and (CalculationUnit."Column No." = RowLine."Column No.") then
                        Error(CircularReferenceErr);
                    if RefRowLine.Get(RowLine."Schema Code", CalculationUnit."Row No.", CalculationUnit."Column No.") then
                        if RefCalculationUnit.Get(RefRowLine."Calculation Unit Code") then
                            Result := CalculateSingleValue(RowLine, RefCalculationUnit, TempSystemCalcFilter, BandCache, CellCache, Path, IsVolatile);
                end;
            CalculationUnit.Type::"Provider Value":
                begin
                    GetProviderValue(CalculationUnit."Provider Metadata", TempSystemCalcFilter, Result);
                    IsVolatile := true;
                end;
        end;
        if IsVolatile then
            CellCache.Add(CalculationUnit.Code, Result)
        else
            BandCache.Add(CalculationUnit.Code, Result);
    end;

    procedure ApplyPeriodBandFilter(
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter;
        var BaseFilter: Record lvnSystemCalculationFilter;
        var BandLineInfo: Record lvnPerformanceBandLineInfo)
    begin
        Clear(TempSystemCalcFilter);
        TempSystemCalcFilter := BaseFilter;
        TempSystemCalcFilter."Date Filter" := StrSubstNo(FilterRangeTxt, BandLineInfo."Date From", BandLineInfo."Date To");
    end;

    procedure ApplyDimensionBandFilter(
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter;
        var BandSchema: Record lvnDimensionPerfBandSchema;
        var BandLine: Record lvnDimPerfBandSchemaLine)
    var
        DimensionValue: Record "Dimension Value";
    begin
        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", BandSchema."Dimension Code");
        DimensionValue.SetFilter(Code, BandLine."Dimension Filter");
        DimensionValue.FindFirst();
        case DimensionValue."Global Dimension No." of
            1:
                TempSystemCalcFilter."Global Dimension 1" := BandLine."Dimension Filter";
            2:
                TempSystemCalcFilter."Global Dimension 2" := BandLine."Dimension Filter";
            3:
                TempSystemCalcFilter."Shortcut Dimension 3" := BandLine."Dimension Filter";
            4:
                TempSystemCalcFilter."Shortcut Dimension 4" := BandLine."Dimension Filter";
            5:
                TempSystemCalcFilter."Shortcut Dimension 5" := BandLine."Dimension Filter";
            6:
                TempSystemCalcFilter."Shortcut Dimension 6" := BandLine."Dimension Filter";
            7:
                TempSystemCalcFilter."Shortcut Dimension 7" := BandLine."Dimension Filter";
            8:
                TempSystemCalcFilter."Shortcut Dimension 8" := BandLine."Dimension Filter";
        end;
    end;

    procedure CalculatePeriodsData(
        var RowSchema: Record lvnPerformanceRowSchema;
        var BandSchema: Record lvnPeriodPerfBandSchema;
        var BaseFilter: Record lvnSystemCalculationFilter;
        var BandInfoBuffer: Record lvnPerformanceBandLineInfo;
        var TempValueBuffer: Record lvnPerformanceValueBuffer)
    var
        ColSchema: Record lvnPerformanceColSchema;
        BandLine: Record lvnPeriodPerfBandSchemaLine;
        AccountingPeriod: Record "Accounting Period";
        TempSystemCalcFilter: Record lvnSystemCalculationFilter temporary;
        StartDate: Date;
        EndDate: Date;
        TotalStartDate: Date;
        TotalEndDate: Date;
        Multiplier: Integer;
        Idx: Integer;
    begin
        ColSchema.Get(RowSchema."Column Schema");
        BandInfoBuffer.Reset();
        BandInfoBuffer.DeleteAll();
        Idx := 0;
        BandLine.Reset();
        BandLine.SetRange("Schema Code", BandSchema.Code);
        BandLine.FindSet();
        repeat
            Clear(BandInfoBuffer);
            BandInfoBuffer."Band No." := BandLine."Band No.";
            BandInfoBuffer."Band Type" := BandLine."Band Type";
            BandInfoBuffer."Row Formula Code" := BandLine."Row Formula Code";
            BandInfoBuffer."Header Description" := BandLine."Header Description";
            BandInfoBuffer."Band Index" := Idx;
            case BandLine."Band Type" of
                BandLine."Band Type"::Normal,
                BandLine."Band Type"::Formula:  //In case expression formula refers to not cached row formula value it will be calculated as Normal
                    begin
                        TotalStartDate := 0D;
                        TotalEndDate := 0D;
                        case BandLine."Period Type" of
                            BandLine."Period Type"::MTD:
                                begin
                                    StartDate := CalcDate('<-CM>', BaseFilter."As Of Date");
                                    if BandLine."Period Offset" <> 0 then
                                        StartDate := CalcDate(StrSubstNo(DateOffsetMonthTxt, BandLine."Period Offset"), StartDate);
                                    EndDate := CalcDate('<CM>', StartDate);
                                    BandInfoBuffer."Date From" := StartDate;
                                    BandInfoBuffer."Date To" := EndDate;
                                    if BandLine."Dynamic Date Description" then
                                        BandInfoBuffer."Header Description" := Format(StartDate, 0, '<Month Text,3>-<Year4>');
                                end;
                            BandLine."Period Type"::QTD:
                                begin
                                    StartDate := CalcDate('<-CQ>', BaseFilter."As Of Date");
                                    if BandLine."Period Offset" <> 0 then begin
                                        StartDate := CalcDate(StrSubstNo(DateOffsetQuarterTxt, BandLine."Period Offset"), StartDate);
                                        if Format(BandLine."Period Length Formula") = '' then
                                            EndDate := CalcDate('<CQ>', BaseFilter."As Of Date")
                                        else
                                            EndDate := CalcDate(BandLine."Period Length Formula", StartDate);
                                    end else
                                        if Format(BandLine."Period Length Formula") = '' then
                                            EndDate := BaseFilter."As Of Date"
                                        else
                                            EndDate := CalcDate(BandLine."Period Length Formula", StartDate);
                                    BandInfoBuffer."Date From" := StartDate;
                                    BandInfoBuffer."Date To" := EndDate;
                                    if BandLine."Dynamic Date Description" then
                                        BandInfoBuffer."Header Description" := Format(StartDate, 0, 'Qtr. <Quarter>, <Year4>');
                                end;
                            BandLine."Period Type"::YTD:
                                begin
                                    StartDate := CalcDate('<-CY>', BaseFilter."As Of Date");
                                    if BandLine."Period Offset" <> 0 then begin
                                        StartDate := CalcDate(StrSubstNo(DateOffsetYearTxt, BandLine."Period Offset"), StartDate);
                                        EndDate := CalcDate('<CY>', StartDate);
                                    end else
                                        EndDate := BaseFilter."As Of Date";
                                    BandInfoBuffer."Date From" := StartDate;
                                    BandInfoBuffer."Date To" := EndDate;
                                    if BandLine."Dynamic Date Description" then
                                        BandInfoBuffer."Header Description" := Format(StartDate, 0, 'Year <Year4>');
                                end;
                            BandLine."Period Type"::"Fiscal QTD":
                                begin
                                    AccountingPeriod.Reset();
                                    AccountingPeriod.SetRange("Starting Date", 0D, BaseFilter."As Of Date");
                                    AccountingPeriod.SetRange(lvnFiscalQuarter, true);
                                    AccountingPeriod.FindLast();
                                    StartDate := AccountingPeriod."Starting Date";
                                    if BandLine."Period Offset" <> 0 then begin
                                        Multiplier := 3 * BandLine."Period Offset";
                                        StartDate := CalcDate(StrSubstNo(DateOffsetMonthTxt, Multiplier), StartDate);
                                        if Format(BandLine."Period Length Formula") = '' then begin
                                            AccountingPeriod.SetFilter("Starting Date", '>%1', StartDate);
                                            AccountingPeriod.FindFirst();
                                            EndDate := AccountingPeriod."Starting Date" - 1;
                                        end else
                                            EndDate := CalcDate(BandLine."Period Length Formula", StartDate);
                                    end else
                                        if Format(BandLine."Period Length Formula") = '' then
                                            EndDate := BaseFilter."As Of Date"
                                        else
                                            EndDate := CalcDate(BandLine."Period Length Formula", StartDate);
                                    BandInfoBuffer."Date From" := StartDate;
                                    BandInfoBuffer."Date To" := EndDate;
                                    if BandLine."Dynamic Date Description" then
                                        if BandInfoBuffer."Header Description" = '' then
                                            BandInfoBuffer."Header Description" := Format(StartDate, 0, '<Month,2>/<Day,2>/<Year4>') + ' to ' + Format(EndDate, 0, '<Month,2>/<Day,2>/<Year4>')
                                        else
                                            BandInfoBuffer."Header Description" := Format(StartDate, 0, BandInfoBuffer."Header Description");
                                end;
                            BandLine."Period Type"::"Fiscal YTD":
                                begin
                                    AccountingPeriod.Reset();
                                    AccountingPeriod.SetRange("New Fiscal Year", true);
                                    AccountingPeriod.SetRange("Starting Date", 0D, BaseFilter."As Of Date");
                                    if AccountingPeriod.FindLast() then
                                        StartDate := AccountingPeriod."Starting Date"
                                    else begin
                                        AccountingPeriod.Reset();
                                        AccountingPeriod.FindFirst();
                                        StartDate := AccountingPeriod."Starting Date";
                                    end;
                                    if BandLine."Period Offset" <> 0 then begin
                                        StartDate := CalcDate(StrSubstNo(DateOffsetYearTxt, BandLine."Period Offset"), StartDate);
                                        if Format(BandLine."Period Length Formula") = '' then begin
                                            EndDate := CalcDate('<-1Y>', BaseFilter."As Of Date");
                                            EndDate := CalcDate('<CM>', EndDate);
                                        end else
                                            EndDate := CalcDate(BandLine."Period Length Formula", StartDate);
                                    end else
                                        EndDate := BaseFilter."As Of Date";
                                    BandInfoBuffer."Date From" := StartDate;
                                    BandInfoBuffer."Date To" := EndDate;
                                    if BandLine."Dynamic Date Description" then
                                        if BandInfoBuffer."Header Description" = '' then
                                            BandInfoBuffer."Header Description" := Format(StartDate, 0, '<Year4>/<Month>') + ' to ' + Format(EndDate, 0, '<Year4>/<Month>')
                                        else
                                            BandInfoBuffer."Header Description" := Format(EndDate, 0, BandInfoBuffer."Header Description");
                                end;
                            BandLine."Period Type"::"Life To Date":
                                begin
                                    StartDate := 00010101D;
                                    EndDate := BaseFilter."As Of Date";
                                    if Format(BandLine."Period Length Formula") <> '' then
                                        EndDate := CalcDate(BandLine."Period Length Formula", EndDate);
                                    EndDate := CalcDate('<CM>', EndDate);
                                    if BandLine."Header Description" <> '' then
                                        BandInfoBuffer."Header Description" := CopyStr(BandLine."Header Description" + ' ', 1, MaxStrLen(BandInfoBuffer."Header Description"));
                                    BandInfoBuffer."Header Description" := CopyStr(BandInfoBuffer."Header Description" + Format(EndDate, 0, '<Month Text>/<Year4>'), 1, MaxStrLen(BandInfoBuffer."Header Description"));
                                    BandInfoBuffer."Date From" := StartDate;
                                    BandInfoBuffer."Date To" := EndDate;
                                end;
                            BandLine."Period Type"::Custom:
                                begin
                                    BandLine.TestField("Date From");
                                    BandLine.TestField("Date To");
                                    BandInfoBuffer."Date From" := BandLine."Date From";
                                    BandInfoBuffer."Date To" := BandLine."Date To";
                                    if BandInfoBuffer."Header Description" = '' then
                                        BandInfoBuffer."Header Description" := Format(BandLine."Date From") + '..' + Format(BandLine."Date To");
                                end;
                        end;
                        if (TotalStartDate = 0D) and (TotalEndDate = 0D) then begin
                            TotalStartDate := BandInfoBuffer."Date From";
                            TotalEndDate := BandInfoBuffer."Date To";
                        end else begin
                            if BandInfoBuffer."Date From" < TotalStartDate then
                                TotalStartDate := BandInfoBuffer."Date From";
                            if BandInfoBuffer."Date To" > TotalEndDate then
                                TotalEndDate := BandInfoBuffer."Date To";
                        end;
                    end;
                BandLine."Band Type"::Totals:
                    begin
                        BandInfoBuffer."Date From" := TotalStartDate;
                        BandInfoBuffer."Date To" := TotalEndDate;
                        if BandInfoBuffer."Header Description" = '' then
                            BandInfoBuffer."Header Description" := Format(BandInfoBuffer."Date From") + '..' + Format(BandInfoBuffer."Date To");
                    end;
                else
                    Error(UnsupportedBandTypeErr, BandLine);
            end;
            if BaseFilter."Block Data To Date" <> 0D then
                if BandInfoBuffer."Date From" <= BaseFilter."Block Data To Date" then
                    BandInfoBuffer."Date From" := BaseFilter."Block Data To Date" + 1;
            if BaseFilter."Block Data From Date" <> 0D then
                if BandInfoBuffer."Date To" >= BaseFilter."Block Data From Date" then
                    BandInfoBuffer."Date To" := BaseFilter."Block Data To Date" - 1;
            if BandInfoBuffer."Date From" <= BandInfoBuffer."Date To" then begin
                BandInfoBuffer.Insert();
                Idx += 1;
            end;
        until BandLine.Next() = 0;

        BandInfoBuffer.Reset();
        BandInfoBuffer.SetFilter("Band Type", '<>%1', BandInfoBuffer."Band Type"::Formula);
        BandInfoBuffer.FindSet();
        repeat
            ApplyPeriodBandFilter(TempSystemCalcFilter, BaseFilter, BandInfoBuffer);
            CalculatePerformanceBand(TempValueBuffer, BandInfoBuffer."Band No.", RowSchema, ColSchema, TempSystemCalcFilter);
        until BandInfoBuffer.Next() = 0;

        BandInfoBuffer.Reset();
        BandInfoBuffer.SetRange("Band Type", BandInfoBuffer."Band Type"::Formula);
        if BandInfoBuffer.FindSet() then
            repeat
                ApplyPeriodBandFilter(TempSystemCalcFilter, BaseFilter, BandInfoBuffer);
                CalculateFormulaBand(TempValueBuffer, BandInfoBuffer."Band No.", RowSchema, ColSchema, TempSystemCalcFilter, BandInfoBuffer."Row Formula Code", GetPeriodRowExpressionConsumerId());
            until BandInfoBuffer.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Page, Page::lvnExpressionList, 'FillBuffer', '', false, false)]
    local procedure OnFillBuffer(
        ExpressionHeader: Record lvnExpressionHeader;
        ConsumerMetadata: Text;
        var ExpressionBuffer: Record lvnExpressionValueBuffer)
    var
        CalcUnitLine: Record lvnCalculationUnitLine;
        DimPerfBandSchemaLine: Record lvnDimPerfBandSchemaLine;
        PeriodPerfBandSchemaLine: Record lvnPeriodPerfBandSchemaLine;
    begin
        case ExpressionHeader."Consumer Id" of
            GetBandExpressionConsumerId():
                begin
                    CalcUnitLine.Reset();
                    CalcUnitLine.SetRange("Unit Code", ConsumerMetadata);
                    if CalcUnitLine.FindSet() then
                        repeat
                            Clear(ExpressionBuffer);
                            ExpressionBuffer.Name := CalcUnitLine."Source Unit Code";
                            ExpressionBuffer.Number := CalcUnitLine."Line no.";
                            ExpressionBuffer.Type := 'Decimal';
                            ExpressionBuffer.Insert();
                        until CalcUnitLine.Next() = 0;
                end;
            GetPeriodRowExpressionConsumerId():
                begin
                    PeriodPerfBandSchemaLine.Reset();
                    PeriodPerfBandSchemaLine.SetRange("Schema Code", ConsumerMetadata);
                    PeriodPerfBandSchemaLine.SetFilter("Band Type", '<>%1', PeriodPerfBandSchemaLine."Band Type"::Formula);
                    if PeriodPerfBandSchemaLine.FindSet() then
                        repeat
                            Clear(ExpressionBuffer);
                            ExpressionBuffer.Name := 'BAND' + Format(PeriodPerfBandSchemaLine."Band No.");
                            ExpressionBuffer.Number := PeriodPerfBandSchemaLine."Band no.";
                            ExpressionBuffer.Type := 'Decimal';
                            ExpressionBuffer.Insert();
                        until PeriodPerfBandSchemaLine.Next() = 0;
                end;
            GetDimensionRowExpressionConsumerId():
                begin
                    DimPerfBandSchemaLine.Reset();
                    DimPerfBandSchemaLine.SetRange("Schema Code", ConsumerMetadata);
                    DimPerfBandSchemaLine.SetFilter("Band Type", '<>%1', DimPerfBandSchemaLine."Band Type"::Formula);
                    if DimPerfBandSchemaLine.FindSet() then
                        repeat
                            Clear(ExpressionBuffer);
                            ExpressionBuffer.Name := 'BAND' + Format(DimPerfBandSchemaLine."Band No.");
                            ExpressionBuffer.Number := DimPerfBandSchemaLine."Band no.";
                            ExpressionBuffer.Type := 'Decimal';
                            ExpressionBuffer.Insert();
                        until DimPerfBandSchemaLine.Next() = 0;
                end;
        end;
    end;

    local procedure CalculatePerformanceBand(
        var Buffer: Record lvnPerformanceValueBuffer;
        BandNo: Integer;
        var RowSchema: Record lvnPerformanceRowSchema;
        var ColSchema: Record lvnPerformanceColSchema;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter;
        var BandCache: Dictionary of [Code[20], Decimal];
        var Path: List of [Code[20]])
    var
        RowLine: Record lvnPerformanceRowSchemaLine;
        ColLine: Record lvnPerformanceColSchemaLine;
        CalculationUnit: Record lvnCalculationUnit;
        CellCache: Dictionary of [Code[20], Decimal];
        IsVolatile: Boolean;
    begin
        ColLine.Reset();
        ColLine.SetRange("Schema Code", ColSchema.Code);
        ColLine.FindSet();
        repeat
            RowLine.Reset();
            RowLine.SetRange("Schema Code", RowSchema.Code);
            RowLine.SetRange("Column No.", ColLine."Column No.");
            RowLine.FindSet();
            repeat
                Clear(Buffer);
                Clear(CellCache);
                IsVolatile := false;
                Buffer."Column No." := ColLine."Column No.";
                Buffer."Row No." := RowLine."Line No.";
                Buffer."Band No." := BandNo;
                Buffer."Calculation Unit Code" := RowLine."Calculation Unit Code";
                if CalculationUnit.Get(RowLine."Calculation Unit Code") then begin
                    Buffer.Value := CalculateSingleValue(RowLine, CalculationUnit, TempSystemCalcFilter, BandCache, CellCache, Path, IsVolatile);
                    Buffer.Interactive := IsClickableCell(CalculationUnit);
                end else
                    Buffer.Value := 0;
                if Buffer.Value >= 0 then
                    if RowLine."Style Code" <> '' then
                        Buffer."Style Code" := RowLine."Style Code";
                if Buffer.Value < 0 then
                    if RowLine."Neg. Style Code" <> '' then
                        Buffer."Style Code" := RowLine."Neg. Style Code";
                Buffer."Number Format Code" := RowLine."Number Format Code";
                Buffer.Insert();
            until RowLine.Next() = 0;
        until ColLine.Next() = 0;
    end;

    local procedure FormatValue(var Buffer: Record lvnPerformanceValueBuffer): Text
    begin
        exit(FormatValue(Buffer.Value, Buffer."Number Format Code"))
    end;

    local procedure IsClickableCell(var CalculationUnit: Record lvnCalculationUnit): Boolean
    begin
        if (CalculationUnit.Type = CalculationUnit.Type::"Amount Lookup") or (CalculationUnit.Type = CalculationUnit.Type::"Count Lookup") then begin
            if CalculationUnit."Lookup Source" = CalculationUnit."Lookup Source"::"Loan Card" then
                exit(true);
            if CalculationUnit."Lookup Source" = CalculationUnit."Lookup Source"::"Ledger Entries" then
                exit(CalculationUnit."Account No. Filter" <> '');
        end;
        exit(false);
    end;

    local procedure CalculateSingleRowValue(
        RowNo: Integer;
        ColNo: Integer;
        CalculationUnitCode: Code[20];
        RowFormulaCode: Code[20];
        ExpressionConsumerId: Guid;
        var Buffer: Record lvnPerformanceValueBuffer;
        Cache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]]) Result: Decimal
    var
        TempValueBuffer: Record lvnExpressionValueBuffer temporary;
        ExpressionHeader: Record lvnExpressionHeader;
        ExpressionEngine: Codeunit lvnExpressionEngine;
        Number: Integer;
        BandNo: Integer;
    begin
        if Cache.Get(CalculationUnitCode, Result) then
            exit;
        if Path.IndexOf(CalculationUnitCode) <> 0 then
            Error(CircularReferenceErr);
        Buffer.Reset();
        Buffer.SetRange("Row No.", RowNo);
        Buffer.SetRange("Column No.", ColNo);
        if not Buffer.FindSet() then
            exit(0);
        repeat
            Clear(TempValueBuffer);
            TempValueBuffer.Number := Buffer."Band No.";
            Number := Buffer."Band No.";
            TempValueBuffer.Name := 'BAND' + Format(Buffer."Band No.");
            TempValueBuffer.Type := 'Decimal';
            TempValueBuffer.Value := Format(Buffer.Value);
            TempValueBuffer.Insert();
        until Buffer.Next() = 0;
        //Insert band count
        Buffer.Reset();
        Buffer.SetRange("Row No.", RowNo);
        Buffer.SetRange("Column No.", 1);
        Clear(TempValueBuffer);
        TempValueBuffer.Number := Number + 1;
        TempValueBuffer.Name := BandCountTxt;
        TempValueBuffer.Type := 'Decimal';
        TempValueBuffer.Value := Format(Buffer.Count());
        TempValueBuffer.Insert();
        Buffer.FindFirst();
        BandNo := Buffer."Band No.";
        //Insert column count
        Buffer.Reset();
        Buffer.SetRange("Row No.", RowNo);
        Buffer.SetRange("Band No.", BandNo);
        Clear(TempValueBuffer);
        TempValueBuffer.Number := Number + 2;
        TempValueBuffer.Name := ColCountTxt;
        TempValueBuffer.Type := 'Decimal';
        TempValueBuffer.Value := Format(Buffer.Count());
        TempValueBuffer.Insert();
        ExpressionHeader.Get(RowFormulaCode, ExpressionConsumerId);
        Evaluate(Result, ExpressionEngine.CalculateFormula(ExpressionHeader, TempValueBuffer));
        Cache.Add(CalculationUnitCode, Result);
    end;

    local procedure LookupLoanCard(
        var CalculationUnit: Record lvnCalculationUnit;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter) Result: Decimal
    var
        LoanAmountsByDimension: Query lvnLoanAmountsByDimension;
    begin
        if CalculationUnit."Dimension 1 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension1Filter, CalculationUnit."Dimension 1 Filter")
        else
            if TempSystemCalcFilter."Global Dimension 1" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension1Filter, TempSystemCalcFilter."Global Dimension 1");
        if CalculationUnit."Dimension 2 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension2Filter, CalculationUnit."Dimension 2 Filter")
        else
            if TempSystemCalcFilter."Global Dimension 2" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension2Filter, TempSystemCalcFilter."Global Dimension 2");
        if CalculationUnit."Dimension 3 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension3Filter, CalculationUnit."Dimension 3 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 3" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension3Filter, TempSystemCalcFilter."Shortcut Dimension 3");
        if CalculationUnit."Dimension 4 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension4Filter, CalculationUnit."Dimension 4 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 4" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension4Filter, TempSystemCalcFilter."Shortcut Dimension 4");
        if CalculationUnit."Dimension 5 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension5Filter, CalculationUnit."Dimension 5 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 5" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension5Filter, TempSystemCalcFilter."Shortcut Dimension 5");
        if CalculationUnit."Dimension 6 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension6Filter, CalculationUnit."Dimension 6 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 6" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension6Filter, TempSystemCalcFilter."Shortcut Dimension 6");
        if CalculationUnit."Dimension 7 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension7Filter, CalculationUnit."Dimension 7 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 7" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension7Filter, TempSystemCalcFilter."Shortcut Dimension 7");
        if CalculationUnit."Dimension 8 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension8Filter, CalculationUnit."Dimension 8 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 8" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension8Filter, TempSystemCalcFilter."Shortcut Dimension 8");
        if CalculationUnit."Business Unit Filter" <> '' then
            LoanAmountsByDimension.SetFilter(BusinessUnitFilter, CalculationUnit."Business Unit Filter")
        else
            if TempSystemCalcFilter."Business Unit" <> '' then
                LoanAmountsByDimension.SetFilter(BusinessUnitFilter, TempSystemCalcFilter."Business Unit");
        case CalculationUnit."Based On Date" of
            CalculationUnit."Based On Date"::Application:
                LoanAmountsByDimension.SetFilter(DateApplicationFilter, TempSystemCalcFilter."Date Filter");
            CalculationUnit."Based On Date"::Closed:
                LoanAmountsByDimension.SetFilter(DateClosedFilter, TempSystemCalcFilter."Date Filter");
            CalculationUnit."Based On Date"::Funded:
                LoanAmountsByDimension.SetFilter(DateFundedFilter, TempSystemCalcFilter."Date Filter");
            CalculationUnit."Based On Date"::Locked:
                LoanAmountsByDimension.SetFilter(DateLockedFilter, TempSystemCalcFilter."Date Filter");
            CalculationUnit."Based On Date"::Sold:
                LoanAmountsByDimension.SetFilter(DateSoldFilter, TempSystemCalcFilter."Date Filter");
            CalculationUnit."Based On Date"::Commission:
                LoanAmountsByDimension.SetFilter(DateCommissionFilter, TempSystemCalcFilter."Date Filter");
        end;
        LoanAmountsByDimension.Open();
        LoanAmountsByDimension.Read();
        if CalculationUnit.Type = CalculationUnit.Type::"Amount Lookup" then
            Result := LoanAmountsByDimension.LoanAmount
        else
            Result := LoanAmountsByDimension.LoanCount;
        LoanAmountsByDimension.Close();
        if (CalculationUnit.Type = CalculationUnit.Type::"Amount Lookup") and (CalculationUnit."Invert Sign") then
            Result := -Result;
    end;

    local procedure LookupLoanValue(
        var CalculationUnit: Record lvnCalculationUnit;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter) Result: Decimal
    var
        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
        LoanValuesByDimension: Query lvnLoanValuesByDimension;
    begin
        if not LoanFieldsConfiguration.Get(CalculationUnit."Field No.") then
            exit(0);
        if CalculationUnit."Dimension 1 Filter" <> '' then
            LoanValuesByDimension.SetFilter(Dimension1Filter, CalculationUnit."Dimension 1 Filter")
        else
            if TempSystemCalcFilter."Global Dimension 1" <> '' then
                LoanValuesByDimension.SetFilter(Dimension1Filter, TempSystemCalcFilter."Global Dimension 1");
        if CalculationUnit."Dimension 2 Filter" <> '' then
            LoanValuesByDimension.SetFilter(Dimension2Filter, CalculationUnit."Dimension 2 Filter")
        else
            if TempSystemCalcFilter."Global Dimension 2" <> '' then
                LoanValuesByDimension.SetFilter(Dimension2Filter, TempSystemCalcFilter."Global Dimension 2");
        if CalculationUnit."Dimension 3 Filter" <> '' then
            LoanValuesByDimension.SetFilter(Dimension3Filter, CalculationUnit."Dimension 3 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 3" <> '' then
                LoanValuesByDimension.SetFilter(Dimension3Filter, TempSystemCalcFilter."Shortcut Dimension 3");
        if CalculationUnit."Dimension 4 Filter" <> '' then
            LoanValuesByDimension.SetFilter(Dimension4Filter, CalculationUnit."Dimension 4 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 4" <> '' then
                LoanValuesByDimension.SetFilter(Dimension4Filter, TempSystemCalcFilter."Shortcut Dimension 4");
        if CalculationUnit."Dimension 5 Filter" <> '' then
            LoanValuesByDimension.SetFilter(Dimension5Filter, CalculationUnit."Dimension 5 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 5" <> '' then
                LoanValuesByDimension.SetFilter(Dimension5Filter, TempSystemCalcFilter."Shortcut Dimension 5");
        if CalculationUnit."Dimension 6 Filter" <> '' then
            LoanValuesByDimension.SetFilter(Dimension6Filter, CalculationUnit."Dimension 6 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 6" <> '' then
                LoanValuesByDimension.SetFilter(Dimension6Filter, TempSystemCalcFilter."Shortcut Dimension 6");
        if CalculationUnit."Dimension 7 Filter" <> '' then
            LoanValuesByDimension.SetFilter(Dimension7Filter, CalculationUnit."Dimension 7 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 7" <> '' then
                LoanValuesByDimension.SetFilter(Dimension7Filter, TempSystemCalcFilter."Shortcut Dimension 7");
        if CalculationUnit."Dimension 8 Filter" <> '' then
            LoanValuesByDimension.SetFilter(Dimension8Filter, CalculationUnit."Dimension 8 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 8" <> '' then
                LoanValuesByDimension.SetFilter(Dimension8Filter, TempSystemCalcFilter."Shortcut Dimension 8");
        if CalculationUnit."Business Unit Filter" <> '' then
            LoanValuesByDimension.SetFilter(BusinessUnitFilter, CalculationUnit."Business Unit Filter")
        else
            if TempSystemCalcFilter."Business Unit" <> '' then
                LoanValuesByDimension.SetFilter(BusinessUnitFilter, TempSystemCalcFilter."Business Unit");
        case CalculationUnit."Based On Date" of
            CalculationUnit."Based On Date"::Application:
                LoanValuesByDimension.SetFilter(DateApplicationFilter, TempSystemCalcFilter."Date Filter");
            CalculationUnit."Based On Date"::Closed:
                LoanValuesByDimension.SetFilter(DateClosedFilter, TempSystemCalcFilter."Date Filter");
            CalculationUnit."Based On Date"::Funded:
                LoanValuesByDimension.SetFilter(DateFundedFilter, TempSystemCalcFilter."Date Filter");
            CalculationUnit."Based On Date"::Locked:
                LoanValuesByDimension.SetFilter(DateLockedFilter, TempSystemCalcFilter."Date Filter");
            CalculationUnit."Based On Date"::Sold:
                LoanValuesByDimension.SetFilter(DateSoldFilter, TempSystemCalcFilter."Date Filter");
            CalculationUnit."Based On Date"::Commission:
                LoanValuesByDimension.SetFilter(DateCommissionFilter, TempSystemCalcFilter."Date Filter");
        end;
        LoanValuesByDimension.Open();
        LoanValuesByDimension.Read();
        if CalculationUnit.Type = CalculationUnit.Type::"Count Lookup" then
            Result := LoanValuesByDimension.Count
        else
            case LoanFieldsConfiguration."Value Type" of
                LoanFieldsConfiguration."Value Type"::Integer:
                    Result := LoanValuesByDimension.IntegerValue;
                LoanFieldsConfiguration."Value Type"::Decimal:
                    Result := LoanValuesByDimension.DecimalValue
                else
                    Result := 0;
            end;
        LoanValuesByDimension.Close();
        if (CalculationUnit.Type = CalculationUnit.Type::"Amount Lookup") and (CalculationUnit."Invert Sign") then
            Result := -Result;
    end;

    local procedure LookupGeneralLedger(
        var CalculationUnit: Record lvnCalculationUnit;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter) Result: Decimal
    var
        GLEntry: Record lvnGroupedGLEntry;
    begin
        CalculationUnit."Account No. Filter" := DelChr(CalculationUnit."Account No. Filter", '<>', ' ');
        if CalculationUnit."Account No. Filter" = '' then
            exit(0);
        GLEntry.Reset();
        GLEntry.SetFilter("G/L Account No.", CalculationUnit."Account No. Filter");
        if CalculationUnit."Dimension 1 Filter" <> '' then
            GLEntry.SetFilter("Global Dimension 1 Code", CalculationUnit."Dimension 1 Filter")
        else
            if TempSystemCalcFilter."Global Dimension 1" <> '' then
                GLEntry.SetFilter("Global Dimension 1 Code", TempSystemCalcFilter."Global Dimension 1");
        if CalculationUnit."Dimension 2 Filter" <> '' then
            GLEntry.SetFilter("Global Dimension 2 Code", CalculationUnit."Dimension 2 Filter")
        else
            if TempSystemCalcFilter."Global Dimension 2" <> '' then
                GLEntry.SetFilter("Global Dimension 2 Code", TempSystemCalcFilter."Global Dimension 2");
        if CalculationUnit."Dimension 3 Filter" <> '' then
            GLEntry.SetFilter("Shortcut Dimension 3 Code", CalculationUnit."Dimension 3 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 3" <> '' then
                GLEntry.SetFilter("Shortcut Dimension 3 Code", TempSystemCalcFilter."Shortcut Dimension 3");
        if CalculationUnit."Dimension 4 Filter" <> '' then
            GLEntry.SetFilter("Shortcut Dimension 4 Code", CalculationUnit."Dimension 4 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 4" <> '' then
                GLEntry.SetFilter("Shortcut Dimension 4 Code", TempSystemCalcFilter."Shortcut Dimension 4");
        if CalculationUnit."Dimension 5 Filter" <> '' then
            GLEntry.SetFilter("Shortcut Dimension 5 Code", CalculationUnit."Dimension 5 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 5" <> '' then
                GLEntry.SetFilter("Shortcut Dimension 5 Code", TempSystemCalcFilter."Shortcut Dimension 5");
        if CalculationUnit."Dimension 6 Filter" <> '' then
            GLEntry.SetFilter("Shortcut Dimension 6 Code", CalculationUnit."Dimension 6 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 6" <> '' then
                GLEntry.SetFilter("Shortcut Dimension 6 Code", TempSystemCalcFilter."Shortcut Dimension 6");
        if CalculationUnit."Dimension 7 Filter" <> '' then
            GLEntry.SetFilter("Shortcut Dimension 7 Code", CalculationUnit."Dimension 7 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 7" <> '' then
                GLEntry.SetFilter("Shortcut Dimension 7 Code", TempSystemCalcFilter."Shortcut Dimension 7");
        if CalculationUnit."Dimension 8 Filter" <> '' then
            GLEntry.SetFilter("Shortcut Dimension 8 Code", CalculationUnit."Dimension 8 Filter")
        else
            if TempSystemCalcFilter."Shortcut Dimension 8" <> '' then
                GLEntry.SetFilter("Shortcut Dimension 8 Code", TempSystemCalcFilter."Shortcut Dimension 8");
        if CalculationUnit."Business Unit Filter" <> '' then
            GLEntry.SetFilter("Business Unit Code", CalculationUnit."Business Unit Filter")
        else
            if TempSystemCalcFilter."Business Unit" <> '' then
                GLEntry.SetFilter("Business Unit Code", TempSystemCalcFilter."Business Unit");
        GLEntry.SetFilter("Posting Date", TempSystemCalcFilter.GetGLPostingDateFilter());
        case CalculationUnit."Amount Type" of
            CalculationUnit."Amount Type"::"Net Amount":
                begin
                    GLEntry.CalcSums(Amount);
                    Result := GLEntry.Amount;
                end;
            CalculationUnit."Amount Type"::"Debit Amount":
                begin
                    GLEntry.CalcSums("Debit Amount");
                    Result := GLEntry."Debit Amount";
                end;
            CalculationUnit."Amount Type"::"Credit Amount":
                begin
                    GLEntry.CalcSums("Credit Amount");
                    Result := GLEntry."Credit Amount";
                end;
        end;
        if (CalculationUnit.Type = CalculationUnit.Type::"Amount Lookup") and (CalculationUnit."Invert Sign") then
            Result := -Result;
    end;

    local procedure CalculateBandExpression(
        var RowLine: Record lvnPerformanceRowSchemaLine;
        var BaseCalculationUnit: Record lvnCalculationUnit;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter;
        var BandCache: Dictionary of [Code[20], Decimal];
        var CellCache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]];
        var IsVolatile: Boolean) Result: Decimal
    var
        CalculationUnit: Record lvnCalculationUnit;
        CalculationLine: Record lvnCalculationUnitLine;
        TempValueBuffer: Record lvnExpressionValueBuffer temporary;
        ExpressionHeader: Record lvnExpressionHeader;
        ExpressionEngine: Codeunit lvnExpressionEngine;
        String: Text;
    begin
        CalculationLine.Reset();
        CalculationLine.SetRange("Unit Code", BaseCalculationUnit.Code);
        if not CalculationLine.FindSet() then
            exit(0);
        repeat
            CalculationUnit.Get(CalculationLine."Source Unit Code");
            Clear(TempValueBuffer);
            TempValueBuffer.Name := CalculationLine."Source Unit Code";
            TempValueBuffer.Number := CalculationLine."Line no.";
            TempValueBuffer.Type := 'Decimal';
            TempValueBuffer.Value := Format(CalculateSingleValue(RowLine, CalculationUnit, TempSystemCalcFilter, BandCache, CellCache, Path, IsVolatile), 0, 9);
            TempValueBuffer.Insert();
        until CalculationLine.Next() = 0;
        ExpressionHeader.Get(BaseCalculationUnit."Expression Code", GetBandExpressionConsumerId());
        case ExpressionHeader.Type of
            ExpressionHeader.Type::Formula:
                Evaluate(Result, ExpressionEngine.CalculateFormula(ExpressionHeader, TempValueBuffer));
            ExpressionHeader.Type::Switch:
                if ExpressionEngine.SwitchCase(ExpressionHeader, String, TempValueBuffer) then
                    Evaluate(Result, String)
                else
                    Result := 0;
            ExpressionHeader.Type::Iif:
                Evaluate(Result, ExpressionEngine.Iif(ExpressionHeader, TempValueBuffer))
            else
                Error(UnsupportedExpressionTypeErr, ExpressionHeader.Type);
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure GetProviderValue(
        Metadata: Text;
        var TempSystemCalcFilter: Record lvnSystemCalculationFilter;
        var Result: Decimal)
    begin
    end;
}