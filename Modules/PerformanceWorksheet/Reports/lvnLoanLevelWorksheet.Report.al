report 14135222 "lvnLoanLevelWorksheet"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Loan Level Worksheet';
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
                    field(ColSchemaCodeField; ColSchemaCode) { Caption = 'Column Schema'; ApplicationArea = All; }
                    field(BaseDateField; BaseDate) { ApplicationArea = All; Caption = 'Base Date'; }
                    field(DateFilter; SystemFilter."Date Filter")
                    {
                        Caption = 'Date Filter';
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            FilterTokens: Codeunit "Filter Tokens";
                            DateFilter: Text;
                        begin
                            DateFilter := SystemFilter."Date Filter";
                            FilterTokens.MakeDateFilter(DateFilter);
                            SystemFilter."Date Filter" := CopyStr(DateFilter, 1, MaxStrLen(SystemFilter."Date Filter"));
                        end;
                    }
                    field(ShowTotalsField; ShowTotals) { ApplicationArea = All; Caption = 'Show Totals'; }
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

    trigger OnPostReport()
    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        GLEntry: Record "G/L Entry";
        RefreshGLAnalysisEntries: Report lvnRefreshGLAnalysisEntries;
        LoanValuesView: Page lvnLoanValuesView;
    begin
        GLEntry.Reset();
        GLEntry.FindLast();
        if GLEntry."Entry No." > LoanVisionSetup."Last Analysis Entry No." then
            if Confirm(AnalysisEntryUpdatePromptQst, true) then begin
                Clear(RefreshGLAnalysisEntries);
                RefreshGLAnalysisEntries.UseRequestPage(false);
                RefreshGLAnalysisEntries.RunModal();
            end;
        Clear(LoanValuesView);
        LoanValuesView.SetParams(ColSchemaCode, BaseDate, SystemFilter, ShowTotals);
        LoanValuesView.RunModal();
    end;

    var
        SystemFilter: Record lvnSystemCalculationFilter;
        BaseDate: Enum lvnLoanLevelReportBaseDate;
        ShowTotals: Boolean;
        ColSchemaCode: Code[20];
        AnalysisEntryUpdatePromptQst: Label 'Analysis entries required to view this report are outdated. Do you want to refresh them?';
}