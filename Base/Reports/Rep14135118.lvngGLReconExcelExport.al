report 14135188 lvngGLReconExcelExport
{
    Caption = 'G/L Reconciliation Excel Export';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(NumberFormat; NumberFormat) { ApplicationArea = All; Caption = 'Currency Format'; TableRelation = lvngNumberFormat.Code; }
                }
            }
        }
    }
    var
        FileNameLbl: Label 'GLReconExport.xlsx';
        DetailsColHdrTxt: Label 'Details';
        GLReconExportCaller: Label 'GLReconExport';
        HeaderTxt: Label 'G/L Reconciliation';
        ColorCodeLbl: Label '#D2D2D2';
        TempGenLedgRec: Record lvngGenLedgerReconcile temporary;
        ExportFormat: Enum lvngGridExportMode;
        ExcelExport: Codeunit lvngExcelExport;
        NumberFormat: Code[20];

    trigger OnPreReport()
    begin
        ExcelExport.Init(GLReconExportCaller, ExportFormat::Xlsx);
        ExcelExport.NewRow(0);
        WriteToExcel(HeaderTxt, true, 18, true, '', true, false);
        ExcelExport.NewRow(1);
        WriteToExcel(TempGenLedgRec.FieldCaption("Loan No."), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("G/L Account No."), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Date Funded"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Date Sold"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Investor Name"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Last Transaction Date"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption(Name), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Shortcut Dimension 1"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Shortcut Dimension 2"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Shortcut Dimension 3"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Shortcut Dimension 4"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Shortcut Dimension 5"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Shortcut Dimension 6"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Shortcut Dimension 7"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Shortcut Dimension 8"), false, 0, true, ColorCodeLbl, true, false);
        WriteToExcel(TempGenLedgRec.FieldCaption("Loan Card Value"), false, 0, true, ColorCodeLbl, true, true);
        WriteToExcel(TempGenLedgRec.FieldCaption("Debit Amount"), false, 0, true, ColorCodeLbl, true, true);
        WriteToExcel(TempGenLedgRec.FieldCaption("Credit Amount"), false, 0, true, ColorCodeLbl, true, true);
        WriteToExcel(TempGenLedgRec.FieldCaption("Current Balance"), false, 0, true, ColorCodeLbl, true, true);
        WriteToExcel(DetailsColHdrTxt, false, 0, true, ColorCodeLbl, true, false);
        TempGenLedgRec.Reset();
        if TempGenLedgRec.FindSet() then
            repeat
                ExcelExport.NewRow(2);
                WriteToExcel(TempGenLedgRec."Loan No.", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."G/L Account No.", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Date Funded", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Date Sold", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Investor Name", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Last Transaction Date", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec.Name, false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Shortcut Dimension 1", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Shortcut Dimension 2", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Shortcut Dimension 3", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Shortcut Dimension 4", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Shortcut Dimension 5", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Shortcut Dimension 6", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Shortcut Dimension 7", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Shortcut Dimension 8", false, 0, true, '', false, false);
                WriteToExcel(TempGenLedgRec."Loan Card Value", false, 0, true, '', false, true);
                WriteToExcel(TempGenLedgRec."Debit Amount", false, 0, true, '', false, true);
                WriteToExcel(TempGenLedgRec."Credit Amount", false, 0, true, '', false, true);
                WriteToExcel(TempGenLedgRec."Current Balance", false, 0, true, '', false, true);
            until TempGenLedgRec.Next() = 0;
    end;

    trigger OnPostReport()
    begin
        ExcelExport.Download(FileNameLbl);
    end;

    local procedure WriteToExcel(Output: Variant; CreateRange: Boolean; SkipCells: Integer; CenterText: Boolean; CellColor: Text; Bold: Boolean; Currency: Boolean)
    var
        DefaultBoolean: Enum lvngDefaultBoolean;
    begin
        if CreateRange then
            ExcelExport.BeginRange();
        if Bold then
            ExcelExport.StyleCell(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', CellColor)
        else
            ExcelExport.StyleCell(DefaultBoolean::No, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', CellColor);
        if Currency then
            ExcelExport.FormatCell(NumberFormat);
        if Output.IsCode() or Output.IsText() or Output.IsTextConstant() then
            ExcelExport.WriteString(Output);
        if Output.IsDecimal() or Output.IsInteger() then
            ExcelExport.WriteNumber(Output);
        if Output.IsDate() then
            ExcelExport.WriteDate(Output);
        if CreateRange then begin
            ExcelExport.SkipCells(SkipCells);
            ExcelExport.MergeRange(CenterText);
        end;
    end;

    procedure SetParam(var pBuffer: Record lvngGenLedgerReconcile)
    begin
        if pBuffer.FindSet() then
            repeat
                TempGenLedgRec := pBuffer;
                TempGenLedgRec.Insert();
            until pBuffer.Next() = 0;
    end;
}