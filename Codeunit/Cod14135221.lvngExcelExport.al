codeunit 14135221 lvngExcelExport
{
    /*
        Script instructions:
        ar  - Align Row
        br  - Begin Range
        mr  - Merge Range
        nr  - New Row
        sc  - Style Column
        sk  - Skip Cells
        sr  - Style Row
        wd  - Write Decimal
        wf  - Write Formula
        ws  - Write String
    */
    var
        IsInitialized: Boolean;
        ExcelData: JsonObject;
        Script: JsonArray;
        Instruction: JsonObject;
        Params: JsonObject;
        NotInitializedErr: Label 'Excel Export is not initialized';
        CharactersTxt: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    procedure Init(Caller: Text; Mode: Enum lvngGridExportMode)
    begin
        Clear(ExcelData);
        ExcelData.Add('format', 'ExcelForwardWriter');
        ExcelData.Add('version', '1.0');
        ExcelData.Add('client', Caller);
        ExcelData.Add('target', Mode);
        ExcelData.Add('generated', CurrentDateTime());
        Clear(Script);
        ExcelData.Add('script', Script);
    end;

    procedure AlignRow(Horizontal: Enum lvngCellHorizontalAlignment; Vertical: Enum lvngCellVerticalAlignment; Indent: Integer; Rotation: Integer; ShrinkToFit: Enum lvngDefaultBoolean; WrapText: Enum lvngDefaultBoolean)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'ar');
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

    procedure StyleColumn(Bold: Enum lvngDefaultBoolean; Italic: Enum lvngDefaultBoolean; Underline: Enum lvngDefaultBoolean; FontSize: Decimal; FontName: Text; ForeColor: Text; BackColor: Text)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'sc');
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

    procedure StyleRow(Bold: Enum lvngDefaultBoolean; Italic: Enum lvngDefaultBoolean; Underline: Enum lvngDefaultBoolean; FontSize: Decimal; FontName: Text; ForeColor: Text; BackColor: Text)
    var
        Instruction: JsonObject;
        Params: JsonObject;
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'sr');
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

    procedure StyleRow(StyleCode: Code[20])
    var
        Style: Record lvngStyle;
    begin
        if Style.Get(StyleCode) then
            StyleRow(Style.Bold, Style.Italic, Style.Underline, Style."Font Size", Style."Font Name", Style."Font Color", Style."Background Color");
    end;

    procedure NewRow(RowId: Integer)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'nr');
        Instruction.Add('p', Params);
        Params.Add('i', RowId);
        Script.Add(Instruction);
    end;

    procedure SkipCells(Count: Integer)
    begin
        Clear(Instruction);
        Clear(Params);
        Instruction.Add('n', 'sk');
        Instruction.Add('p', Params);
        Params.Add('c', Count);
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
        Params.Add('c', Center);
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
        Params.Add('f', Formula);
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
}