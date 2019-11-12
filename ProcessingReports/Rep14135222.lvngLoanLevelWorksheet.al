report 14135222 lvngLoanLevelWorksheet
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
                    field(ColSchemaCode; ColSchemaCode) { Caption = 'Column Schema'; ApplicationArea = All; }
                    field(BaseDate; BaseDate) { ApplicationArea = All; Caption = 'Base Date'; }
                    field(DateFilter; SystemFilter."Date Filter")
                    {
                        Caption = 'Date Filter';
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            FilterTokens: Codeunit "Filter Tokens";
                        begin
                            FilterTokens.MakeDateFilter(SystemFilter."Date Filter");
                        end;
                    }
                    field(ShowTotals; ShowTotals) { ApplicationArea = All; Caption = 'Show Totals'; }
                }
                group(Dimensions)
                {
                    Caption = 'Dimension Filters';

                    field(Dim1Filter; SystemFilter."Shortcut Dimension 1") { ApplicationArea = All; Caption = 'Dimension 1 Filter'; CaptionClass = '1,3,1'; }
                    field(Dim2Filter; SystemFilter."Shortcut Dimension 2") { ApplicationArea = All; Caption = 'Dimension 2 Filter'; CaptionClass = '1,3,2'; }
                    field(Dim3Filter; SystemFilter."Shortcut Dimension 3") { ApplicationArea = All; Caption = 'Dimension 3 Filter'; CaptionClass = '1,4,3'; }
                    field(Dim4Filter; SystemFilter."Shortcut Dimension 4") { ApplicationArea = All; Caption = 'Dimension 4 Filter'; CaptionClass = '1,4,4'; }
                    field(BusinessUnitFilter; SystemFilter."Business Unit") { ApplicationArea = All; Caption = 'Business Unit Filter'; }
                }
            }
        }
    }

    var
        SystemFilter: Record lvngSystemCalculationFilter;
        BaseDate: Enum lvngLoanLevelReportBaseDate;
        ShowTotals: Boolean;
        ColSchemaCode: Code[20];

    trigger OnPostReport()
    var
        LoanValuesView: Page lvngLoanValuesView;
    begin
        Clear(LoanValuesView);
        LoanValuesView.SetParams(ColSchemaCode, BaseDate, SystemFilter, ShowTotals);
        LoanValuesView.RunModal();
    end;
}