report 14135220 lvngPerformanceWorksheet
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

                    field(RowSchemaCode; RowSchemaCode)
                    {
                        Caption = 'Row Schema';
                        ApplicationArea = All;
                        TableRelation = lvngPerformanceRowSchema;
                        NotBlank = true;

                        trigger OnValidate()
                        begin
                            BandSchemaCode := '';
                        end;
                    }
                    field(BandSchemaCode; BandSchemaCode)
                    {
                        Caption = 'Band Schema';
                        ApplicationArea = All;
                        NotBlank = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            PeriodBand: Record lvngPeriodPerfBandSchema;
                            DimensionBand: Record lvngDimensionPerfBandSchema;
                            PeriodSchemaList: Page lvngPeriodPerfBandSchemaList;
                            DimensionSchemaList: Page lvngDimPerfBandSchemaList;
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

                    field(DateFilter; DateFilter)
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
                            end else begin
                                if Evaluate(AsOfDate, DateFilter) then
                                    DateFilter := StrSubstNo(DateFilterLbl, AsOfDate)
                                else
                                    FilterTokens.MakeDateFilter(DateFilter);
                            end;
                        end;
                    }
                    field(ClosingDates; SystemFilter."Omit Closing Dates") { ApplicationArea = All; Importance = Additional; Caption = 'Omit Closing Dates'; }
                }
                group(Dimensions)
                {
                    Caption = 'Dimension Filters';

                    field(Dim1Filter; SystemFilter."Global Dimension 1") { ApplicationArea = All; Caption = 'Dimension 1 Filter'; CaptionClass = '1,3,1'; }
                    field(Dim2Filter; SystemFilter."Global Dimension 2") { ApplicationArea = All; Caption = 'Dimension 2 Filter'; CaptionClass = '1,3,2'; }
                    field(Dim3Filter; SystemFilter."Shortcut Dimension 3") { ApplicationArea = All; Caption = 'Dimension 3 Filter'; CaptionClass = '1,4,3'; }
                    field(Dim4Filter; SystemFilter."Shortcut Dimension 4") { ApplicationArea = All; Caption = 'Dimension 4 Filter'; CaptionClass = '1,4,4'; }
                    field(BusinessUnitFilter; SystemFilter."Business Unit") { ApplicationArea = All; Caption = 'Business Unit Filter'; }
                }
            }
        }
    }

    var
        RowSchema: Record lvngPerformanceRowSchema;
        SystemFilter: Record lvngSystemCalculationFilter temporary;
        DateFilter: Text;
        RowSchemaCode: Code[20];
        BandSchemaCode: Code[20];
        AsOfDate: Date;
        DateFilterLbl: Label '..%1';

    trigger OnPostReport()
    var
        PeriodPerformanceView: Page lvngPeriodPerformanceView;
        DimensionPerformanceView: Page lvngDimensionPerformanceView;
    begin
        RowSchema.Get(RowSchemaCode);
        if RowSchema."Schema Type" = RowSchema."Schema Type"::Period then begin
            Clear(PeriodPerformanceView);
            Evaluate(SystemFilter."As Of Date", DateFilter);
            PeriodPerformanceView.SetParams(RowSchemaCode, BandSchemaCode, SystemFilter);
            PeriodPerformanceView.RunModal();
        end else begin
            Clear(DimensionPerformanceView);
            SystemFilter."Date Filter" := DateFilter;
            DimensionPerformanceView.SetParams(RowSchemaCode, BandSchemaCode, SystemFilter);
            DimensionPerformanceView.RunModal();
        end;
    end;
}