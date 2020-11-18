report 14135155 "lvnUseTaxPayableReport"
{
    Caption = 'Use Tax Payable Report';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Modules\UseTax\Reports\Layouts\Rep14135155.rdl';

    dataset
    {
        dataitem(PostedPurchaseLines; "Purch. Inv. Line")
        {
            RequestFilterFields = "Pay-to Vendor No.", "Posting Date", lvnDeliveryState;

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem(StateLoop; lvnState)
        {
            DataItemTableView = sorting(Code);

            dataitem(OutputLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(DeliveryState; DeliveryState)
                {
                }
                column(VendorNo; VendorNo)
                {
                }
                column(VendorName; VendorName)
                {
                }
                column(DocumentNo; DocumentNo)
                {
                }
                column(ExtDocumentNo; ExtDocumentNo)
                {
                }
                column(PostingDate; PostingDate)
                {
                }
                column(LineAmount; LineAmount)
                {
                }
                column(GLAccount; GLAccount)
                {
                }
                column(TaxRate; TaxRate)
                {
                }
                column(TaxAmount; TaxAmount)
                {
                }
                column(TaxFrequency; TaxFrequency)
                {
                }
                column(CostCenter; CostCenter)
                {
                }
                column(DimName; DimName)
                {
                }
                trigger OnPreDataItem()
                var
                    CrLineCount: Integer;
                    InvLineCount: Integer;
                begin
                    PurchInvLine.SetCurrentKey(lvnDeliveryState);
                    PurchCrMemoLine.SetCurrentKey(lvnDeliveryState);
                    PurchInvLine.FilterGroup(5);
                    PurchInvLine.SetRange(lvnDeliveryState, StateLoop.Code);
                    PurchInvLine.SetFilter("No.", '<>%1', '');
                    PurchInvLine.SetRange(lvnUseSalesTax, true);
                    PurchInvLine.FilterGroup(0);
                    PurchCrMemoLine.FilterGroup(5);
                    PurchCrMemoLine.SetRange(lvnDeliveryState, StateLoop.Code);
                    PurchCrMemoLine.SetFilter("No.", '<>%1', '');
                    PurchCrMemoLine.SetRange(lvnUseSalesTax, true);
                    PurchCrMemoLine.FilterGroup(0);
                    PostedPurchaseLines.CopyFilter("Pay-to Vendor No.", PurchInvLine."Pay-to Vendor No.");
                    PostedPurchaseLines.CopyFilter("Posting Date", PurchInvLine."Posting Date");
                    PostedPurchaseLines.CopyFilter("Pay-to Vendor No.", PurchCrMemoLine."Pay-to Vendor No.");
                    PostedPurchaseLines.CopyFilter("Posting Date", PurchCrMemoLine."Posting Date");
                    InvLineCount := PurchInvLine.Count();
                    CrLineCount := PurchCrMemoLine.Count();
                    SetRange(Number, 1, InvLineCount + CrLineCount);
                    Found := false;
                    if PurchInvLine.FindSet() then
                        Found := true;
                    if PurchCrMemoLine.FindSet() then
                        Found := true;
                    if Found then
                        if PrintToExcel then begin
                            ExcelExport.NewRow(-10);
                            WriteToExcel(StateLbl + StateLoop.Code, false, 0, false, '', true, false);
                        end;
                end;

                trigger OnAfterGetRecord()
                var
                    TempDimSet: Record "Dimension Set Entry" temporary;
                    DimMgmt: Codeunit DimensionManagement;
                    InvLineCount: Integer;
                begin
                    if Number > 1 then
                        if Number <= InvLineCount then
                            PurchInvLine.Next()
                        else
                            if Number > (InvLineCount + 1) then
                                PurchCrMemoLine.Next();
                    if Number <= InvLineCount then begin
                        GetInvHeader();
                        DeliveryState := PurchInvLine.lvnDeliveryState;
                        VendorNo := PurchInvHeader."Pay-to Vendor No.";
                        VendorName := PurchInvHeader."Pay-to Name";
                        DocumentNo := PurchInvLine."Document No.";
                        PostingDate := PurchInvHeader."Posting Date";
                        ExtDocumentNo := PurchInvHeader."Vendor Order No.";
                        LineAmount := PurchInvLine."Line Amount";
                        GLAccount := PurchInvLine."No.";
                        DimMgmt.GetDimensionSet(TempDimSet, PurchInvLine."Dimension Set ID");
                        if TempDimSet.Get(PurchInvLine."Dimension Set ID", LoanVisionSetup."Cost Center Dimension Code") then
                            CostCenter := TempDimSet."Dimension Value Code";
                        GetTaxInfo(DeliveryState);
                    end else begin
                        GetCrHeader();
                        DeliveryState := PurchCrMemoLine.lvnDeliveryState;
                        VendorNo := PurchCrMemoHdr."Pay-to Vendor No.";
                        VendorName := PurchCrMemoHdr."Pay-to Name";
                        DocumentNo := PurchCrMemoLine."Document No.";
                        PostingDate := PurchCrMemoHdr."Posting Date";
                        ExtDocumentNo := PurchCrMemoHdr."Vendor Cr. Memo No.";
                        LineAmount := -PurchCrMemoLine."Line Amount";
                        GLAccount := PurchCrMemoLine."No.";
                        DimMgmt.GetDimensionSet(TempDimSet, PurchCrMemoLine."Dimension Set ID");
                        if TempDimSet.Get(PurchCrMemoLine."Dimension Set ID", LoanVisionSetup."Cost Center Dimension Code") then
                            CostCenter := TempDimSet."Dimension Value Code";
                        GetTaxInfo(DeliveryState);
                    end;
                    if PrintToExcel then begin
                        ExcelDataBody();
                        StateLineTtl += LineAmount;
                        StateTaxAmtTtl += TaxAmount;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if PrintToExcel and Found then begin
                        ExcelDataTotals(StateLineTtl, StateTaxAmtTtl, true);
                        ReportLineTtl += StateLineTtl;
                        ReportTaxTtl += StateTaxAmtTtl;
                        StateLineTtl := 0;
                        StateTaxAmtTtl := 0;
                    end;
                end;
            }
        }
        dataitem(ReportFilters; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(Filters; PostedPurchaseLines.GetFilters())
            {
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Excel)
                {
                    field(PrintToExcel; PrintToExcel) { Caption = 'Print To Excel'; ApplicationArea = All; }
                    field(NumberFormat; NumberFormat)
                    {
                        Caption = 'Currency Format';
                        ApplicationArea = All;
                        TableRelation = lvnNumberFormat;

                        trigger OnValidate()
                        begin
                            if PrintToExcel = false then
                                NumberFormat := '';
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        LoanVisionSetup.Get();
        if PrintToExcel then
            ExcelDataHeaders();
    end;

    trigger OnPostReport()
    begin
        if PrintToExcel then begin
            ExcelDataTotals(ReportLineTtl, ReportTaxTtl, false);
            ExcelExport.Download(FileNameLbl);
        end;
    end;

    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        ExcelExport: Codeunit lvnExcelExport;
        DeliveryState: Code[20];
        CostCenter: Code[20];
        DimName: Text;
        VendorNo: Code[20];
        VendorName: Text[50];
        DocumentNo: Code[20];
        PostingDate: Date;
        ExtDocumentNo: Code[35];
        LineAmount: Decimal;
        GLAccount: Code[20];
        TaxFrequency: Enum lvnTaxFrequency;
        TaxRate: Decimal;
        TaxAmount: Decimal;
        PrintToExcel: Boolean;
        Found: Boolean;
        StateLineTtl: Decimal;
        StateTaxAmtTtl: Decimal;
        ReportLineTtl: Decimal;
        ReportTaxTtl: Decimal;
        NumberFormat: Code[20];
        ExportCallLbl: Label 'UseTaxPayableExport';
        FileNameLbl: Label 'UseTaxPayableReport.xlsx';
        ColorTxt: Label '#E1E1E1';
        RepHeaderLbl: Label 'Use Tax Payable Report';
        VendNoLbl: Label 'Vendor No.';
        VendNameLbl: Label 'Vendor Name';
        DocNoLbl: Label 'Document No.';
        PostDateLbl: Label 'Posting Date';
        ExtDocNoLbl: Label 'Ext. Doc. No.';
        LineAmtLbl: Label 'Line Amount';
        GLAccLbl: Label 'G/L Account';
        TaxRateLbl: Label 'Tax Rate';
        TaxAmtLbl: Label 'Tax Amount';
        PayFreqLbl: Label 'Payment Frequency';
        TtlForLbl: Label 'Total For ';
        RepTtlLbl: Label 'Report Total For';
        StateLbl: Label 'State ';

    local procedure GetInvHeader()
    begin
        if PurchInvLine."Document No." <> PurchInvHeader."No." then
            PurchInvHeader.Get(PurchInvLine."Document No.");
    end;

    local procedure GetCrHeader()
    begin
        if PurchCrMemoLine."Document No." <> PurchCrMemoHdr."No." then
            PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.");
    end;

    local procedure GetTaxInfo(StateCode: Code[20])
    var
        State: Record lvnState;
    begin
        TaxRate := 0;
        TaxAmount := 0;
        TaxFrequency := TaxFrequency::" ";
        if State.Get(StateCode) then
            TaxRate := State."Tax Rate";
        TaxAmount := Round(LineAmount * TaxRate);
        TaxFrequency := State."Tax Payment Frequency";
    end;

    local procedure ExcelDataHeaders()
    var
        Dimension: Record Dimension;
        ExportFormat: Enum lvnGridExportMode;
    begin
        if Dimension.Get(LoanVisionSetup."Cost Center Dimension Code") then
            DimName := Dimension.Name;
        ExcelExport.Init(ExportCallLbl, ExportFormat::Xlsx);
        ExcelExport.NewRow(-10);
        WriteToExcel(RepHeaderLbl, true, 22, true, '', true, false);
        ExcelExport.NewRow(-10);
        WriteToExcel('', false, 0, false, ColorTxt, false, false);
        WriteToExcel(VendNoLbl, true, 0, true, ColorTxt, true, false);
        WriteToExcel(VendNameLbl, true, 1, true, ColorTxt, true, false);
        WriteToExcel(DocNoLbl, true, 0, true, ColorTxt, true, false);
        WriteToExcel(PostDateLbl, true, 0, true, ColorTxt, true, false);
        WriteToExcel(ExtDocNoLbl, true, 0, true, ColorTxt, true, false);
        WriteToExcel(LineAmtLbl, true, 0, true, ColorTxt, true, false);
        WriteToExcel(GLAccLbl, true, 0, true, ColorTxt, true, false);
        WriteToExcel(DimName, true, 0, true, ColorTxt, true, false);
        WriteToExcel(TaxRateLbl, true, 0, true, ColorTxt, true, false);
        WriteToExcel(TaxAmtLbl, true, 0, true, ColorTxt, true, false);
        WriteToExcel(PayFreqLbl, true, 0, true, ColorTxt, true, false);
    end;

    local procedure ExcelDataBody()
    begin
        ExcelExport.NewRow(-10);
        ExcelExport.SkipCells(1);
        WriteToExcel(VendorNo, true, 0, true, '', false, false);
        WriteToExcel(VendorName, true, 1, true, '', false, false);
        WriteToExcel(DocumentNo, true, 0, true, '', false, false);
        WriteToExcel(PostingDate, true, 0, true, '', false, false);
        WriteToExcel(ExtDocumentNo, true, 0, true, '', false, false);
        WriteToExcel(LineAmount, true, 0, false, '', false, true);
        WriteToExcel(GLAccount, true, 0, true, '', false, false);
        WriteToExcel(CostCenter, true, 0, true, '', false, false);
        WriteToExcel(Format(TaxRate * 100) + '%', true, 0, true, '', false, false);
        WriteToExcel(TaxAmount, true, 0, false, '', false, true);
        WriteToExcel(Format(TaxFrequency), true, 0, true, '', false, false);
    end;

    local procedure ExcelDataTotals(LineTotal: Decimal; TaxTotal: Decimal; StateLevel: Boolean)
    begin
        ExcelExport.NewRow(-10);
        ExcelExport.SkipCells(10);
        if StateLevel then begin
            WriteToExcel(TtlForLbl + DeliveryState, true, 0, false, '', true, false);
            WriteToExcel(LineTotal, true, 0, false, '', true, true);
            ExcelExport.SkipCells(6);
            WriteToExcel(TaxTotal, true, 0, false, '', true, true);
        end else begin
            WriteToExcel(RepTtlLbl, true, 0, false, ColorTxt, true, false);
            WriteToExcel(LineTotal, true, 0, false, ColorTxt, true, true);
            ExcelExport.SkipCells(6);
            WriteToExcel(TaxTotal, true, 0, false, ColorTxt, true, true);
        end;
    end;

    local procedure WriteToExcel(
        Output: Variant;
        CreateRange: Boolean;
        SkipCells: Integer;
        CenterText: Boolean;
        CellColor: Text;
        Bold: Boolean;
        Currency: Boolean)
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
}