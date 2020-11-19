report 14135220 "lvnPerformanceWorksheet"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Performance Worksheet';
    ProcessingOnly = true;

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(General)
                {
                    Caption = 'Schema';

                    field(RowSchemaCodeField; RowSchemaCode)
                    {
                        Caption = 'Row Schema';
                        ApplicationArea = All;
                        TableRelation = lvnPerformanceRowSchema;
                        NotBlank = true;

                        trigger OnValidate()
                        begin
                            BandSchemaCode := '';
                        end;
                    }
                    field(BandSchemaCodeField; BandSchemaCode)
                    {
                        Caption = 'Band Schema';
                        ApplicationArea = All;
                        NotBlank = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            PeriodBand: Record lvnPeriodPerfBandSchema;
                            DimensionBand: Record lvnDimensionPerfBandSchema;
                            PeriodSchemaList: Page lvnPeriodPerfBandSchemaList;
                            DimensionSchemaList: Page lvnDimPerfBandSchemaList;
                        begin
                            if not RowSchema.Get(RowSchemaCode) then
                                exit(false);
                            if RowSchema."Schema Type" = RowSchema."Schema Type"::Period then begin
                                Clear(PeriodSchemaList);
                                if PeriodBand.Get(BandSchemaCode) then
                                    PeriodSchemaList.SetRecord(PeriodBand);
                                PeriodSchemaList.LookupMode(true);
                                if PeriodSchemaList.RunModal() = Action::LookupOK then begin
                                    PeriodSchemaList.GetRecord(PeriodBand);
                                    Text := PeriodBand.Code;
                                    exit(true);
                                end;
                            end else begin
                                Clear(DimensionSchemaList);
                                DimensionBand.Reset();
                                DimensionBand.SetRange("Dynamic Layout", RowSchema."Schema Type" = RowSchema."Schema Type"::"Dimension Dynamic");
                                DimensionSchemaList.SetTableView(DimensionBand);
                                if DimensionBand.Get(BandSchemaCode, RowSchema."Schema Type" = RowSchema."Schema Type"::"Dimension Dynamic") then
                                    DimensionSchemaList.SetRecord(DimensionBand);
                                DimensionSchemaList.LookupMode(true);
                                if DimensionSchemaList.RunModal() = Action::LookupOK then begin
                                    DimensionSchemaList.GetRecord(DimensionBand);
                                    Text := DimensionBand.Code;
                                    exit(true);
                                end;
                            end;
                            exit(false);
                        end;
                    }
                }
                group(Dates)
                {
                    Caption = 'Date Filter';

                    field(DateFilterField; DateFilter)
                    {
                        Caption = 'Date Filter';
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            FilterTokens: Codeunit "Filter Tokens";
                        begin
                            RowSchema.Get(RowSchemaCode);
                            if RowSchema."Schema Type" = RowSchema."Schema Type"::Period then begin
                                Evaluate(AsOfDate, DateFilter);
                                DateFilter := Format(AsOfDate);
                            end else
                                if Evaluate(AsOfDate, DateFilter) then
                                    DateFilter := StrSubstNo(DateFilterLbl, AsOfDate)
                                else
                                    FilterTokens.MakeDateFilter(DateFilter);
                        end;
                    }
                    field(ClosingDates; TempSystemCalcFilter."Omit Closing Dates") { ApplicationArea = All; Importance = Additional; Caption = 'Omit Closing Dates'; }
                }
                group(Dimensions)
                {
                    Caption = 'Dimension Filters';

                    field(Dim1Filter; TempSystemCalcFilter."Global Dimension 1") { ApplicationArea = All; Caption = 'Dimension 1 Filter'; CaptionClass = '1,3,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
                    field(Dim2Filter; TempSystemCalcFilter."Global Dimension 2") { ApplicationArea = All; Caption = 'Dimension 2 Filter'; CaptionClass = '1,3,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
                    field(Dim3Filter; TempSystemCalcFilter."Shortcut Dimension 3") { ApplicationArea = All; Caption = 'Dimension 3 Filter'; CaptionClass = '1,4,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
                    field(Dim4Filter; TempSystemCalcFilter."Shortcut Dimension 4") { ApplicationArea = All; Caption = 'Dimension 4 Filter'; CaptionClass = '1,4,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
                    field(BusinessUnitFilter; TempSystemCalcFilter."Business Unit") { ApplicationArea = All; Caption = 'Business Unit Filter'; TableRelation = "Business Unit"; }
                }
            }
        }
    }

    trigger OnPostReport()
    var
        PeriodPerformanceView: Page lvnPeriodPerformanceView;
        DimensionPerformanceView: Page lvnDimensionPerformanceView;
    begin
        RowSchema.Get(RowSchemaCode);
        if RowSchema."Schema Type" = RowSchema."Schema Type"::Period then begin
            Clear(PeriodPerformanceView);
            Evaluate(TempSystemCalcFilter."As Of Date", DateFilter);
            PeriodPerformanceView.SetParams(RowSchemaCode, BandSchemaCode, TempSystemCalcFilter);
            PeriodPerformanceView.RunModal();
        end else begin
            Clear(DimensionPerformanceView);
            TempSystemCalcFilter."Date Filter" := DateFilter;
            DimensionPerformanceView.SetParams(RowSchemaCode, BandSchemaCode, TempSystemCalcFilter);
            DimensionPerformanceView.RunModal();
        end;
    end;

    var
        RowSchema: Record lvnPerformanceRowSchema;
        TempSystemCalcFilter: Record lvnSystemCalculationFilter temporary;
        DateFilter: Text;
        RowSchemaCode: Code[20];
        BandSchemaCode: Code[20];
        AsOfDate: Date;
        DateFilterLbl: Label '..%1';
}