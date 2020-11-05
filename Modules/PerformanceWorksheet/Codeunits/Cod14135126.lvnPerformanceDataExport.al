codeunit 14135126 "lvnPerformanceDataExport"
{
    var
        PerformanceMgmt: Codeunit lvnPerformanceMgmt;
        ExpressionEngine: Codeunit lvnExpressionEngine;
        DefaultBoolean: Enum lvnDefaultBoolean;
        CellHorizontalAlignment: Enum lvnCellHorizontalAlignment;
        CellVerticalAlignment: Enum lvnCellVerticalAlignment;
        PeriodPerfExportFileNameTxt: Label 'Period Performance';
        DimensionPerfExportFileNameTxt: Label 'Dimension Performance';
        BusinessUnitFilterTxt: Label 'Business Unit Filter';
        NameTxt: Label 'Name';
        UnsupportedFormulaTypeErr: Label 'Formula type is not supported';
        IntranslatableRowFormulaErr: Label 'Row formula cannot be translated';

    procedure ExportToExcel(
        var ExcelExport: Codeunit lvnExcelExport;
        var RowSchema: Record lvnPerformanceRowSchema;
        var Buffer: Record lvnPerformanceValueBuffer;
        var HeaderData: Record lvnSystemCalculationFilter;
        var BandInfo: Record lvnPerformanceBandLineInfo)
    var
        ColLine: Record lvnPerformanceColSchemaLine;
        RowLine: Record lvnPerformanceRowSchemaLine;
        TempRowLine: Record lvnPerformanceRowSchemaLine temporary;
        CalcUnit: Record lvnCalculationUnit;
        ExpressionHeader: Record lvnExpressionHeader;
        RowIndexLookup: Dictionary of [Integer, Integer];
        BandIndexLookup: Dictionary of [Integer, Integer];
        RowId: Integer;
        ColumnCount: Integer;
        Idx: Integer;
        IncludeRow: Boolean;
        DataColStartIdx: Integer;
        DataRowStartIdx: Integer;
        BandIdx: Integer;
        OutputFileName: Text;
    begin
        //Skip empty lines and calculate excel row indexes (zero based)
        Clear(RowIndexLookup);
        RowLine.Reset();
        RowLine.SetRange("Schema Code", RowSchema.Code);
        RowLine.SetRange("Column No.", 1);
        RowLine.FindSet();
        Idx := 0;
        repeat
            IncludeRow := true;
            if RowLine."Hide Zero Line" then begin
                Buffer.Reset();
                Buffer.SetRange("Row No.", RowLine."Line No.");
                Buffer.SetFilter(Value, '<>0');
                if Buffer.IsEmpty then
                    IncludeRow := false;
            end;
            if IncludeRow then begin
                Clear(TempRowLine);
                TempRowLine := RowLine;
                TempRowLine."Data Row Index" := Idx;
                RowIndexLookup.Add(TempRowLine."Line No.", Idx);
                Idx += 1;
                TempRowLine.Insert();
            end;
        until RowLine.Next() = 0;
        //Add header
        ExcelExport.NewRow(-10);
        ExcelExport.StyleColumn(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, -1, '', '', '');
        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 14, '', '', '');
        ExcelExport.BeginRange();
        ExcelExport.WriteString(HeaderData.Description);
        ExcelExport.SkipCells(6);
        ExcelExport.MergeRange(false);
        ExcelExport.NewRow(-20);
        RowId := -30;
        if HeaderData."Global Dimension 1" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('3,1,1'));
            ExcelExport.WriteString(HeaderData."Global Dimension 1");
        end;
        if HeaderData."Global Dimension 2" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('3,1,2'));
            ExcelExport.WriteString(HeaderData."Global Dimension 2");
        end;
        if HeaderData."Shortcut Dimension 3" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('4,1,3'));
            ExcelExport.WriteString(HeaderData."Shortcut Dimension 3");
        end;
        if HeaderData."Shortcut Dimension 4" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('4,1,4'));
            ExcelExport.WriteString(HeaderData."Shortcut Dimension 4");
        end;
        if HeaderData."Business Unit" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(BusinessUnitFilterTxt);
            ExcelExport.WriteString(HeaderData."Business Unit");
        end;
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        //Add Grid Band Header
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Yes, DefaultBoolean::Yes, -1, '', '', '');
        ExcelExport.AlignRow(CellHorizontalAlignment::Center, CellVerticalAlignment::Default, -1, 0, DefaultBoolean::Default, DefaultBoolean::Default);
        ExcelExport.SkipCells(1);
        ColLine.Reset();
        ColLine.SetRange("Schema Code", RowSchema."Column Schema");
        ColumnCount := ColLine.Count();
        BandInfo.Reset();
        BandInfo.FindSet();
        //BandInfo also contains band index, however when we're writing data rows it will loop through band info, so need additional band index lookup
        repeat
            BandIndexLookup.Add(BandInfo."Band No.", BandInfo."Band Index");
            if ColumnCount > 1 then
                ExcelExport.BeginRange();
            ExcelExport.WriteString(BandInfo."Header Description");
            if ColumnCount > 2 then
                ExcelExport.SkipCells(ColumnCount - 2);
            if ColumnCount > 1 then
                ExcelExport.MergeRange(true);
        until BandInfo.Next() = 0;
        //Add Grid Primary Header
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Yes, DefaultBoolean::Yes, -1, '', '', '');
        ExcelExport.AlignRow(CellHorizontalAlignment::Center, CellVerticalAlignment::Default, -1, 0, DefaultBoolean::Default, DefaultBoolean::Default);
        ExcelExport.WriteString(NameTxt);
        DataColStartIdx := 1; //Skip Name column
        DataRowStartIdx := -RowId div 10 - 1; //Skip header columns, - 1 for zero-based
        for Idx := 1 to BandInfo.Count do begin
            ColLine.Reset();
            ColLine.SetRange("Schema Code", RowSchema."Column Schema");
            ColLine.FindSet();
            repeat
                ExcelExport.WriteString(ColLine."Primary Caption");
            until ColLine.Next() = 0;
        end;
        //Add rows
        TempRowLine.Reset();
        TempRowLine.FindSet();
        repeat
            case TempRowLine."Row Type" of
                TempRowLine."Row Type"::Normal:
                    begin
                        ExcelExport.NewRow(RowLine."Line No.");
                        if TempRowLine."Row Style" <> '' then
                            ExcelExport.StyleRow(TempRowLine."Row Style");
                        ExcelExport.WriteString(TempRowLine.Description);
                        BandInfo.Reset();
                        BandInfo.FindSet();
                        BandIdx := 0;
                        repeat
                            RowLine.Reset();
                            RowLine.SetRange("Schema Code", TempRowLine."Schema Code");
                            RowLine.SetRange("Line No.", TempRowLine."Line No.");
                            RowLine.FindSet();
                            repeat
                                if RowLine."Style Code" <> '' then
                                    ExcelExport.StyleCell(RowLine."Style Code");
                                if RowLine."Neg. Style Code" <> '' then
                                    ExcelExport.StyleNegative(RowLine."Neg. Style Code");
                                if RowLine."Number Format Code" <> '' then
                                    ExcelExport.FormatCell(RowLine."Number Format Code");
                                if not CalcUnit.Get(RowLine."Calculation Unit Code") then
                                    ExcelExport.WriteNumber(0)
                                else
                                    if (CalcUnit.Type <> CalcUnit.Type::Expression) and (BandInfo."Band Type" = BandInfo."Band Type"::Formula) then begin
                                        //Apply row formula
                                        ExpressionHeader.Get(BandInfo."Row Formula Code", PerformanceMgmt.GetPeriodRowExpressionConsumerId());
                                        ExcelExport.WriteFormula('=' + TranslateRowFormula(ExpressionEngine.GetFormulaFromLines(ExpressionHeader), TempRowLine."Data Row Index", RowLine."Column No." - 1, DataRowStartIdx, DataColStartIdx, ColumnCount, BandIndexLookup));
                                    end else begin
                                        if CalcUnit.Type = CalcUnit.Type::Expression then begin
                                            //Apply column formula
                                            ExpressionHeader.Get(CalcUnit."Expression Code", PerformanceMgmt.GetBandExpressionConsumerId());
                                            case ExpressionHeader.Type of
                                                ExpressionHeader.Type::Formula:
                                                    ExcelExport.WriteFormula('=' + TranslateColFormula(ExpressionEngine.GetFormulaFromLines(ExpressionHeader), DataRowStartIdx, DataColStartIdx, BandIdx, ColumnCount, Buffer, RowIndexLookup));
                                                ExpressionHeader.Type::Switch:
                                                    ExcelExport.WriteFormula('=IFS(' + TranslateColSwitch(TranslateColFormula(ExpressionEngine.GetFormulaFromLines(ExpressionHeader), DataRowStartIdx, DataColStartIdx, BandIdx, ColumnCount, Buffer, RowIndexLookup), ExpressionHeader, DataRowStartIdx, DataColStartIdx, BandIdx, ColumnCount, Buffer, RowIndexLookup) + ')');
                                                ExpressionHeader.Type::Iif:
                                                    ExcelExport.WriteFormula(StrSubstNo('=IF(%1,%2,%3)',
                                                        TranslateColPredicate(ExpressionHeader, DataRowStartIdx, DataColStartIdx, BandIdx, ColumnCount, Buffer, RowIndexLookup),
                                                        TranslateColFormula(GetFormulaFromIif(ExpressionHeader, true), DataRowStartIdx, DataColStartIdx, BandIdx, ColumnCount, Buffer, RowIndexLookup),
                                                        TranslateColFormula(GetFormulaFromIif(ExpressionHeader, false), DataRowStartIdx, DataColStartIdx, BandIdx, ColumnCount, Buffer, RowIndexLookup)))
                                                else
                                                    Error(UnsupportedFormulaTypeErr);
                                            end
                                        end else begin
                                            if Buffer.Get(TempRowLine."Line No.", BandInfo."Band No.", RowLine."Column No.") then
                                                ExcelExport.WriteNumber(Buffer.Value)
                                            else
                                                ExcelExport.WriteNumber(0);
                                        end;
                                    end;
                            until RowLine.Next() = 0;
                            BandIdx += 1;
                        until BandInfo.Next() = 0;
                    end;
                RowLine."Row Type"::Header:
                    begin
                        ExcelExport.NewRow(RowLine."Line No.");
                        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Yes, DefaultBoolean::Yes, -1, '', '', '');
                        ExcelExport.AlignRow(CellHorizontalAlignment::Center, CellVerticalAlignment::Default, -1, 0, DefaultBoolean::No, DefaultBoolean::No);
                        ExcelExport.SkipCells(1);
                        for Idx := 1 to BandInfo.Count do begin
                            ColLine.Reset();
                            ColLine.SetRange("Schema Code", RowSchema."Column Schema");
                            ColLine.FindSet();
                            repeat
                                ExcelExport.WriteString(ColLine."Secondary Caption");
                            until ColLine.Next() = 0;
                        end;
                    end;
                RowLine."Row Type"::Empty:
                    begin
                        ExcelExport.NewRow(RowLine."Line No.");
                    end;
            end;
        until TempRowLine.Next() = 0;
        ExcelExport.AutoFit(false, true);
    end;

    procedure GetExportFileName(Mode: Enum lvnGridExportMode; SchemaType: Enum lvnPerformanceRowSchemaType) OutputFileName: Text
    begin
        case SchemaType of
            SchemaType::"Dimension Dynamic",
            SchemaType::"Dimension Predefined":
                OutputFileName := DimensionPerfExportFileNameTxt
            else
                OutputFileName := PeriodPerfExportFileNameTxt;
        end;
        case Mode of
            Mode::Pdf:
                OutputFileName += '.pdf';
            Mode::Html:
                OutputFileName += '.html'
            else
                OutputFileName += '.xlsx';
        end;
    end;

    local procedure TranslateRowFormula(
        Formula: Text;
        RowIdx: Integer;
        ColIdx: Integer;
        DataRowOffset: Integer;
        DataColOffset: Integer;
        BandSize: Integer;
        var BandIndexLookup: Dictionary of [Integer, Integer]): Text
    var
        FieldStart: Integer;
        FieldEnd: Integer;
    begin
        //[BAND1]+[BAND2]+[BAND3]+...
        //=>
        //=B7+E7+J7+...
        Formula := LowerCase(Formula);
        FieldStart := StrPos(Formula, '[');
        while FieldStart <> 0 do begin
            FieldEnd := StrPos(Formula, ']');
            if FieldEnd = 0 then
                Error(IntranslatableRowFormulaErr);
            Formula := CopyStr(Formula, 1, FieldStart - 1) + TranslateRowFormulaField(CopyStr(Formula, FieldStart + 1, FieldEnd - FieldStart - 1), RowIdx, ColIdx, DataRowOffset, DataColOffset, BandSize, BandIndexLookup) + CopyStr(Formula, FieldEnd + 1);
            FieldStart := StrPos(Formula, '[');
        end;
        exit(Formula);
    end;

    local procedure TranslateColFormula(
        Formula: Text;
        DataRowOffset: Integer;
        DataColOffset: Integer;
        BandIdx: Integer;
        BandSize: Integer;
        var Buffer: Record lvnPerformanceValueBuffer;
        var RowIndexLookup: Dictionary of [Integer, Integer]): Text
    var
        FieldStart: Integer;
        FieldEnd: Integer;
    begin
        FieldStart := StrPos(Formula, '[');
        while FieldStart <> 0 do begin
            FieldEnd := StrPos(Formula, ']');
            if FieldEnd = 0 then
                Error(IntranslatableRowFormulaErr);
            Formula := CopyStr(Formula, 1, FieldStart - 1) + TranslateColFormulaField(CopyStr(Formula, FieldStart + 1, FieldEnd - FieldStart - 1), DataRowOffset, DataColOffset, BandIdx, BandSize, Buffer, RowIndexLookup) + CopyStr(Formula, FieldEnd + 1);
            FieldStart := StrPos(Formula, '[');
        end;
        exit(Formula);
    end;

    local procedure TranslateColSwitch(
        SwitchOn: Text;
        var ExpressionHeader: Record lvnExpressionHeader;
        DataRowOffset: Integer;
        DataColOffset: Integer;
        BandIdx: Integer;
        BandSize: Integer;
        var Buffer: Record lvnPerformanceValueBuffer;
        var RowIndexLookup: Dictionary of [Integer, Integer]) Result: Text;
    var
        CaseLine: Record lvnExpressionLine;
        ExcelExport: Codeunit lvnExcelExport;
        PrevNo: Integer;
        Predicate: Text;
        Returns: Text;
    begin
        CaseLine.Reset();
        CaseLine.SetRange("Expression Code", ExpressionHeader.Code);
        CaseLine.SetRange("Consumer Id", ExpressionHeader."Consumer Id");
        CaseLine.SetFilter("Line No.", '<>%1', 0);
        PrevNo := 0;
        if CaseLine.FindSet() then begin
            repeat
                if PrevNo <> CaseLine."Line No." then begin
                    if Predicate <> '' then begin
                        if Predicate.IndexOf('(') = 1 then
                            Result += ExcelExport.FormatComparison(SwitchOn, CaseLine.Comparison::Within, Predicate)
                        else
                            Result += ExcelExport.FormatComparison(SwitchOn, CaseLine.Comparison::Equal, Predicate);
                        Result += ',' + TranslateColFormula(Returns, DataRowOffset, DataColOffset, BandIdx, BandSize, Buffer, RowIndexLookup) + ',';
                    end;
                    PrevNo := CaseLine."Line No.";
                    Predicate := CaseLine."Left Side";
                    Returns := CaseLine."Right Side";
                end else begin
                    Predicate := Predicate + CaseLine."Left Side";
                    Returns := Returns + CaseLine."Right Side";
                end;
            until CaseLine.Next() = 0;
            if Predicate <> '' then begin
                if Predicate.IndexOf('(') = 1 then
                    Result += ExcelExport.FormatComparison(SwitchOn, CaseLine.Comparison::Within, Predicate)
                else
                    Result += ExcelExport.FormatComparison(SwitchOn, CaseLine.Comparison::Equal, Predicate);
                Result += ',' + TranslateColFormula(Returns, DataRowOffset, DataColOffset, BandIdx, BandSize, Buffer, RowIndexLookup) + ',';
            end;
        end;
        Result := DelChr(Result, '>', ',');
    end;

    local procedure TranslateColPredicate(
        var ExpressionHeader: Record lvnExpressionHeader;
        DataRowOffset: Integer;
        DataColOffset: Integer;
        BandIdx: Integer;
        BandSize: Integer;
        var Buffer: Record lvnPerformanceValueBuffer;
        var RowIndexLookup: Dictionary of [Integer, Integer]): Text
    var
        ExpressionLine: Record lvnExpressionLine;
        ExcelExport: Codeunit lvnExcelExport;
        LeftHand: Text;
        RightHand: Text;
        Comparison: Enum lvnComparison;
    begin
        ExpressionLine.Reset();
        ExpressionLine.SetRange("Expression Code", ExpressionHeader.Code);
        ExpressionLine.SetRange("Consumer Id", ExpressionHeader."Consumer Id");
        ExpressionLine.SetRange("Line No.", 0);
        ExpressionLine.FindSet();
        repeat
            LeftHand += ExpressionLine."Left Side";
            Comparison := ExpressionLine.Comparison;
            RightHand += ExpressionLine."Right Side";
        until ExpressionLine.Next() = 0;
        exit(ExcelExport.FormatComparison(TranslateColFormula(LeftHand, DataRowOffset, DataColOffset, BandIdx, BandSize, Buffer, RowIndexLookup), Comparison, TranslateColFormula(RightHand, DataRowOffset, DataColOffset, BandIdx, BandSize, Buffer, RowIndexLookup)));
    end;

    local procedure GetFormulaFromIif(var ExpressionHeader: Record lvnExpressionHeader; Predicate: Boolean) Result: Text
    var
        ExpressionLine: Record lvnExpressionLine;
    begin
        ExpressionLine.Reset();
        ExpressionLine.SetRange("Expression Code", ExpressionHeader.Code);
        ExpressionLine.SetRange("Consumer Id", ExpressionHeader."Consumer Id");
        if Predicate then
            ExpressionLine.SetRange("Line No.", 1)
        else
            ExpressionLine.SetRange("Line No.", 2);
        ExpressionLine.FindSet();
        repeat
            Result += ExpressionLine."Right Side";
        until ExpressionLine.Next() = 0;
    end;

    local procedure TranslateColFormulaField(
        Field: Text;
        DataRowOffset: Integer;
        DataColOffset: Integer;
        BandIdx: Integer;
        BandSize: Integer;
        var Buffer: Record lvnPerformanceValueBuffer;
        var RowIndexLookup: Dictionary of [Integer, Integer]): Text
    var
        ExcelExport: Codeunit lvnExcelExport;
        RowIdx: Integer;
    begin
        Buffer.Reset();
        Buffer.SetCurrentKey("Calculation Unit Code");
        Buffer.SetRange("Calculation Unit Code", Field);
        if not Buffer.FindFirst() then
            Error(IntranslatableRowFormulaErr);
        if not RowIndexLookup.Get(Buffer."Row No.", RowIdx) then
            Error(IntranslatableRowFormulaErr);
        exit(ExcelExport.GetExcelColumnName(DataColOffset + BandIdx * BandSize + Buffer."Column No." - 1) + Format(RowIdx + DataRowOffset + 1));
    end;

    local procedure TranslateRowFormulaField(
        Field: Text;
        RowIdx: Integer;
        ColIdx: Integer;
        DataRowOffset: Integer;
        DataColOffset: Integer;
        BandSize: Integer;
        var BandIndexLookup: Dictionary of [Integer, Integer]): Text
    var
        ExcelExport: Codeunit lvnExcelExport;
        FieldIdx: Integer;
    begin
        if StrPos(Field, 'band') <> 1 then
            Error(IntranslatableRowFormulaErr);
        if not Evaluate(FieldIdx, DelStr(Field, 1, 4)) then
            Error(IntranslatableRowFormulaErr);
        if not BandIndexLookup.Get(FieldIdx, FieldIdx) then
            Error(IntranslatableRowFormulaErr);
        exit(ExcelExport.GetExcelColumnName(DataColOffset + FieldIdx * BandSize + ColIdx) + Format(RowIdx + DataRowOffset + 1));
    end;
}