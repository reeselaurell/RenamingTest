codeunit 14135221 lvngExcelExport
{
    /*
        Script instructions:
        af - Auto Fit
        ar - Align Row
        ac - Align Column
        ax - Align Cell
        br - Begin Range
        fx - Format Cell
        mr - Merge Range
        nr - New Row
        sc - Style Column
        sk - Skip Cell
        sn - Style Cell only when value is negative
        sr - Style Row
        sx - Style Cell
        wd - Write Decimal
        wf - Write Formula
        ws - Write String
    */
    var
        ExcelExportSetup: Record lvngExcelExportSetup;
        IsInitialized: Boolean;
        ExportMode: Enum lvngGridExportMode;
        ExcelData: JsonObject;
        Script: JsonArray;
        Instruction: JsonObject;
        Params: JsonObject;
        NotInitializedErr: Label 'Excel Export is not initialized';
        CharactersTxt: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        ExcelFileTxt: Label 'Excel Files (*.xlsx)|*.xlsx';
        PdfFileTxt: Label 'PDF Files (*.psf)|*.pdf';
        HtmlFileTxt: Label 'HTML Files (*.html)|*.html';
        AllFileTxt: Label 'All Files (*.*)|*.*';

    procedure Init(Caller: Text; Mode: Enum lvngGridExportMode)
    begin
        ExcelExportSetup.Get();
        ExportMode := Mode;
        Clear(ExcelData);
        ExcelData.Add('format', 'ExcelForwardWriter');
        ExcelData.Add('version', '1.0');
        ExcelData.Add('client', Caller);
        ExcelData.Add('target', Format(Mode));
        ExcelData.Add('generated', CurrentDateTime());
        Clear(Script);
        ExcelData.Add('script', Script);
    end;

    procedure Download(FileName: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        IStream: InStream;
        Client: HttpClient;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseMsg: HttpResponseMessage;
        Input: Text;
        ErrorMsg: Text;
    begin
        ExcelData.WriteTo(Input);
        RequestContent.WriteFrom(Input);
        RequestContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        Client.Post(ExcelExportSetup."Base Url" + '?code=' + ExcelExportSetup."Access Key", RequestContent, ResponseMsg);
        if ResponseMsg.HttpStatusCode <> 200 then begin
            ResponseMsg.Content().ReadAs(ErrorMsg);
            Error(ErrorMsg);
        end;
        TempBlob.CreateInStream(IStream);
        ResponseMsg.Content().ReadAs(IStream);
        DownloadFromStream(IStream, '', '', GetDownloadFileFilter(), FileName);
    end;

    local procedure GetDownloadFileFilter() Result: Text
    begin
        case ExportMode of
            ExportMode::lvngXlsx:
                Result := ExcelFileTxt;
            ExportMode::lvngPdf:
                Result := PdfFileTxt;
            ExportMode::lvngHtml:
                Result := HtmlFileTxt;
        end;
        if Result <> '' then
            Result += '|';
        Result += AllFileTxt;
    end;

    local procedure SetAlignment(TargetFunction: Text; Horizontal: Enum lvngCellHorizontalAlignment; Vertical: Enum lvngCellVerticalAlignment; Indent: Integer; Rotation: Integer; ShrinkToFit: Enum lvngDefaultBoolean; WrapText: Enum lvngDefaultBoolean)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', TargetFunction);
        Instruction.Add('p', Params);
        Script.Add(Instruction);
        if Horizontal <> Horizontal::lvngDefault then
            Params.Add('h', Horizontal - 1);
        if Vertical <> Vertical::lvngDefault then
            Params.Add('v', Vertical - 1);
        if Indent > 0 then
            Params.Add('i', Indent);
        if Rotation > 0 then
            Params.Add('r', Rotation);
        if ShrinkToFit <> ShrinkToFit::lvngDefault then
            Params.Add('s', ShrinkToFit = ShrinkToFit::lvngTrue);
        if WrapText <> WrapText::lvngDefault then
            Params.Add('w', WrapText = WrapText::lvngTrue);
    end;

    procedure AlignRow(Horizontal: Enum lvngCellHorizontalAlignment; Vertical: Enum lvngCellVerticalAlignment; Indent: Integer; Rotation: Integer; ShrinkToFit: Enum lvngDefaultBoolean; WrapText: Enum lvngDefaultBoolean)
    begin
        SetAlignment('ar', Horizontal, Vertical, Indent, Rotation, ShrinkToFit, WrapText);
    end;

    procedure AlignColumn(Horizontal: Enum lvngCellHorizontalAlignment; Vertical: Enum lvngCellVerticalAlignment; Indent: Integer; Rotation: Integer; ShrinkToFit: Enum lvngDefaultBoolean; WrapText: Enum lvngDefaultBoolean)
    begin
        SetAlignment('ac', Horizontal, Vertical, Indent, Rotation, ShrinkToFit, WrapText);
    end;

    procedure AlignCell(Horizontal: Enum lvngCellHorizontalAlignment; Vertical: Enum lvngCellVerticalAlignment; Indent: Integer; Rotation: Integer; ShrinkToFit: Enum lvngDefaultBoolean; WrapText: Enum lvngDefaultBoolean)
    begin
        SetAlignment('ax', Horizontal, Vertical, Indent, Rotation, ShrinkToFit, WrapText);
    end;

    local procedure SetStyle(TargetFunction: Text; Bold: Enum lvngDefaultBoolean; Italic: Enum lvngDefaultBoolean; Underline: Enum lvngDefaultBoolean; FontSize: Decimal; FontName: Text; ForeColor: Text; BackColor: Text)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', TargetFunction);
        Instruction.Add('p', Params);
        if Bold <> Bold::lvngDefault then
            Params.Add('b', Bold = Bold::lvngTrue);
        if Italic <> Italic::lvngDefault then
            Params.Add('i', Italic = Italic::lvngTrue);
        if Underline <> Underline::lvngDefault then
            Params.Add('u', Underline = Underline::lvngTrue);
        if FontSize > 0 then
            Params.Add('fs', FontSize);
        if FontName <> '' then
            Params.Add('fn', FontName);
        if BackColor <> '' then
            Params.Add('bc', BackColor);
        if ForeColor <> '' then
            Params.Add('fc', ForeColor);
        Script.Add(Instruction);
    end;

    procedure StyleColumn(Bold: Enum lvngDefaultBoolean; Italic: Enum lvngDefaultBoolean; Underline: Enum lvngDefaultBoolean; FontSize: Decimal; FontName: Text; ForeColor: Text; BackColor: Text)
    begin
        SetStyle('sc', Bold, Italic, Underline, FontSize, FontName, ForeColor, BackColor);
    end;

    procedure StyleColumn(StyleCode: Code[20])
    var
        Style: Record lvngStyle;
    begin
        if Style.Get(StyleCode) then
            SetStyle('sc', Style.Bold, Style.Italic, Style.Underline, Style."Font Size", Style."Font Name", Style."Font Color", Style."Background Color");
    end;

    procedure StyleRow(Bold: Enum lvngDefaultBoolean; Italic: Enum lvngDefaultBoolean; Underline: Enum lvngDefaultBoolean; FontSize: Decimal; FontName: Text; ForeColor: Text; BackColor: Text)
    var
        Instruction: JsonObject;
        Params: JsonObject;
    begin
        SetStyle('sr', Bold, Italic, Underline, FontSize, FontName, ForeColor, BackColor);
    end;

    procedure StyleRow(StyleCode: Code[20])
    var
        Style: Record lvngStyle;
    begin
        if Style.Get(StyleCode) then
            SetStyle('sr', Style.Bold, Style.Italic, Style.Underline, Style."Font Size", Style."Font Name", Style."Font Color", Style."Background Color");
    end;

    procedure StyleCell(Bold: Enum lvngDefaultBoolean; Italic: Enum lvngDefaultBoolean; Underline: Enum lvngDefaultBoolean; FontSize: Decimal; FontName: Text; ForeColor: Text; BackColor: Text)
    var
        Instruction: JsonObject;
        Params: JsonObject;
    begin
        SetStyle('sx', Bold, Italic, Underline, FontSize, FontName, ForeColor, BackColor);
    end;

    procedure StyleCell(StyleCode: Code[20])
    var
        Style: Record lvngStyle;
    begin
        if Style.Get(StyleCode) then
            SetStyle('sx', Style.Bold, Style.Italic, Style.Underline, Style."Font Size", Style."Font Name", Style."Font Color", Style."Background Color");
    end;

    procedure StyleNegative(StyleCode: Code[20])
    var
        Style: Record lvngStyle;
    begin
        if Style.Get(StyleCode) then
            SetStyle('sn', Style.Bold, Style.Italic, Style.Underline, Style."Font Size", Style."Font Name", Style."Font Color", Style."Background Color");
    end;

    local procedure GetExcelFormatString(var NumberFormat: Record lvngNumberFormat): Text
    var
        Positive: Text;
        Negative: Text;
        Zero: Text;
    begin
        case NumberFormat.Rounding of
            NumberFormat.Rounding::lvngTwo:
                Positive := '.00';
            NumberFormat.Rounding::lvngOne:
                Positive := '.0';
            NumberFormat.Rounding::lvngNone:
                Positive := '.########';
            NumberFormat.Rounding::lvngThousands:
                Positive := ',';
        end;
        if NumberFormat."Suppress Thousand Separator" then
            Positive := '#0' + Positive
        else
            Positive := '#,0' + Positive;
        case NumberFormat."Value Type" of
            NumberFormat."Value Type"::Currency:
                Positive := '\$' + Positive;
            NumberFormat."Value Type"::Percentage:
                Positive := Positive + '\%';
        end;
        if not NumberFormat."Invert Sign" and (NumberFormat."Negative Formatting" = NumberFormat."Negative Formatting"::lvngNone) and (NumberFormat."Blank Zero" = NumberFormat."Blank Zero"::lvngDefault) then
            exit(Positive);
        case NumberFormat."Negative Formatting" of
            NumberFormat."Negative Formatting"::lvngSuppressSign:
                Negative := Positive;
            NumberFormat."Negative Formatting"::lvngParenthesis:
                Negative := '(' + Positive + ')'
            else
                Negative := '-' + Positive;
        end;
        if NumberFormat."Invert Sign" then begin
            Zero := Positive;
            Positive := Negative;
            Negative := Zero;
        end;
        case NumberFormat."Blank Zero" of
            NumberFormat."Blank Zero"::lvngBlank:
                exit(Positive + ';' + Negative + ';');
            NumberFormat."Blank Zero"::lvngDefault:
                exit(Positive + ';' + Negative + ';-');
            NumberFormat."Blank Zero"::lvngZero:
                exit(Positive + ';' + Negative + ';0')
            else
                exit(Positive + ';' + Negative);
        end;
    end;

    procedure FormatCell(FormatCode: Code[20])
    var
        NumberFormat: Record lvngNumberFormat;
    begin
        if NumberFormat.Get(FormatCode) then begin
            Clear(Instruction);
            Clear(Params);
            Instruction.Add('n', 'fx');
            Instruction.Add('p', Params);
            Params.Add('v', GetExcelFormatString(NumberFormat));
            Script.Add(Instruction);
        end;
    end;

    procedure NewRow(RowId: Integer)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'nr');
        Instruction.Add('p', Params);
        Params.Add('v', RowId);
        Script.Add(Instruction);
    end;

    procedure SkipCells(Count: Integer)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'sk');
        Instruction.Add('p', Params);
        Params.Add('v', Count);
        Script.Add(Instruction);
    end;

    procedure BeginRange()
    begin
        Clear(Instruction);
        Instruction.Add('n', 'br');
        Script.Add(Instruction);
    end;

    procedure MergeRange(Center: Boolean)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'mr');
        Instruction.Add('p', Params);
        Params.Add('v', Center);
        Script.Add(Instruction);
    end;

    procedure AutoFit(Rows: Boolean; Columns: Boolean)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'af');
        Instruction.Add('p', Params);
        Params.Add('r', Rows);
        Params.Add('c', Columns);
        Script.Add(Instruction);
    end;

    procedure WriteString(Value: Text)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'ws');
        Instruction.Add('p', Params);
        Params.Add('v', Value);
        Script.Add(Instruction);
    end;

    procedure WriteDecimal(Value: Decimal)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'wd');
        Instruction.Add('p', Params);
        Params.Add('v', Value);
        Script.Add(Instruction);
    end;

    procedure WriteFormula(Formula: Text)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'wf');
        Instruction.Add('p', Params);
        Params.Add('v', Formula);
        Script.Add(Instruction);
    end;

    procedure GetExcelColumnName(ColIdx: Integer) Result: Text
    var
        Divisor: Integer;
    begin
        Divisor := StrLen(CharactersTxt);
        Result := CopyStr(CharactersTxt, ColIdx mod Divisor + 1, 1);
        if ColIdx >= Divisor then
            Result := GetExcelColumnName(ColIdx div Divisor - 1) + Result;
    end;

    procedure FormatComparison(LeftHand: Text; Comparison: Enum lvngComparison; RightHand: Text): Text
    var
        Split: List of [Text];
        RangeStart: Text;
        RangeEnd: Text;
    begin
        case (Comparison) of
            Comparison::Equal:
                exit(LeftHand + '=' + RightHand);
            Comparison::Greater:
                exit(LeftHand + '>' + RightHand);
            Comparison::GreaterOrEqual:
                exit(LeftHand + '>=' + RightHand);
            Comparison::Less:
                exit(LeftHand + '<' + RightHand);
            Comparison::LessOrEqual:
                exit(LeftHand + '<=' + RightHand);
            Comparison::NotEqual:
                exit(LeftHand + '<>' + RightHand);
            Comparison::Within,
            Comparison::Contains:
                begin
                    if RightHand.IndexOf('..') <> 0 then begin
                        Split := DelChr(RightHand, '<>', '()').Split('..');
                        exit(StrSubstNo('(%1>=%2)AND(%1<=%2)', LeftHand, Split.Get(1), Split.Get(2)));
                    end else
                        exit(StrSubstNo('ISNUMBER(MATCH(%1,{%2},0))', LeftHand, DelChr(RightHand, '<>', '()').Replace('|', ',')));
                end;
        end;
    end;


}