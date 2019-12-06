report 14135221 lvngRptGeneratorBatchProcess
{
    Caption = 'Report Generator Batch Process';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(ReportGeneratorBatch; ReportGeneratorBatch.Code) { ApplicationArea = All; Caption = 'Batch Code'; }
                    field(ToDate; ToDate) { ApplicationArea = All; Caption = 'To Date'; }
                    field(ExportFormat; ExportFormat)
                    {
                        ApplicationArea = All;
                        Caption = 'Output Format';

                        trigger OnValidate()
                        begin
                            if ExportFormat = ExportFormat::Html then
                                Message(HtmlExportWarningMsg);
                        end;
                    }
                }
            }
        }
    }

    var
        ReportGeneratorBatch: Record lvngReportGeneratorBatch;
        PerformanceDataExport: Codeunit lvngPerformanceDataExport;
        ToDate: Date;
        ExportFormat: Enum lvngGridExportMode;
        ProcessProgressMsg: Label 'Processing item #1#### of #2####';
        HtmlExportWarningMsg: Label 'Warning: Html format will only process first entry in whole batch!';
        ExportCallerLbl: Label 'ReportGeneratorBatchProcess';
        RenamedSheetTemplateLbl: Label '%1 %2';
        RenamedSubSeqSheetTemplateLbl: Label '%1.%2 %3 %4';
        ProgressTemplateMsg: Label '%1.%2';

    trigger OnInitReport()
    begin
        ToDate := Today();
    end;

    trigger OnPreReport()
    var
        ReportGeneratorSequence: Record lvngReportGeneratorSequence;
        SubSequence: Record lvngReportGeneratorSequence;
        ExcelExport: Codeunit lvngExcelExport;
        Dialog: Dialog;
        SchemaType: Enum lvngPerformanceRowSchemaType;
        ProcessedCount: Integer;
        TotalCount: Integer;
        SubCount: Integer;
        FilterValue: Text;
        PipeIdx: Integer;
        CurrentExpand: Text;
    begin
        ReportGeneratorBatch.Get(ReportGeneratorBatch.Code);
        ReportGeneratorSequence.Reset();
        ReportGeneratorSequence.SetRange("Batch Code", ReportGeneratorBatch.Code);
        if not ReportGeneratorSequence.FindSet() then
            exit;
        ProcessedCount := 0;
        TotalCount := ReportGeneratorSequence.Count();
        Dialog.Open(ProcessProgressMsg, ProcessedCount, TotalCount);
        ExcelExport.Init(ExportCallerLbl, ExportFormat);
        repeat
            if ReportGeneratorSequence."Expand Filter" = ReportGeneratorSequence."Expand Filter"::None then begin
                if ProcessedCount > 0 then
                    ExcelExport.NewSheet();
                ExcelExport.RenameSheet(StrSubstNo(RenamedSheetTemplateLbl, ReportGeneratorSequence."Sequence No.", ReportGeneratorSequence.Description));
                ProcessReportSequence(ExcelExport, ReportGeneratorSequence);
            end else begin
                SubCount := 0;
                FilterValue := GetFilterValue(ReportGeneratorSequence);
                repeat
                    PipeIdx := StrPos(FilterValue, '|');
                    Dialog.Update(1, StrSubstNo(ProgressTemplateMsg, ProcessedCount + 1, SubCount + 1));
                    SubSequence := ReportGeneratorSequence;
                    if PipeIdx = 0 then begin
                        SetFilterValue(SubSequence, FilterValue);
                        CurrentExpand := FilterValue;
                    end else begin
                        CurrentExpand := CopyStr(FilterValue, 1, PipeIdx - 1);
                        SetFilterValue(SubSequence, CurrentExpand);
                        FilterValue := CopyStr(FilterValue, PipeIdx + 1);
                    end;
                    if (ProcessedCount > 0) or (SubCount > 0) then
                        ExcelExport.NewSheet();
                    ExcelExport.RenameSheet(StrSubstNo(RenamedSubSeqSheetTemplateLbl, ReportGeneratorSequence."Sequence No.", SubCount + 1, ReportGeneratorSequence.Description, CurrentExpand));
                    ProcessReportSequence(ExcelExport, SubSequence);
                    SubCount += 1;
                until PipeIdx = 0;
            end;
            ProcessedCount += 1;
        until ReportGeneratorSequence.Next() = 0;
        Dialog.Close();
        ExcelExport.Download(PerformanceDataExport.GetExportFileName(ExportFormat, SchemaType::Period));
    end;

    procedure SetParams(BatchCode: Code[20])
    begin
        ReportGeneratorBatch.Get(BatchCode);
    end;

    local procedure GetFilterValue(var ReportGeneratorSequence: Record lvngReportGeneratorSequence): Text
    begin
        case ReportGeneratorSequence."Expand Filter" of
            ReportGeneratorSequence."Expand Filter"::"Business Unit":
                exit(ReportGeneratorSequence."Business Unit Filter");
            ReportGeneratorSequence."Expand Filter"::"Dimension 1":
                exit(ReportGeneratorSequence."Dimension 1 Filter");
            ReportGeneratorSequence."Expand Filter"::"Dimension 2":
                exit(ReportGeneratorSequence."Dimension 2 Filter");
            ReportGeneratorSequence."Expand Filter"::"Dimension 3":
                exit(ReportGeneratorSequence."Dimension 3 Filter");
            ReportGeneratorSequence."Expand Filter"::"Dimension 4":
                exit(ReportGeneratorSequence."Dimension 4 Filter");
        end;
    end;

    local procedure SetFilterValue(var ReportGeneratorSequence: Record lvngReportGeneratorSequence; Value: Text): Text
    begin
        case ReportGeneratorSequence."Expand Filter" of
            ReportGeneratorSequence."Expand Filter"::"Business Unit":
                ReportGeneratorSequence."Business Unit Filter" := Value;
            ReportGeneratorSequence."Expand Filter"::"Dimension 1":
                ReportGeneratorSequence."Dimension 1 Filter" := Value;
            ReportGeneratorSequence."Expand Filter"::"Dimension 2":
                ReportGeneratorSequence."Dimension 2 Filter" := Value;
            ReportGeneratorSequence."Expand Filter"::"Dimension 3":
                ReportGeneratorSequence."Dimension 3 Filter" := Value;
            ReportGeneratorSequence."Expand Filter"::"Dimension 4":
                ReportGeneratorSequence."Dimension 4 Filter" := Value;
        end;
    end;

    local procedure ProcessReportSequence(var ExcelExport: Codeunit lvngExcelExport; var ReportGeneratorSequence: Record lvngReportGeneratorSequence)
    var
        RowSchema: Record lvngPerformanceRowSchema;
        BandSchema: Record lvngPeriodPerfBandSchema;
        BaseFilter: Record lvngSystemCalculationFilter temporary;
        BandInfoBuffer: Record lvngPerformanceBandLineInfo temporary;
        ValueBuffer: Record lvngPerformanceValueBuffer temporary;
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
    begin
        Clear(BaseFilter);
        BaseFilter.Description := ReportGeneratorSequence.Description;
        BaseFilter."Shortcut Dimension 1" := ReportGeneratorSequence."Dimension 1 Filter";
        BaseFilter."Shortcut Dimension 2" := ReportGeneratorSequence."Dimension 2 Filter";
        BaseFilter."Shortcut Dimension 3" := ReportGeneratorSequence."Dimension 3 Filter";
        BaseFilter."Shortcut Dimension 4" := ReportGeneratorSequence."Dimension 4 Filter";
        BaseFilter."Business Unit" := ReportGeneratorSequence."Business Unit Filter";
        if ToDate = 0D then
            ToDate := Today();
        BaseFilter."As Of Date" := ToDate;
        RowSchema.Get(ReportGeneratorSequence."Row Layout");
        BandSchema.Get(ReportGeneratorSequence."Band Layout");
        PerformanceMgmt.CalculatePeriodsData(RowSchema, BandSchema, BaseFilter, BandInfoBuffer, ValueBuffer);
        PerformanceDataExport.ExportToExcel(ExcelExport, RowSchema, ValueBuffer, BaseFilter, BandInfoBuffer);
    end;
}