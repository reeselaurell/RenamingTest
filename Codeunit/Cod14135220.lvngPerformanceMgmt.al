codeunit 14135220 lvngPerformanceMgmt
{
    SingleInstance = true;

    var
        BandExpressionConsumerId: Guid;
        PeriodRowExpressionConsumerId: Guid;
        DimensionRowExpressionConsumerId: Guid;
        CircularReferenceErr: Label 'Circular reference detected!';
        BandCountTxt: Label '$BANDCOUNT';
        ColCountTxt: Label '$COLCOUNT';
        FieldFormatTxt: Label 'b%1c%2';
        UnsupportedExpressionTypeErr: Label 'Unsupported expression type %1';

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
    end;

    procedure GetDimensionRowExpressionConsumerId(): Guid
    begin
        if IsNullGuid(DimensionRowExpressionConsumerId) then
            Evaluate(DimensionRowExpressionConsumerId, '44398a3f-5733-4e2d-afb8-4aaaa378fc1c');
    end;

    procedure CalculatePerformanceBand(var Buffer: Record lvngPerformanceValueBuffer; BandNo: Integer; var RowSchema: Record lvngPerformanceRowSchema; var ColSchema: Record lvngPerformanceColSchema; var SystemFilter: Record lvngSystemCalculationFilter)
    var
        Cache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]];
    begin
        CalculatePerformanceBand(Buffer, BandNo, RowSchema, ColSchema, SystemFilter, Cache, Path);
    end;

    local procedure CalculatePerformanceBand(var Buffer: Record lvngPerformanceValueBuffer; BandNo: Integer; var RowSchema: Record lvngPerformanceRowSchema; var ColSchema: Record lvngPerformanceColSchema; var SystemFilter: Record lvngSystemCalculationFilter; var Cache: Dictionary of [Code[20], Decimal]; var Path: List of [Code[20]])
    var
        RowLine: Record lvngPerformanceRowSchemaLine;
        ColLine: Record lvngPerformanceColSchemaLine;
        CalculationUnit: Record lvngCalculationUnit;
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
                Buffer."Column No." := ColLine."Column No.";
                Buffer."Row No." := RowLine."Line No.";
                Buffer."Band No." := BandNo;
                Buffer."Calculation Unit Code" := RowLine."Calculation Unit Code";
                if CalculationUnit.Get(RowLine."Calculation Unit Code") then begin
                    Buffer.Value := CalculateSingleBandValue(CalculationUnit, SystemFilter, Cache, Path);
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

    procedure CalculateFormulaBand(var Buffer: Record lvngPerformanceValueBuffer; BandNo: Integer; var RowSchema: Record lvngPerformanceRowSchema; var ColSchema: Record lvngPerformanceColSchema; var SystemFilter: Record lvngSystemCalculationFilter; RowFormulaCode: Code[20])
    var
        ColLine: Record lvngPerformanceColSchemaLine;
        CalculationUnit: Record lvngCalculationUnit;
        RowLine: Query lvngPerformanceRowLiteralLine;
        Cache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]];
        CalculationType: Enum lvngCalculationUnitType;
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
                CalculateSingleRowValue(RowLine.LineNo, ColLine."Column No.", RowLine.CalcUnitCode, RowFormulaCode, Buffer, Cache, Path);
            RowLine.Close();
        until ColLine.Next() = 0;
        CalculatePerformanceBand(Buffer, BandNo, RowSchema, ColSchema, SystemFilter, Cache, Path);
    end;

    procedure ApplyLoanFilter(var Loan: Record lvngLoan; var CalcUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter)
    begin
        Loan.FilterGroup(2);
        if CalcUnit."Dimension 1 Filter" <> '' then
            Loan.SetRange(lvngGlobalDimension1Code, CalcUnit."Dimension 1 Filter")
        else
            if SystemFilter."Shortcut Dimension 1" <> '' then
                Loan.SetRange(lvngGlobalDimension1Code, SystemFilter."Shortcut Dimension 1");
        if CalcUnit."Dimension 2 Filter" <> '' then
            Loan.SetRange(lvngGlobalDimension2Code, CalcUnit."Dimension 2 Filter")
        else
            if SystemFilter."Shortcut Dimension 2" <> '' then
                Loan.SetRange(lvngGlobalDimension2Code, SystemFilter."Shortcut Dimension 2");
        if CalcUnit."Dimension 3 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension3Code, CalcUnit."Dimension 3 Filter")
        else
            if SystemFilter."Shortcut Dimension 3" <> '' then
                Loan.SetRange(lvngShortcutDimension3Code, SystemFilter."Shortcut Dimension 3");
        if CalcUnit."Dimension 4 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension4Code, CalcUnit."Dimension 4 Filter")
        else
            if SystemFilter."Shortcut Dimension 4" <> '' then
                Loan.SetRange(lvngShortcutDimension4Code, SystemFilter."Shortcut Dimension 4");
        if CalcUnit."Dimension 5 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension5Code, CalcUnit."Dimension 5 Filter")
        else
            if SystemFilter."Shortcut Dimension 5" <> '' then
                Loan.SetRange(lvngShortcutDimension5Code, SystemFilter."Shortcut Dimension 5");
        if CalcUnit."Dimension 6 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension6Code, CalcUnit."Dimension 6 Filter")
        else
            if SystemFilter."Shortcut Dimension 6" <> '' then
                Loan.SetRange(lvngShortcutDimension6Code, SystemFilter."Shortcut Dimension 6");
        if CalcUnit."Dimension 7 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension7Code, CalcUnit."Dimension 7 Filter")
        else
            if SystemFilter."Shortcut Dimension 7" <> '' then
                Loan.SetRange(lvngShortcutDimension7Code, SystemFilter."Shortcut Dimension 7");
        if CalcUnit."Dimension 8 Filter" <> '' then
            Loan.SetRange(lvngShortcutDimension8Code, CalcUnit."Dimension 8 Filter")
        else
            if SystemFilter."Shortcut Dimension 8" <> '' then
                Loan.SetRange(lvngShortcutDimension8Code, SystemFilter."Shortcut Dimension 8");
        if CalcUnit."Business Unit Filter" <> '' then
            Loan.SetRange(lvngBusinessUnitCode, CalcUnit."Business Unit Filter")
        else
            if SystemFilter."Business Unit" <> '' then
                Loan.SetRange(lvngBusinessUnitCode, SystemFilter."Business Unit");
        case CalcUnit."Based On Date" of
            CalcUnit."Based On Date"::lvngApplication:
                Loan.SetFilter(lvngApplicationDate, SystemFilter."Date Filter");
            CalcUnit."Based On Date"::lvngClosed:
                Loan.SetFilter(lvngDateClosed, SystemFilter."Date Filter");
            CalcUnit."Based On Date"::lvngFunded:
                Loan.SetFilter(lvngDateFunded, SystemFilter."Date Filter");
            CalcUnit."Based On Date"::lvngLocked:
                Loan.SetFilter(lvngDateLocked, SystemFilter."Date Filter");
            CalcUnit."Based On Date"::lvngSold:
                Loan.SetFilter(lvngDateSold, SystemFilter."Date Filter");
        end;
        Loan.FilterGroup(0);
    end;

    procedure ApplyGLFilter(var GLEntry: Record "G/L Entry"; var CalcUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter)
    begin
        GLEntry.FilterGroup(2);
        GLEntry.SetFilter("G/L Account No.", CalcUnit."Account No. Filter");
        if CalcUnit."Dimension 1 Filter" <> '' then
            GLEntry.SetRange("Global Dimension 1 Code", CalcUnit."Dimension 1 Filter")
        else
            if SystemFilter."Shortcut Dimension 1" <> '' then
                GLEntry.SetRange("Global Dimension 1 Code", SystemFilter."Shortcut Dimension 1");
        if CalcUnit."Dimension 2 Filter" <> '' then
            GLEntry.SetRange("Global Dimension 2 Code", CalcUnit."Dimension 2 Filter")
        else
            if SystemFilter."Shortcut Dimension 2" <> '' then
                GLEntry.SetRange("Global Dimension 2 Code", SystemFilter."Shortcut Dimension 2");
        if CalcUnit."Dimension 3 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension3Code, CalcUnit."Dimension 3 Filter")
        else
            if SystemFilter."Shortcut Dimension 3" <> '' then
                GLEntry.SetRange(lvngShortcutDimension3Code, SystemFilter."Shortcut Dimension 3");
        if CalcUnit."Dimension 4 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension4Code, CalcUnit."Dimension 4 Filter")
        else
            if SystemFilter."Shortcut Dimension 4" <> '' then
                GLEntry.SetRange(lvngShortcutDimension4Code, SystemFilter."Shortcut Dimension 4");
        if CalcUnit."Dimension 5 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension5Code, CalcUnit."Dimension 5 Filter")
        else
            if SystemFilter."Shortcut Dimension 5" <> '' then
                GLEntry.SetRange(lvngShortcutDimension5Code, SystemFilter."Shortcut Dimension 5");
        if CalcUnit."Dimension 6 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension6Code, CalcUnit."Dimension 6 Filter")
        else
            if SystemFilter."Shortcut Dimension 6" <> '' then
                GLEntry.SetRange(lvngShortcutDimension6Code, SystemFilter."Shortcut Dimension 6");
        if CalcUnit."Dimension 7 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension7Code, CalcUnit."Dimension 7 Filter")
        else
            if SystemFilter."Shortcut Dimension 7" <> '' then
                GLEntry.SetRange(lvngShortcutDimension7Code, SystemFilter."Shortcut Dimension 7");
        if CalcUnit."Dimension 8 Filter" <> '' then
            GLEntry.SetRange(lvngShortcutDimension8Code, CalcUnit."Dimension 8 Filter")
        else
            if SystemFilter."Shortcut Dimension 8" <> '' then
                GLEntry.SetRange(lvngShortcutDimension8Code, SystemFilter."Shortcut Dimension 8");
        if CalcUnit."Business Unit Filter" <> '' then
            GLEntry.SetRange("Business Unit Code", CalcUnit."Business Unit Filter")
        else
            if SystemFilter."Business Unit" <> '' then
                GLEntry.SetRange("Business Unit Code", SystemFilter."Business Unit");
        GLEntry.SetFilter("Posting Date", SystemFilter."Date Filter");
        GLEntry.FilterGroup(0);
    end;

    procedure GetData(var Buffer: Record lvngPerformanceValueBuffer; var StylesInUse: Dictionary of [Code[20], Boolean]; RowSchemaCode: Code[20]; ColSchemaCode: Code[20]) DataSource: JsonArray
    var
        RowLine: Record lvngPerformanceRowSchemaLine;
        ColLine: Record lvngPerformanceColSchemaLine;
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
                RowLine."Row Type"::lvngNormal:
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
                RowLine."Row Type"::lvngHeader:
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
                RowLine."Row Type"::lvngEmpty:
                    begin
                        Clear(RowData);
                        RowData.Add('rowId', RowLine."Line No.");
                        DataSource.Add(RowData);
                    end;
            end;
        until RowLine.Next() = 0;
    end;

    local procedure FormatValue(var Buffer: Record lvngPerformanceValueBuffer) TextValue: Text
    var
        NumberFormat: Record lvngNumberFormat;
        NumericValue: Decimal;
    begin
        if not NumberFormat.Get(Buffer."Number Format Code") then
            Clear(NumberFormat);
        NumericValue := Buffer.Value;
        if NumericValue = 0 then
            case NumberFormat."Blank Zero" of
                NumberFormat."Blank Zero"::lvngZero:
                    exit('0');
                NumberFormat."Blank Zero"::lvngDash:
                    exit('-');
                NumberFormat."Blank Zero"::lvngBlank:
                    exit('&nbsp;');
            end;
        if NumberFormat."Invert Sign" then
            NumericValue := -NumericValue;
        if (NumericValue < 0) and (NumberFormat."Negative Formatting" = NumberFormat."Negative Formatting"::lvngSuppressSign) then
            NumericValue := Abs(NumericValue);
        case NumberFormat.Rounding of
            NumberFormat.Rounding::lvngNone:
                NumericValue := Round(NumericValue, 0.01);
            NumberFormat.Rounding::lvngOne:
                NumericValue := Round(NumericValue, 0.1);
            NumberFormat.Rounding::lvngRound:
                NumericValue := Round(NumericValue, 1);
            NumberFormat.Rounding::lvngThousands:
                NumericValue := Round(NumericValue, 1000);
        end;
        if NumberFormat."Suppress Thousand Separator" then
            TextValue := Format(NumericValue, 0, 9)
        else
            TextValue := Format(NumericValue);
        case NumberFormat."Value Type" of
            NumberFormat."Value Type"::Currency:
                TextValue := '$' + TextValue;
            NumberFormat."Value Type"::Percentage:
                TextValue := TextValue + '%';
        end;
        if NumberFormat."Negative Formatting" = NumberFormat."Negative Formatting"::lvngParenthesis then
            if NumericValue < 0 then
                TextValue := '(' + TextValue + ')'
            else
                TextValue := '&nbsp;' + TextValue + '&nbsp;';
    end;

    procedure GetGridStyles(StylesInUse: List of [Code[20]]) Json: JsonObject
    var
        CssClass: JsonObject;
        StyleCode: Code[20];
        Style: Record lvngStyle;
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
                    Style.Bold::lvngTrue:
                        CssClass.Add('font-weight', 'bold');
                    Style.Bold::lvngFalse:
                        CssClass.Add('font-weight', 'normal');
                end;
                case Style.Italic of
                    Style.Italic::lvngTrue:
                        CssClass.Add('font-style', 'italic');
                    Style.Italic::lvngFalse:
                        CssClass.Add('font-style', 'normal');
                end;
                case Style.Underline of
                    Style.Underline::lvngTrue:
                        CssClass.Add('text-decoration', 'underline');
                    Style.Underline::lvngFalse:
                        CssClass.Add('text-decoration', 'none');
                end;
                if Style."Font Size" > 0 then
                    CssClass.Add('font-size', StrSubstNo('%1px', Style."Font Size"));
                if Style."Font Color" <> '' then
                    CssClass.Add('color', Style."Font Color");
                if Style."Background Color" <> '' then
                    CssClass.Add('background-color', Style."Background Color");
                Json.Add('.pw-' + LowerCase(StyleCode), CssClass);
            end;
    end;

    local procedure IsClickableCell(var CalculationUnit: Record lvngCalculationUnit): Boolean
    begin
        if (CalculationUnit.Type = CalculationUnit.Type::lvngAmountLookup) or (CalculationUnit.Type = CalculationUnit.Type::lvngCountLookup) then begin
            if CalculationUnit."Lookup Source" = CalculationUnit."Lookup Source"::lvngLoanCard then
                exit(true);
            if CalculationUnit."Lookup Source" = CalculationUnit."Lookup Source"::lvngLedgerEntries then
                exit(CalculationUnit."Account No. Filter" <> '');
        end;
        exit(false);
    end;

    local procedure CalculateSingleRowValue(RowNo: Integer; ColNo: Integer; CalculationUnitCode: Code[20]; RowFormulaCode: Code[20]; var Buffer: Record lvngPerformanceValueBuffer; Cache: Dictionary of [Code[20], Decimal]; Path: List of [Code[20]]) Result: Decimal
    var
        ValueBuffer: Record lvngExpressionValueBuffer temporary;
        ExpressionHeader: Record lvngExpressionHeader;
        ExpressionEngine: Codeunit lvngExpressionEngine;
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
            Number += 1;
            Clear(ValueBuffer);
            ValueBuffer.Number := Buffer."Band No.";
            ValueBuffer.Name := 'BAND' + Format(Buffer."Band No.");
            ValueBuffer.Type := 'Decimal';
            ValueBuffer.Value := Format(Buffer.Value);
            ValueBuffer.Insert();
        until Buffer.Next() = 0;
        //Insert band count
        Buffer.Reset();
        Buffer.SetRange("Row No.", RowNo);
        Buffer.SetRange("Column No.", 1);
        Clear(ValueBuffer);
        ValueBuffer.Number := Number + 1;
        ValueBuffer.Name := BandCountTxt;
        ValueBuffer.Type := 'Decimal';
        ValueBuffer.Value := Format(Buffer.Count());
        ValueBuffer.Insert();
        Buffer.FindFirst();
        BandNo := Buffer."Band No.";
        //Insert column count
        Buffer.Reset();
        Buffer.SetRange("Row No.", RowNo);
        Buffer.SetRange("Band No.", BandNo);
        Clear(ValueBuffer);
        ValueBuffer.Number := Number + 2;
        ValueBuffer.Name := ColCountTxt;
        ValueBuffer.Type := 'Decimal';
        ValueBuffer.Value := Format(Buffer.Count());
        ValueBuffer.Insert();
        ExpressionHeader.Get(RowFormulaCode);
        Evaluate(Result, ExpressionEngine.CalculateFormula(ExpressionHeader, ValueBuffer));
        Cache.Add(CalculationUnitCode, Result);
    end;

    local procedure CalculateSingleBandValue(var CalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter; var Cache: Dictionary of [Code[20], Decimal]; Path: List of [Code[20]]) Result: Decimal
    begin
        if Cache.Get(CalculationUnit.Code, Result) then
            exit;
        if Path.IndexOf(CalculationUnit.Code) <> 0 then
            Error(CircularReferenceErr);
        case CalculationUnit.Type of
            CalculationUnit.Type::lvngConstant:
                Result := CalculationUnit."Constant Value";
            CalculationUnit.Type::lvngAmountLookup, CalculationUnit.Type::lvngCountLookup:
                begin
                    if CalculationUnit."Lookup Source" = CalculationUnit."Lookup Source"::lvngLoanCard then
                        Result := LookupLoanCard(CalculationUnit, SystemFilter)
                    else
                        Result := LookupGeneralLedger(CalculationUnit, SystemFilter);
                end;
            CalculationUnit.Type::lvngExpression:
                begin
                    Path.Add(CalculationUnit.Code);
                    Result := CalculateBandExpression(CalculationUnit, SystemFilter, Cache, Path);
                    Path.RemoveAt(Path.Count());
                end;
            CalculationUnit.Type::lvngProviderValue:
                begin
                    GetProviderValue(CalculationUnit."Provider Metadata", SystemFilter, Result);
                end;
        end;
        Cache.Add(CalculationUnit.Code, Result);
    end;

    local procedure LookupLoanCard(var CalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter) Result: Decimal
    var
        LoanAmountsByDimension: Query lvngLoanAmountsByDimension;
    begin
        if CalculationUnit."Dimension 1 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension1Filter, CalculationUnit."Dimension 1 Filter")
        else
            if SystemFilter."Shortcut Dimension 1" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
        if CalculationUnit."Dimension 2 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension2Filter, CalculationUnit."Dimension 2 Filter")
        else
            if SystemFilter."Shortcut Dimension 2" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
        if CalculationUnit."Dimension 3 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension3Filter, CalculationUnit."Dimension 3 Filter")
        else
            if SystemFilter."Shortcut Dimension 3" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
        if CalculationUnit."Dimension 4 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension4Filter, CalculationUnit."Dimension 4 Filter")
        else
            if SystemFilter."Shortcut Dimension 4" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
        if CalculationUnit."Dimension 5 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension5Filter, CalculationUnit."Dimension 5 Filter")
        else
            if SystemFilter."Shortcut Dimension 5" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
        if CalculationUnit."Dimension 6 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension6Filter, CalculationUnit."Dimension 6 Filter")
        else
            if SystemFilter."Shortcut Dimension 6" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
        if CalculationUnit."Dimension 7 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension7Filter, CalculationUnit."Dimension 7 Filter")
        else
            if SystemFilter."Shortcut Dimension 7" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
        if CalculationUnit."Dimension 8 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension8Filter, CalculationUnit."Dimension 8 Filter")
        else
            if SystemFilter."Shortcut Dimension 8" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
        if CalculationUnit."Business Unit Filter" <> '' then
            LoanAmountsByDimension.SetFilter(BusinessUnitFilter, CalculationUnit."Business Unit Filter")
        else
            if SystemFilter."Business Unit" <> '' then
                LoanAmountsByDimension.SetFilter(BusinessUnitFilter, SystemFilter."Business Unit");
        case CalculationUnit."Based On Date" of
            CalculationUnit."Based On Date"::lvngApplication:
                LoanAmountsByDimension.SetFilter(DateApplicationFilter, SystemFilter."Date Filter");
            CalculationUnit."Based On Date"::lvngClosed:
                LoanAmountsByDimension.SetFilter(DateClosedFilter, SystemFilter."Date Filter");
            CalculationUnit."Based On Date"::lvngFunded:
                LoanAmountsByDimension.SetFilter(DateFundedFilter, SystemFilter."Date Filter");
            CalculationUnit."Based On Date"::lvngLocked:
                LoanAmountsByDimension.SetFilter(DateLockedFilter, SystemFilter."Date Filter");
            CalculationUnit."Based On Date"::lvngSold:
                LoanAmountsByDimension.SetFilter(DateSoldFilter, SystemFilter."Date Filter");
        end;
        LoanAmountsByDimension.Open();
        LoanAmountsByDimension.Read();
        if CalculationUnit.Type = CalculationUnit.Type::lvngAmountLookup then
            Result := LoanAmountsByDimension.LoanAmount
        else
            Result := LoanAmountsByDimension.LoanCount;
        LoanAmountsByDimension.Close();
    end;

    local procedure LookupGeneralLedger(var CalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter) Result: Decimal
    var
        GLEntry: Record lvngGroupedGLEntry;
    begin
        GLEntry.Reset();
        GLEntry.SetFilter(lvngGLAccountNo, CalculationUnit."Account No. Filter");
        if CalculationUnit."Dimension 1 Filter" <> '' then
            GLEntry.SetFilter(lvngGlobalDimension1Code, CalculationUnit."Dimension 1 Filter")
        else
            if SystemFilter."Shortcut Dimension 1" <> '' then
                GLEntry.SetFilter(lvngGlobalDimension1Code, SystemFilter."Shortcut Dimension 1");
        if CalculationUnit."Dimension 2 Filter" <> '' then
            GLEntry.SetFilter(lvngGlobalDimension2Code, CalculationUnit."Dimension 2 Filter")
        else
            if SystemFilter."Shortcut Dimension 2" <> '' then
                GLEntry.SetFilter(lvngGlobalDimension2Code, SystemFilter."Shortcut Dimension 2");
        if CalculationUnit."Dimension 3 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension3Code, CalculationUnit."Dimension 3 Filter")
        else
            if SystemFilter."Shortcut Dimension 3" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension3Code, SystemFilter."Shortcut Dimension 3");
        if CalculationUnit."Dimension 4 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension4Code, CalculationUnit."Dimension 4 Filter")
        else
            if SystemFilter."Shortcut Dimension 4" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension4Code, SystemFilter."Shortcut Dimension 4");
        if CalculationUnit."Dimension 5 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension5Code, CalculationUnit."Dimension 5 Filter")
        else
            if SystemFilter."Shortcut Dimension 5" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension5Code, SystemFilter."Shortcut Dimension 5");
        if CalculationUnit."Dimension 6 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension6Code, CalculationUnit."Dimension 6 Filter")
        else
            if SystemFilter."Shortcut Dimension 6" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension6Code, SystemFilter."Shortcut Dimension 6");
        if CalculationUnit."Dimension 7 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension7Code, CalculationUnit."Dimension 7 Filter")
        else
            if SystemFilter."Shortcut Dimension 7" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension7Code, SystemFilter."Shortcut Dimension 7");
        if CalculationUnit."Dimension 8 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension8Code, CalculationUnit."Dimension 8 Filter")
        else
            if SystemFilter."Shortcut Dimension 8" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension8Code, SystemFilter."Shortcut Dimension 8");
        if CalculationUnit."Business Unit Filter" <> '' then
            GLEntry.SetFilter(lvngBusinessUnitCode, CalculationUnit."Business Unit Filter")
        else
            if SystemFilter."Business Unit" <> '' then
                GLEntry.SetFilter(lvngBusinessUnitCode, SystemFilter."Business Unit");
        GLEntry.SetFilter(lvngPostingDate, SystemFilter."Date Filter");
        case CalculationUnit."Amount Type" of
            CalculationUnit."Amount Type"::lvngNetAmount:
                begin
                    GLEntry.CalcSums(lvngAmount);
                    Result := GLEntry.lvngAmount;
                end;
            CalculationUnit."Amount Type"::lvngDebitAmount:
                begin
                    GLEntry.CalcSums(lvngDebitAmount);
                    Result := GLEntry.lvngDebitAmount;
                end;
            CalculationUnit."Amount Type"::lvngCreditAmount:
                begin
                    GLEntry.CalcSums(lvngCreditAmount);
                    Result := GLEntry.lvngCreditAmount;
                end;
        end;
    end;

    local procedure CalculateBandExpression(var BaseCalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter; var Cache: Dictionary of [Code[20], Decimal]; Path: List of [Code[20]]) Result: Decimal
    var
        CalculationUnit: Record lvngCalculationUnit;
        CalculationLine: Record lvngCalculationUnitLine;
        ValueBuffer: Record lvngExpressionValueBuffer temporary;
        ExpressionHeader: Record lvngExpressionHeader;
        ExpressionEngine: Codeunit lvngExpressionEngine;
        String: Text;
    begin
        CalculationLine.Reset();
        CalculationLine.SetRange("Unit Code", BaseCalculationUnit.Code);
        if not CalculationLine.FindSet() then
            exit(0);
        repeat
            CalculationUnit.Get(CalculationLine."Source Unit Code");
            Clear(ValueBuffer);
            ValueBuffer.Name := CalculationLine."Source Unit Code";
            ValueBuffer.Number := CalculationLine."Line no.";
            ValueBuffer.Type := 'Decimal';
            ValueBuffer.Value := Format(CalculateSingleBandValue(CalculationUnit, SystemFilter, Cache, Path), 0, 9);
            ValueBuffer.Insert();
        until CalculationLine.Next() = 0;
        ExpressionHeader.Get(BaseCalculationUnit."Expression Code", GetBandExpressionConsumerId());
        case ExpressionHeader.Type of
            ExpressionHeader.Type::Formula:
                Evaluate(Result, ExpressionEngine.CalculateFormula(ExpressionHeader, ValueBuffer));
            ExpressionHeader.Type::Switch:
                begin
                    if ExpressionEngine.SwitchCase(ExpressionHeader, String, ValueBuffer) then
                        Evaluate(Result, String)
                    else
                        Result := 0;
                end
            else
                Error(UnsupportedExpressionTypeErr);
        end;
    end;


    [IntegrationEvent(false, false)]
    procedure GetProviderValue(Metadata: Text; var SystemFilter: Record lvngSystemCalculationFilter; var Result: Decimal)
    begin
    end;

    [EventSubscriber(ObjectType::Page, Page::lvngExpressionList, 'FillBuffer', '', false, false)]
    local procedure OnFillBuffer(ExpressionHeader: Record lvngExpressionHeader; ConsumerMetadata: Text; var ExpressionBuffer: Record lvngExpressionValueBuffer)
    var
        CalcUnitLine: Record lvngCalculationUnitLine;
        DimPerfBandSchemaLine: Record lvngDimPerfBandSchemaLine;
        PeriodPerfBandSchemaLine: Record lvngPeriodPerfBandSchemaLine;
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
                    PeriodPerfBandSchemaLine.SetFilter("Band Type", '<>%1', PeriodPerfBandSchemaLine."Band Type"::lvngFormula);
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
                    DimPerfBandSchemaLine.SetFilter("Band Type", '<>%1', DimPerfBandSchemaLine."Band Type"::lvngFormula);
                    if DimPerfBandSchemaLine.FindSet() then
                        repeat
                            Clear(ExpressionBuffer);
                            ExpressionBuffer.Name := 'BAND' + Format(DimPerfBandSchemaLine."Band No.");
                            ExpressionBuffer.Number := DimPerfBandSchemaLine."Band no.";
                            ExpressionBuffer.Type := 'Decimal';
                            ExpressionBuffer.Insert();
                        until PeriodPerfBandSchemaLine.Next() = 0;
                end;
        end;
    end;
}