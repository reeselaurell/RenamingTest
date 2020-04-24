page 14135246 lvngLoanValuesView
{
    PageType = Card;
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    Caption = 'Loan Values View';

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                field(SchemaName; LoanLevelReportSchema.Description) { ApplicationArea = All; Caption = 'View Name'; ShowCaption = false; Editable = false; }
                field(Dim1Filter; SystemFilter."Global Dimension 1") { ApplicationArea = All; Caption = 'Dimension 1 Filter'; Editable = false; Visible = Dim1Visible; CaptionClass = '1,3,1'; }
                field(Dim2Filter; SystemFilter."Global Dimension 2") { ApplicationArea = All; Caption = 'Dimension 2 Filter'; Editable = false; Visible = Dim2Visible; CaptionClass = '1,3,2'; }
                field(Dim3Filter; SystemFilter."Shortcut Dimension 3") { ApplicationArea = All; Caption = 'Dimension 3 Filter'; Editable = false; Visible = Dim3Visible; CaptionClass = '1,2,3'; }
                field(Dim4Filter; SystemFilter."Shortcut Dimension 4") { ApplicationArea = All; Caption = 'Dimension 4 Filter'; Editable = false; Visible = Dim4Visible; CaptionClass = '1,2,4'; }
                field(BusinessUnitFilter; SystemFilter."Business Unit") { ApplicationArea = All; Caption = 'Business Unit Filter'; Editable = false; Visible = BusinessUnitVisible; }
                field(BasedOn; BasedOn)
                {
                    ApplicationArea = All;
                    Caption = 'Base Date';

                    trigger OnValidate()
                    begin
                        CalculateData();
                        InitializeDataGrid();
                    end;
                }
                field(DateFilter; SystemFilter."Date Filter") { ApplicationArea = All; Editable = false; Caption = 'Date Filter'; }
            }
            usercontrol(DataGrid; DataGridControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    InitializeDataGrid();
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExcelExport)
            {
                ApplicationArea = All;
                Caption = 'Excel Export';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::Xlsx);
                end;
            }
            action(PdfExport)
            {
                ApplicationArea = All;
                Caption = 'Pdf Export';
                Image = ExportFile;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::Pdf);
                end;
            }
            action(HtmlExport)
            {
                ApplicationArea = All;
                Caption = 'Html Export';
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::Html);
                end;
            }
        }
    }

    var
        LoanNoLbl: Label 'Loan No.';
        DateFundedLbl: Label 'Date Funded';
        DateSoldLbl: Label 'Date Sold';
        PostingDateLbl: Label 'Posting Date';
        LONameLbl: Label 'LO Name';
        YesTxt: Label 'Yes';
        NoTxt: Label 'No';
        TotalsTxt: Label 'Totals';
        NotAvailableTxt: Label 'N/A';
        LoanLevelExportFileNameTxt: Label 'Loan Level Report';
        BusinessUnitFilterTxt: Label 'Business Unit Filter';
        BaseDateText: Label 'Base Date';
        DateFilterTxt: Label 'Date Filter';
        IntranslatableRowFormulaErr: Label 'Row formula cannot be translated';
        LoanVisionSetup: Record lvngLoanVisionSetup;
        LoanLevelReportSchema: Record lvngLoanLevelReportSchema;
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        RowBuffer: Record "Name/Value Buffer" temporary;
        ValueBuffer: Record lvngLoanLevelValueBuffer temporary;
        GLFilterCache: Dictionary of [Integer, Text];
        TotalsData: Dictionary of [Integer, Decimal];
        BasedOn: Enum lvngLoanLevelReportBaseDate;
        GridExportMode: Enum lvngGridExportMode;
        DefaultBoolean: Enum lvngDefaultBoolean;
        CellHorizontalAlignment: Enum lvngCellHorizontalAlignment;
        CellVerticalAlignment: Enum lvngCellVerticalAlignment;
        Dim1Visible: Boolean;
        Dim2Visible: Boolean;
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;
        BusinessUnitVisible: Boolean;
        TotalsRowVisible: Boolean;

    trigger OnOpenPage()
    begin
        LoanVisionSetup.Get();
        CacheGLFilterBlobs();
        CalculateData();
    end;

    procedure SetParams(SchemaCode: Code[20]; BaseDate: Enum lvngLoanLevelReportBaseDate; var Filter: Record lvngSystemCalculationFilter; ShowTotals: Boolean)
    begin
        LoanLevelReportSchema.Get(SchemaCode);
        BasedOn := BaseDate;
        SystemFilter := Filter;
        TotalsRowVisible := ShowTotals;
        BusinessUnitVisible := Filter."Business Unit" <> '';
        Dim1Visible := Filter."Global Dimension 1" <> '';
        Dim2Visible := Filter."Global Dimension 2" <> '';
        Dim3Visible := Filter."Shortcut Dimension 3" <> '';
        Dim4Visible := Filter."Shortcut Dimension 4" <> '';
    end;

    local procedure CacheGLFilterBlobs()
    var
        LoanLevelReportSchemaLine: Record lvngLoanLevelReportSchemaLine;
        IStream: InStream;
        GLFilter: Text;
    begin
        Clear(GLFilterCache);
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
        LoanLevelReportSchemaLine.SetRange(Type, LoanLevelReportSchemaLine.Type::"G/L Entry");
        if LoanLevelReportSchemaLine.FindSet() then
            repeat
                if LoanLevelReportSchemaLine."G/L Filter".HasValue then begin
                    LoanLevelReportSchemaLine.CalcFields("G/L Filter");
                    LoanLevelReportSchemaLine."G/L Filter".CreateInStream(IStream);
                    IStream.ReadText(GLFilter);
                    if GLFilter <> '' then
                        GLFilterCache.Add(LoanLevelReportSchemaLine."Column No.", GLFilter);
                end;
            until LoanLevelReportSchemaLine.Next() = 0;
    end;

    local procedure CalculateData()
    var
        GLLoansPerPeriod: Query lvngGLEntryLoansPerPeriod;
        Loan: Record lvngLoan;
        RowNo: Integer;
    begin
        RowBuffer.Reset();
        RowBuffer.DeleteAll();
        ValueBuffer.Reset();
        ValueBuffer.DeleteAll();
        Clear(TotalsData);
        RowNo := 1;
        if BasedOn = BasedOn::Posting then begin
            Clear(GLLoansPerPeriod);
            if SystemFilter."Global Dimension 1" <> '' then
                GLLoansPerPeriod.SetFilter(Dim1Filter, SystemFilter."Global Dimension 1");
            if SystemFilter."Global Dimension 2" <> '' then
                GLLoansPerPeriod.SetFilter(Dim1Filter, SystemFilter."Global Dimension 2");
            GLLoansPerPeriod.SetFilter(PostingDate, SystemFilter."Date Filter");
            if SystemFilter."Shortcut Dimension 3" <> '' then
                GLLoansPerPeriod.SetFilter(Dim1Filter, SystemFilter."Shortcut Dimension 3");
            if SystemFilter."Shortcut Dimension 4" <> '' then
                GLLoansPerPeriod.SetFilter(Dim1Filter, SystemFilter."Shortcut Dimension 4");
            if SystemFilter."Business Unit" <> '' then
                GLLoansPerPeriod.SetFilter(BUFilter, SystemFilter."Business Unit");
            if GLLoansPerPeriod.Open() then
                while GLLoansPerPeriod.Read() do begin
                    Clear(RowBuffer);
                    RowBuffer.ID := RowNo;
                    RowNo += 1;
                    Loan.Get(GLLoansPerPeriod.LoanNo);
                    RowBuffer.Name := Loan."No.";
                    RowBuffer.Value := Format(GLLoansPerPeriod.PostingDate);
                    CalculateRowData(Loan);
                    if LoanLevelReportSchema."Skip Zero Balance Lines" then begin
                        ValueBuffer.Reset();
                        ValueBuffer.SetRange("Row No.", RowBuffer.ID);
                        ValueBuffer.SetRange("Value Type", ValueBuffer."Value Type"::Number);
                        ValueBuffer.SetFilter("Numeric Value", '<>%1', 0);
                        if not ValueBuffer.IsEmpty() then
                            RowBuffer.Insert();
                    end else
                        RowBuffer.Insert();
                end;
            GLLoansPerPeriod.Close();
        end else begin
            Loan.Reset();
            if SystemFilter."Global Dimension 1" <> '' then
                Loan.SetFilter("Global Dimension 1 Code", SystemFilter."Global Dimension 1");
            if SystemFilter."Global Dimension 2" <> '' then
                Loan.SetFilter("Global Dimension 2 Code", SystemFilter."Global Dimension 2");
            if SystemFilter."Shortcut Dimension 3" <> '' then
                Loan.SetFilter("Shortcut Dimension 3 Code", SystemFilter."Shortcut Dimension 3");
            if SystemFilter."Shortcut Dimension 4" <> '' then
                Loan.SetFilter("Shortcut Dimension 4 Code", SystemFilter."Shortcut Dimension 4");
            if SystemFilter."Business Unit" <> '' then
                Loan.SetFilter("Business Unit Code", SystemFilter."Business Unit");
            if BasedOn = BasedOn::Sold then
                Loan.SetFilter("Date Sold", SystemFilter."Date Filter")
            else
                Loan.SetFilter("Date Funded", SystemFilter."Date Filter");
            if Loan.FindSet() then
                repeat
                    Clear(RowBuffer);
                    RowBuffer.ID := RowNo;
                    RowNo += 1;
                    RowBuffer.Name := Loan."No.";
                    if BasedOn = BasedOn::Sold then
                        RowBuffer.Value := Format(Loan."Date Sold")
                    else
                        RowBuffer.Value := Format(loan."Date Funded");
                    CalculateRowData(Loan);
                    RowBuffer.Insert();
                until Loan.Next() = 0;
        end;
    end;

    local procedure CalculateRowData(var Loan: Record lvngLoan)
    var
        DefaultDimension: Record "Default Dimension";
        DimensionValue: Record "Dimension Value";
        GroupedLoanGLEntry: Record lvngGroupedLoanGLEntry;
        LoanLevelReportSchemaLine: Record lvngLoanLevelReportSchemaLine;
        TempGroupedLoanGLEntry: Record lvngGroupedLoanGLEntry temporary;
        RecordReference: RecordRef;
        CalculatedValue: Text;
        CurrentTotal: Decimal;
    begin
        if DefaultDimension.Get(Database::lvngLoan, Loan."No.", LoanVisionSetup."Loan Officer Dimension Code") then
            if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then
                RowBuffer."Value Long" := DimensionValue.Name;
        TempGroupedLoanGLEntry.Reset();
        TempGroupedLoanGLEntry.DeleteAll();
        GroupedLoanGLEntry.Reset();
        GroupedLoanGLEntry.SetRange("Loan No.", Loan."No.");
        if SystemFilter."Global Dimension 1" <> '' then
            GroupedLoanGLEntry.SetFilter("Global Dimension 1 Code", SystemFilter."Global Dimension 1");
        if SystemFilter."Global Dimension 2" <> '' then
            GroupedLoanGLEntry.SetFilter("Global Dimension 2 Code", SystemFilter."Global Dimension 2");
        if SystemFilter."Shortcut Dimension 3" <> '' then
            GroupedLoanGLEntry.SetFilter("Shortcut Dimension 3 Code", SystemFilter."Shortcut Dimension 3");
        if SystemFilter."Shortcut Dimension 4" <> '' then
            GroupedLoanGLEntry.SetFilter("Shortcut Dimension 4 Code", SystemFilter."Shortcut Dimension 4");
        if SystemFilter."Business Unit" <> '' then
            GroupedLoanGLEntry.SetFilter("Business Unit Code", SystemFilter."Business Unit");
        if GroupedLoanGLEntry.FindSet() then
            repeat
                //Still using temp because schema line filters may conflict with global filters
                TempGroupedLoanGLEntry := GroupedLoanGLEntry;
                TempGroupedLoanGLEntry.Insert();
            until GroupedLoanGLEntry.Next() = 0;
        RecordReference.GetTable(Loan);
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
        LoanLevelReportSchemaLine.SetFilter(Type, '<>%1', LoanLevelReportSchemaLine.Type::Formula);
        LoanLevelReportSchemaLine.FindSet();
        repeat
            Clear(ValueBuffer);
            ValueBuffer."Row No." := RowBuffer.ID;
            ValueBuffer."Column No." := LoanLevelReportSchemaLine."Column No.";
            ValueBuffer."Number Format Code" := LoanLevelReportSchemaLine."Number Format Code";
            CalculatePlainValue(LoanLevelReportSchemaLine, TempGroupedLoanGLEntry, Loan, RecordReference);
            ValueBuffer.Insert();
        until LoanLevelReportSchemaLine.Next() = 0;
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
        LoanLevelReportSchemaLine.SetRange(Type, LoanLevelReportSchemaLine.Type::Formula);
        LoanLevelReportSchemaLine.FindSet();
        repeat
            CalculatedValue := CalculateFormulaValue(LoanLevelReportSchemaLine);
            Clear(ValueBuffer);
            ValueBuffer."Row No." := RowBuffer.ID;
            ValueBuffer."Column No." := LoanLevelReportSchemaLine."Column No.";
            ValueBuffer."Number Format Code" := LoanLevelReportSchemaLine."Number Format Code";
            ValueBuffer."Raw Value" := CalculatedValue;
            if Evaluate(ValueBuffer."Numeric Value", CalculatedValue) then
                ValueBuffer."Value Type" := ValueBuffer."Value Type"::Number
            else
                ValueBuffer."Value Type" := ValueBuffer."Value Type"::Text;
            ValueBuffer.Insert();
        until LoanLevelReportSchemaLine.Next() = 0;
        RecordReference.Close();
        if TotalsRowVisible then begin
            ValueBuffer.Reset();
            ValueBuffer.SetRange("Row No.", RowBuffer.ID);
            if ValueBuffer.FindSet() then
                repeat
                    if RowBuffer.ID = 1 then begin //First row
                        if ValueBuffer."Value Type" = ValueBuffer."Value Type"::Number then
                            TotalsData.Add(ValueBuffer."Column No.", ValueBuffer."Numeric Value");
                    end else begin
                        if TotalsData.Get(ValueBuffer."Column No.", CurrentTotal) then begin
                            if ValueBuffer."Value Type" = ValueBuffer."Value Type"::Number then
                                TotalsData.Set(ValueBuffer."Column No.", CurrentTotal + ValueBuffer."Numeric Value")
                            else
                                TotalsData.Remove(ValueBuffer."Column No.");
                        end;
                    end;
                until ValueBuffer.Next() = 0;
        end;
    end;

    local procedure CalculatePlainValue(var LoanLevelReportSchemaLine: Record lvngLoanLevelReportSchemaLine; var GroupedLoanGLEntry: Record lvngGroupedLoanGLEntry; var Loan: Record lvngLoan; var LoanRef: RecordRef)
    var
        LoanValue: Record lvngLoanValue;
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        FieldReference: FieldRef;
        GLFilter: Text;
    begin
        case LoanLevelReportSchemaLine.Type of
            LoanLevelReportSchemaLine.Type::"G/L Entry":
                begin
                    ValueBuffer."Value Type" := ValueBuffer."Value Type"::Number;
                    //Possible bug (was): Value was always set to 0 if no filter is specified
                    GroupedLoanGLEntry.Reset();
                    if GLFilterCache.Get(LoanLevelReportSchemaLine."Column No.", GLFilter) then
                        GroupedLoanGLEntry.SetView(GLFilter);
                    GroupedLoanGLEntry.CalcSums(Amount);
                    ValueBuffer."Numeric Value" := GroupedLoanGLEntry.Amount;
                    ValueBuffer."Raw Value" := Format(ValueBuffer."Numeric Value");
                end;
            LoanLevelReportSchemaLine.Type::"Variable Field":
                begin
                    if LoanValue.Get(Loan."No.", LoanLevelReportSchemaLine."Value Field No.") then begin
                        LoanFieldsConfiguration.Get(LoanValue."Field No.");
                        case LoanFieldsConfiguration."Value Type" of
                            LoanFieldsConfiguration."Value Type"::Boolean:
                                begin
                                    ValueBuffer."Value Type" := ValueBuffer."Value Type"::Text;
                                    if LoanValue."Boolean Value" then
                                        ValueBuffer."Raw Value" := YesTxt
                                    else
                                        ValueBuffer."Raw Value" := NoTxt;
                                end;
                            LoanFieldsConfiguration."Value Type"::Date:
                                begin
                                    ValueBuffer."Value Type" := ValueBuffer."Value Type"::Date;
                                    ValueBuffer."Date Value" := LoanValue."Date Value";
                                    ValueBuffer."Raw Value" := Format(ValueBuffer."Date Value");
                                end;
                            LoanFieldsConfiguration."Value Type"::Decimal:
                                begin
                                    ValueBuffer."Value Type" := ValueBuffer."Value Type"::Number;
                                    ValueBuffer."Numeric Value" := LoanValue."Decimal Value";
                                    ValueBuffer."Raw Value" := Format(ValueBuffer."Numeric Value");
                                end;
                            LoanFieldsConfiguration."Value Type"::Integer:
                                begin
                                    ValueBuffer."Value Type" := ValueBuffer."Value Type"::Number;
                                    ValueBuffer."Numeric Value" := LoanValue."Integer Value";
                                    ValueBuffer."Raw Value" := Format(ValueBuffer."Numeric Value");
                                end
                            else begin
                                    ValueBuffer."Value Type" := ValueBuffer."Value Type"::Text;
                                    ValueBuffer."Raw Value" := LoanValue."Field Value";
                                end;
                        end;
                    end;
                end;
            LoanLevelReportSchemaLine.Type::"Table Field":
                begin
                    FieldReference := LoanRef.Field(LoanLevelReportSchemaLine."Value Field No.");
                    ValueBuffer."Raw Value" := Format(FieldReference.Value);
                    ValueBuffer."Value Type" := ValueBuffer."Value Type"::Text;
                    if Evaluate(ValueBuffer."Date Value", ValueBuffer."Raw Value") then
                        ValueBuffer."Value Type" := ValueBuffer."Value Type"::Date
                    else
                        if Evaluate(ValueBuffer."Numeric Value", ValueBuffer."Raw Value") then
                            ValueBuffer."Value Type" := ValueBuffer."Value Type"::Number;
                end;
        end;
    end;

    local procedure CalculateFormulaValue(var LoanLevelReportSchemaLine: Record lvngLoanLevelReportSchemaLine): Text
    var
        ExpressionHeader: Record lvngExpressionHeader;
        FormulaBuffer: Record lvngExpressionValueBuffer temporary;
        LoanLevelMgmt: Codeunit lvngLoanLevelReportManagement;
        ExpressionEngine: Codeunit lvngExpressionEngine;
    begin
        ExpressionHeader.Get(LoanLevelReportSchemaLine."Formula Code", LoanLevelMgmt.GetLoanLevelFormulaConsumerId());
        FormulaBuffer.Reset();
        FormulaBuffer.DeleteAll();
        ValueBuffer.Reset();
        ValueBuffer.SetRange("Row No.", RowBuffer.ID);
        ValueBuffer.SetRange("Value Type", ValueBuffer."Value Type"::Number);
        if ValueBuffer.FindSet() then
            repeat
                Clear(FormulaBuffer);
                FormulaBuffer.Number := ValueBuffer."Column No.";
                FormulaBuffer.Name := 'Col' + Format(ValueBuffer."Column No.");
                FormulaBuffer.Type := 'Decimal';
                FormulaBuffer.Value := ValueBuffer."Raw Value";
                FormulaBuffer.Insert();
            until ValueBuffer.Next() = 0;
        exit(ExpressionEngine.CalculateFormula(ExpressionHeader, FormulaBuffer));
    end;

    local procedure InitializeDataGrid()
    var
        Json: JsonObject;
        Setting: JsonObject;
    begin
        Json.Add('columns', GetColumns());
        Json.Add('dataSource', GetData());
        Setting.Add('enabled', false);
        Json.Add('paging', Setting);
        Clear(Setting);
        Setting.Add('mode', 'none');
        Json.Add('sorting', Setting);
        Json.Add('columnAutoWidth', true);
        CurrPage.DataGrid.SetupStyles(GetGridStyles());
        CurrPage.DataGrid.InitializeDXGrid(Json);
    end;

    local procedure GetGridStyles() Json: JsonObject
    var
        CssClass: JsonObject;
    begin
        Clear(Json);
        Clear(CssClass);
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('font-style', 'italic');
        CssClass.Add('text-align', 'center !important');
        CssClass.Add('border-left', 'none !important');
        CssClass.Add('border-right', 'none !important');
        Json.Add('.dx-header-row td', CssClass);
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
        CssClass.Add('font-weight', 'bold');
        CssClass.Add('border-top', '1px solid #000');
        Json.Add('.totals td', CssClass);
    end;

    local procedure GetData() DataSource: JsonArray
    var
        LoanLevelReportSchemaLine: Record lvngLoanLevelReportSchemaLine;
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
        RowData: JsonObject;
        ValueData: JsonObject;
        CalculatedTotal: Decimal;
    begin
        RowBuffer.Reset();
        if RowBuffer.FindSet() then begin
            repeat
                Clear(RowData);
                RowData.Add('rowId', RowBuffer.ID);
                RowData.Add('LoanNo', RowBuffer.Name);
                RowData.Add('BaseDate', RowBuffer.Value);
                RowData.Add('LOName', RowBuffer."Value Long");
                ValueBuffer.Reset();
                ValueBuffer.SetRange("Row No.", RowBuffer.ID);
                if ValueBuffer.FindSet() then
                    repeat
                        if ValueBuffer."Value Type" = ValueBuffer."Value Type"::Number then begin
                            Clear(ValueData);
                            ValueData.Add('v', FormatValue(ValueBuffer));
                            ValueData.Add('c', 'right');
                            RowData.Add('Col' + Format(ValueBuffer."Column No."), ValueData);
                        end else
                            RowData.Add('Col' + Format(ValueBuffer."Column No."), FormatValue(ValueBuffer));
                    until ValueBuffer.Next() = 0;
                DataSource.Add(RowData);
            until RowBuffer.Next() = 0;
            if TotalsRowVisible then begin
                Clear(RowData);
                RowData.Add('rowId', -1);
                RowData.Add('CssClass', 'totals');
                RowData.Add('LoanNo', TotalsTxt);
                RowData.Add('BaseDate', NotAvailableTxt);
                RowData.Add('LOName', NotAvailableTxt);
                LoanLevelReportSchemaLine.Reset();
                LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
                if LoanLevelReportSchemaLine.FindSet() then
                    repeat
                        if TotalsData.Get(LoanLevelReportSchemaLine."Column No.", CalculatedTotal) then begin
                            Clear(ValueData);
                            ValueData.Add('v', PerformanceMgmt.FormatValue(CalculatedTotal, LoanLevelReportSchemaLine."Number Format Code"));
                            ValueData.Add('c', 'right');
                            RowData.Add('Col' + Format(LoanLevelReportSchemaLine."Column No."), ValueData);
                        end else
                            RowData.Add('Col' + Format(LoanLevelReportSchemaLine."Column No."), NotAvailableTxt);
                    until LoanLevelReportSchemaLine.Next() = 0;
                DataSource.Add(RowData);
            end;
        end;
    end;

    local procedure FormatValue(var Buffer: Record lvngLoanLevelValueBuffer): Text
    var
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
    begin
        if Buffer."Value Type" <> Buffer."Value Type"::Number then
            exit(Buffer."Raw Value")
        else
            exit(PerformanceMgmt.FormatValue(Buffer."Numeric Value", Buffer."Number Format Code"))
    end;

    local procedure GetColumns() GridColumns: JsonArray
    var
        LoanLevelReportSchemaLine: Record lvngLoanLevelReportSchemaLine;
        ShowCol: Boolean;
    begin
        GridColumns.Add(GetColumn('LoanNo', LoanNoLbl, 'desc', true));
        case BasedOn of
            BasedOn::Sold:
                GridColumns.Add(GetColumn('BaseDate', DateSoldLbl, '', true));
            BasedOn::Posting:
                GridColumns.Add(GetColumn('BaseDate', PostingDateLbl, '', true))
            else
                GridColumns.Add(GetColumn('BaseDate', DateFundedLbl, '', true));
        end;
        GridColumns.Add(GetColumn('LOName', LONameLbl, '', true));
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
        if LoanLevelReportSchemaLine.FindSet() then
            repeat
                ShowCol := true;
                if LoanLevelReportSchema."Skip Zero Balance Lines" and (LoanLevelReportSchemaLine.Type = LoanLevelReportSchemaLine.Type::"G/L Entry") then begin
                    ValueBuffer.Reset();
                    ValueBuffer.SetRange("Column No.", LoanLevelReportSchemaLine."Column No.");
                    ValueBuffer.SetFilter("Numeric Value", '<>0');
                    ShowCol := not ValueBuffer.IsEmpty();
                end;
                if ShowCol then
                    GridColumns.Add(GetColumn('Col' + Format(LoanLevelReportSchemaLine."Column No."), LoanLevelReportSchemaLine.Description, '', false));
            until LoanLevelReportSchemaLine.Next() = 0;
    end;

    local procedure GetColumn(DataField: Text; Caption: Text; CssClass: Text; Fix: Boolean) Col: JsonObject
    begin
        Col.Add('dataField', DataField);
        Col.Add('caption', Caption);
        if CssClass <> '' then
            Col.Add('cssClass', CssClass);
        if Fix then begin
            Col.Add('fixed', true);
            Col.Add('fixedPosition', 'left');
        end;
    end;

    local procedure ExportToExcel(GridExportMode: Enum lvngGridExportMode)
    var
        LoanLevelReportSchemaLine: Record lvngLoanLevelReportSchemaLine;
        ExpressionHeader: Record lvngExpressionHeader;
        ColBuffer: Record lvngLoanLevelReportSchemaLine temporary;
        LoanLevelMgmt: Codeunit lvngLoanLevelReportManagement;
        ExpressionEngine: Codeunit lvngExpressionEngine;
        ColIndexLookup: Dictionary of [Integer, Integer];
        ExcelExport: Codeunit lvngExcelExport;
        DataColStartIdx: Integer;
        DataRowStartIdx: Integer;
        RowId: Integer;
        Idx: Integer;
        ShowCol: Boolean;
        Dummy: Decimal;
        BaseDate: Date;
    begin
        Idx := 0;
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", LoanLevelReportSchema.Code);
        if LoanLevelReportSchemaLine.FindSet() then
            repeat
                ShowCol := true;
                if LoanLevelReportSchema."Skip Zero Balance Lines" and (LoanLevelReportSchemaLine.Type = LoanLevelReportSchemaLine.Type::"G/L Entry") then begin
                    ValueBuffer.Reset();
                    ValueBuffer.SetRange("Column No.", LoanLevelReportSchemaLine."Column No.");
                    ValueBuffer.SetFilter("Numeric Value", '<>0');
                    ShowCol := not ValueBuffer.IsEmpty();
                end;
                if ShowCol then begin
                    ColBuffer := LoanLevelReportSchemaLine;
                    ColBuffer.Insert();
                    ColIndexLookup.Add(ColBuffer."Column No.", Idx);
                    Idx += 1;
                end;
            until LoanLevelReportSchemaLine.Next() = 0;
        ExcelExport.Init('LoanLevelWorksheet', GridExportMode);
        //Add Filters
        ExcelExport.NewRow(-10);
        ExcelExport.StyleColumn(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, -1, '', '', '');
        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 14, '', '', '');
        ExcelExport.BeginRange();
        ExcelExport.WriteString(LoanLevelReportSchema.Description);
        ExcelExport.SkipCells(6);
        ExcelExport.MergeRange(false);
        ExcelExport.NewRow(-20);
        RowId := -30;
        if SystemFilter."Global Dimension 1" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('3,1,1'));
            ExcelExport.WriteString(SystemFilter."Global Dimension 1");
        end;
        if SystemFilter."Global Dimension 2" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('3,1,2'));
            ExcelExport.WriteString(SystemFilter."Global Dimension 2");
        end;
        if SystemFilter."Shortcut Dimension 3" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('4,1,3'));
            ExcelExport.WriteString(SystemFilter."Shortcut Dimension 3");
        end;
        if SystemFilter."Shortcut Dimension 4" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(CaptionClassTranslate('4,1,4'));
            ExcelExport.WriteString(SystemFilter."Shortcut Dimension 4");
        end;
        if SystemFilter."Business Unit" <> '' then begin
            ExcelExport.NewRow(RowId);
            RowId -= 10;
            ExcelExport.WriteString(BusinessUnitFilterTxt);
            ExcelExport.WriteString(SystemFilter."Business Unit");
        end;
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        ExcelExport.WriteString(BaseDateText);
        if BasedOn = BasedOn::Default then
            BasedOn := BasedOn::Funded;
        ExcelExport.WriteString(Format(BasedOn));
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        ExcelExport.WriteString(DateFilterTxt);
        ExcelExport.WriteString(SystemFilter."Date Filter");
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        //Add Header
        ExcelExport.NewRow(RowId);
        RowId -= 10;
        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Yes, DefaultBoolean::No, -1, '', '', '');
        ExcelExport.AlignRow(CellHorizontalAlignment::Center, CellVerticalAlignment::Default, -1, 0, DefaultBoolean::Default, DefaultBoolean::Default);
        DataColStartIdx := 3; //Skip LoanNo, BaseDate and LOName columns
        DataRowStartIdx := -RowId div 10 - 1; //Skip header columns, - 1 for zero-based
        ExcelExport.WriteString(LoanNoLbl);
        case BasedOn of
            BasedOn::Sold:
                ExcelExport.WriteString(DateSoldLbl);
            BasedOn::Posting:
                ExcelExport.WriteString(PostingDateLbl);
            else
                ExcelExport.WriteString(DateFundedLbl);
        end;
        ExcelExport.WriteString(LONameLbl);
        ColBuffer.Reset();
        if ColBuffer.FindSet() then
            repeat
                ExcelExport.WriteString(ColBuffer.Description);
            until ColBuffer.Next() = 0;
        //Add Rows
        RowBuffer.Reset();
        if RowBuffer.FindSet() then begin
            repeat
                ExcelExport.NewRow(RowBuffer.ID);
                ExcelExport.WriteString(RowBuffer.Name);    //LoanNo
                Evaluate(BaseDate, RowBuffer.Value);
                ExcelExport.WriteDate(BaseDate);   //Date
                ExcelExport.WriteString(RowBuffer."Value Long");//LOName
                ColBuffer.Reset();
                if ColBuffer.FindSet() then
                    repeat
                        if ColBuffer.Type = ColBuffer.Type::Formula then begin
                            ExcelExport.FormatCell(ColBuffer."Number Format Code");
                            ExpressionHeader.Get(ColBuffer."Formula Code", LoanLevelMgmt.GetLoanLevelFormulaConsumerId());
                            ExcelExport.WriteFormula('=' + TranslateRowFormula(ExpressionEngine.GetFormulaFromLines(ExpressionHeader), RowBuffer.ID - 1, DataRowStartIdx, DataColStartIdx, ColIndexLookup));
                        end else begin
                            ValueBuffer.Get(RowBuffer.ID, ColBuffer."Column No.");
                            if ValueBuffer."Number Format Code" <> '' then
                                ExcelExport.FormatCell(ValueBuffer."Number Format Code");
                            case ValueBuffer."Value Type" of
                                ValueBuffer."Value Type"::Number:
                                    ExcelExport.WriteNumber(ValueBuffer."Numeric Value");
                                ValueBuffer."Value Type"::Date:
                                    ExcelExport.WriteDate(ValueBuffer."Date Value");
                                else
                                    ExcelExport.WriteString(ValueBuffer."Raw Value");
                            end;
                        end;
                    until ColBuffer.Next() = 0;
            until RowBuffer.Next() = 0;
            if TotalsRowVisible then begin
                ExcelExport.NewRow(RowBuffer.ID + 1);
                ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::No, DefaultBoolean::No, -1, '', '', '');
                ExcelExport.WriteString(TotalsTxt);
                ExcelExport.WriteString(NotAvailableTxt);
                ExcelExport.WriteString(NotAvailableTxt);
                ColBuffer.Reset();
                ColBuffer.SetRange("Report Code", LoanLevelReportSchema.Code);
                if ColBuffer.FindSet() then
                    repeat
                        if TotalsData.Get(ColBuffer."Column No.", Dummy) then begin
                            ExcelExport.FormatCell(ColBuffer."Number Format Code");
                            ExcelExport.WriteFormula('=SUM(' + TranslateRowFormulaField('col' + Format(ColBuffer."Column No."), 0, DataRowStartIdx, DataColStartIdx, ColIndexLookup) + ':' + TranslateRowFormulaField('col' + Format(ColBuffer."Column No."), RowBuffer.ID - 1, DataRowStartIdx, DataColStartIdx, ColIndexLookup) + ')');
                        end else
                            ExcelExport.WriteString(NotAvailableTxt);
                    until ColBuffer.Next() = 0;
            end;
        end;
        ExcelExport.AutoFit(false, true);
        ExcelExport.Download(GetExportFileName(GridExportMode));
    end;

    local procedure TranslateRowFormula(Formula: Text; RowIdx: Integer; DataRowOffset: Integer; DataColOffset: Integer; var ColIndexLookup: Dictionary of [Integer, Integer]): Text
    var
        FieldStart: Integer;
        FieldEnd: Integer;
    begin
        //[Col1]+[Col2]+[Col3]+...
        //=>
        //=D7+E7+F7+...
        Formula := LowerCase(Formula);
        FieldStart := StrPos(Formula, '[');
        while FieldStart <> 0 do begin
            FieldEnd := StrPos(Formula, ']');
            if FieldEnd = 0 then
                Error(IntranslatableRowFormulaErr);
            Formula := CopyStr(Formula, 1, FieldStart - 1) + TranslateRowFormulaField(CopyStr(Formula, FieldStart + 1, FieldEnd - FieldStart - 1), RowIdx, DataRowOffset, DataColOffset, ColIndexLookup) + CopyStr(Formula, FieldEnd + 1);
            FieldStart := StrPos(Formula, '[');
        end;
        exit(Formula);
    end;

    local procedure TranslateRowFormulaField(Field: Text; RowIdx: Integer; DataRowOffset: Integer; DataColOffset: Integer; var ColIndexLookup: Dictionary of [Integer, Integer]): Text
    var
        ExcelExport: Codeunit lvngExcelExport;
        FieldIdx: Integer;
    begin
        if StrPos(Field, 'col') <> 1 then
            Error(IntranslatableRowFormulaErr);
        if not Evaluate(FieldIdx, DelStr(Field, 1, 3)) then
            Error(IntranslatableRowFormulaErr);
        if not ColIndexLookup.Get(FieldIdx, FieldIdx) then
            Error(IntranslatableRowFormulaErr);
        exit(ExcelExport.GetExcelColumnName(DataColOffset + FieldIdx) + Format(RowIdx + DataRowOffset + 1));
    end;

    procedure GetExportFileName(Mode: Enum lvngGridExportMode): Text
    begin
        case Mode of
            Mode::Pdf:
                exit(LoanLevelExportFileNameTxt + '.pdf');
            Mode::Html:
                exit(LoanLevelExportFileNameTxt + '.html');
            else
                exit(LoanLevelExportFileNameTxt + '.xlsx');
        end;
    end;
}