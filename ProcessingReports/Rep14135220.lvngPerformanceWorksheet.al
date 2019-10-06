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
                            PeriodList: Page lvngPeriodPerfBandSchemaList;
                            DimensionList: Page lvngDimPerfBandSchemaList;
                        begin
                            if not RowSchema.Get(RowSchemaCode) then
                                exit(false);
                            if RowSchema."Schema Type" = RowSchema."Schema Type"::lvngPeriod then begin
                                Clear(PeriodList);
                                if PeriodBand.Get(BandSchemaCode) then
                                    PeriodList.SetRecord(PeriodBand);
                                PeriodList.LookupMode(true);
                                if PeriodList.RunModal() = Action::LookupOK then begin
                                    PeriodList.GetRecord(PeriodBand);
                                    Text := PeriodBand.Code;
                                    exit(true);
                                end;
                            end else begin
                                Clear(DimensionList);
                                DimensionBand.Reset();
                                DimensionBand.SetRange("Dynamic Layout", RowSchema."Schema Type" = RowSchema."Schema Type"::lvngDimensionDynamic);
                                DimensionList.SetTableView(DimensionBand);
                                if DimensionBand.Get(BandSchemaCode, RowSchema."Schema Type" = RowSchema."Schema Type"::lvngDimensionDynamic) then
                                    DimensionList.SetRecord(DimensionBand);
                                DimensionList.LookupMode(true);
                                if DimensionList.RunModal() = Action::LookupOK then begin
                                    DimensionList.GetRecord(DimensionBand);
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
                            Idx: Integer;
                            FromDate: Text;
                            ToDate: Text;
                        begin
                            RowSchema.Get(RowSchemaCode);
                            if RowSchema."Schema Type" = RowSchema."Schema Type"::lvngPeriod then begin
                                Evaluate(AsOfDate, DateFilter);
                                DateFilter := Format(AsOfDate);
                            end else begin
                                Idx := StrPos(DateFilter, '..');
                                if Idx = 0 then begin
                                    Evaluate(AsOfDate, DateFilter);
                                    DateFilter := '..' + Format(AsOfDate);
                                end else begin
                                    FromDate := CopyStr(DateFilter, 1, Idx - 1);
                                    ToDate := CopyStr(DateFilter, Idx + 2);
                                    if FromDate <> '' then begin
                                        Evaluate(AsOfDate, FromDate);
                                        FromDate := Format(AsOfDate);
                                    end;
                                    if ToDate <> '' then begin
                                        Evaluate(AsOfDate, ToDate);
                                        ToDate := Format(AsOfDate);
                                    end;
                                    DateFilter := FromDate + '..' + ToDate;
                                end;
                            end;
                        end;
                    }
                }
                group(Dimensions)
                {
                    Caption = 'Dimension Filters';

                    field(Dim1Filter; Dim1Filter) { ApplicationArea = All; Caption = 'Dimension 1 Filter'; CaptionClass = '1,3,1'; }
                    field(Dim2Filter; Dim2Filter) { ApplicationArea = All; Caption = 'Dimension 2 Filter'; CaptionClass = '1,3,2'; }
                    field(Dim3Filter; Dim3Filter) { ApplicationArea = All; Caption = 'Dimension 3 Filter'; CaptionClass = '1,4,3'; }
                    field(Dim4Filter; Dim4Filter) { ApplicationArea = All; Caption = 'Dimension 4 Filter'; CaptionClass = '1,4,4'; }
                    field(BusinessUnitFilter; BusinessUnitFilter) { ApplicationArea = All; Caption = 'Business Unit Filter'; }
                }
            }
        }
    }

    var
        RowSchema: Record lvngPerformanceRowSchema;
        DateFilter: Text;
        RowSchemaCode: Code[20];
        BandSchemaCode: Code[20];
        Dim1Filter: Code[20];
        Dim2Filter: Code[20];
        Dim3Filter: Code[20];
        Dim4Filter: Code[20];
        BusinessUnitFilter: Code[20];
        AsOfDate: Date;

    trigger OnPostReport()
    var
        PeriodPerformanceView: Page lvngPeriodPerformanceView;
        DimensionPerformanceView: Page lvngDimensionPerformanceView;
    begin
        RowSchema.Get(RowSchemaCode);
        if RowSchema."Schema Type" = RowSchema."Schema Type"::lvngPeriod then begin
            Clear(PeriodPerformanceView);
            Evaluate(AsOfDate, DateFilter);
            PeriodPerformanceView.SetParams(RowSchemaCode, BandSchemaCode, AsOfDate, Dim1Filter, Dim2Filter, Dim3Filter, Dim4Filter, BusinessUnitFilter);
            PeriodPerformanceView.RunModal();
        end else begin
            Clear(DimensionPerformanceView);
            DimensionPerformanceView.SetParams(RowSchemaCode, BandSchemaCode, DateFilter, Dim1Filter, Dim2Filter, Dim3Filter, Dim4Filter, BusinessUnitFilter);
            DimensionPerformanceView.RunModal();
        end;
    end;
}