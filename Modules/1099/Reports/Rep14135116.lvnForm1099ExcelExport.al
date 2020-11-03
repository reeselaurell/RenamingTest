report 14135116 "lvnForm1099ExcelExport"
{
    Caption = 'Form 1099 Excel Export';
    ProcessingOnly = true;

    dataset
    {
        dataitem(VendorLine; lvn1099VendorLine)
        {
            trigger OnPreDataItem()
            begin
                ExcelExport.NewRow(-1);
                WriteToExcel(ReportHeaderLbl, true, 23, true, '', true, false);
                ExcelExport.NewRow(0);
                ExcelExport.NewRow(0);
                WriteToExcel(FedIDColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(VendNoColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(VendNameColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(LegalNameColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(LegalAddrColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(LegalCityColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(LegalStateColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(LegalZIPColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(TtlPayColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(DefMISCColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC01ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC02ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC03ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC04ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC05ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC06ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC07ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC08ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC09ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC10ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC13ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC14ColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC15AColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC15BColLbl, false, 0, false, ColorTxt, true, false);
                WriteToExcel(MISC16ColLbl, false, 0, false, ColorTxt, true, false);
            end;

            trigger OnAfterGetRecord()
            begin
                if "Total Payments Amount" = 0 then
                    CurrReport.Skip();
                ExcelExport.NewRow(-10);
                WriteToExcel("Federal ID No.", false, 0, false, '', false, false);
                WriteToExcel("No.", false, 0, false, '', false, false);
                WriteToExcel(Name, false, 0, false, '', false, false);
                WriteToExcel("Legal Name", false, 0, false, '', false, false);
                WriteToExcel("Legal Address", false, 0, false, '', false, false);
                WriteToExcel("Legal Address City", false, 0, false, '', false, false);
                WriteToExcel("Legal Address State", false, 0, false, '', false, false);
                WriteToExcel("Legal Address ZIP Code", false, 0, false, '', false, false);
                WriteToExcel("Total Payments Amount", false, 0, false, '', false, true);
                WriteToExcel("Default MISC", false, 0, false, '', false, false);
                WriteToExcel("MISC-01", false, 0, false, '', false, true);
                WriteToExcel("MISC-02", false, 0, false, '', false, true);
                WriteToExcel("MISC-03", false, 0, false, '', false, true);
                WriteToExcel("MISC-04", false, 0, false, '', false, true);
                WriteToExcel("MISC-05", false, 0, false, '', false, true);
                WriteToExcel("MISC-06", false, 0, false, '', false, true);
                WriteToExcel("MISC-07", false, 0, false, '', false, true);
                WriteToExcel("MISC-08", false, 0, false, '', false, true);
                WriteToExcel("MISC-09", false, 0, false, '', false, true);
                WriteToExcel("MISC-10", false, 0, false, '', false, true);
                WriteToExcel("MISC-13", false, 0, false, '', false, true);
                WriteToExcel("MISC-14", false, 0, false, '', false, true);
                WriteToExcel("MISC-15-A", false, 0, false, '', false, true);
                WriteToExcel("MISC-15-B", false, 0, false, '', false, true);
                WriteToExcel("MISC-16", false, 0, false, '', false, true);
                //Totals
                TtlPaymentAmount += "Total Payments Amount";
                IncrementMISCTotals();
            end;

            trigger OnPostDataItem()
            begin
                ExcelExport.NewRow(-10);
                ExcelExport.SkipCells(7);
                WriteToExcel(TotalLbl, false, 0, false, '', true, false);
                WriteToExcel(TtlPaymentAmount, false, 0, false, '', true, true);
                ExcelExport.SkipCells(1);
                WriteToExcel(MISCTotals[1], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[2], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[3], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[4], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[5], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[6], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[7], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[8], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[9], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[10], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[11], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[12], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[13], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[14], false, 0, false, '', true, true);
                WriteToExcel(MISCTotals[15], false, 0, false, '', true, true);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(NumberFormat; NumberFormat) { Caption = 'Currency Format'; ApplicationArea = All; TableRelation = lvnNumberFormat; }
                }
            }
        }
    }

    var
        Form1099ExportCaller: Label 'Form1099Export';
        ReportHeaderLbl: Label 'Form 1099 Data';
        FedIDColLbl: Label 'Federal ID No.';
        VendNoColLbl: Label 'Vendor No.';
        VendNameColLbl: Label 'Vendor Name';
        LegalNameColLbl: Label 'Name';
        LegalAddrColLbl: Label 'Address';
        LegalCityColLbl: Label 'City';
        LegalStateColLbl: Label 'State';
        LegalZIPColLbl: Label 'ZIP Code';
        TtlPayColLbl: Label 'Total Payments Amount';
        DefMISCColLbl: Label 'Default MISC';
        MISC01ColLbl: Label 'MISC-01';
        MISC02ColLbl: Label 'MISC-02';
        MISC03ColLbl: Label 'MISC-03';
        MISC04ColLbl: Label 'MISC-04';
        MISC05ColLbl: Label 'MISC-05';
        MISC06ColLbl: Label 'MISC-06';
        MISC07ColLbl: Label 'MISC-07';
        MISC08ColLbl: Label 'MISC-08';
        MISC09ColLbl: Label 'MISC-09';
        MISC10ColLbl: Label 'MISC-10';
        MISC13ColLbl: Label 'MISC-13';
        MISC14ColLbl: Label 'MISC-14';
        MISC15AColLbl: Label 'MISC-15-A';
        MISC15BColLbl: Label 'MISC-15-B';
        MISC16ColLbl: Label 'MISC-16';
        TotalLbl: Label 'Total:';
        FileNameLbl: Label 'Form1099Export.xlsx';
        ColorTxt: Label '#E1E1E1';
        ExcelExport: Codeunit lvnExcelExport;
        ExportFormat: Enum lvnGridExportMode;
        NumberFormat: Code[20];
        TtlPaymentAmount: Decimal;
        MISCTotals: array[15] of Decimal;

    trigger OnPreReport()
    begin
        ExcelExport.Init(Form1099ExportCaller, ExportFormat::Xlsx);
    end;

    trigger OnPostReport()
    begin
        ExcelExport.Download(FileNameLbl);
    end;

    local procedure WriteToExcel(Output: Variant; CreateRange: Boolean; SkipCells: Integer; CenterText: Boolean; CellColor: Text; Bold: Boolean; Currency: Boolean)
    var
        DefaultBoolean: Enum lvnDefaultBoolean;
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

    local procedure IncrementMISCTotals()
    begin
        MISCTotals[1] += VendorLine."MISC-01";
        MISCTotals[2] += VendorLine."MISC-02";
        MISCTotals[3] += VendorLine."MISC-03";
        MISCTotals[4] += VendorLine."MISC-04";
        MISCTotals[5] += VendorLine."MISC-05";
        MISCTotals[6] += VendorLine."MISC-06";
        MISCTotals[7] += VendorLine."MISC-07";
        MISCTotals[8] += VendorLine."MISC-08";
        MISCTotals[9] += VendorLine."MISC-09";
        MISCTotals[10] += VendorLine."MISC-10";
        MISCTotals[11] += VendorLine."MISC-13";
        MISCTotals[12] += VendorLine."MISC-14";
        MISCTotals[13] += VendorLine."MISC-15-A";
        MISCTotals[14] += VendorLine."MISC-15-B";
        MISCTotals[15] += VendorLine."MISC-16";
    end;
}