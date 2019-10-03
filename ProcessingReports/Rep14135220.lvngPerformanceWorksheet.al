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
                    field(RowSchemaCode; RowSchemaCode) { Caption = 'Row Schema'; ApplicationArea = All; TableRelation = lvngPerformanceRowSchema; NotBlank = true; }
                    field(BandSchemaCode; BandSchemaCode) { Caption = 'Band Schema'; ApplicationArea = All; TableRelation = lvngPeriodPerfBandSchema; NotBlank = true; }
                    field(AsOfDate; AsOfDate) { Caption = 'As of Date'; ApplicationArea = All; NotBlank = true; }
                }
                group(Dimensions)
                {
                    field(Dim1Filter; Dim1Filter) { ApplicationArea = All; Caption = 'Dimension 1 Filter'; CaptionClass = '1,3,1'; }
                    field(Dim2Filter; Dim2Filter) { ApplicationArea = All; Caption = 'Dimension 2 Filter'; CaptionClass = '1,3,2'; }
                    field(Dim3Filter; Dim3Filter) { ApplicationArea = All; Caption = 'Dimension 3 Filter'; CaptionClass = '1,4,3'; }
                    field(Dim4Filter; Dim4Filter) { ApplicationArea = All; Caption = 'Dimension 4 Filter'; CaptionClass = '1,4,4'; }
                    field(BusinessUnitFilter; BusinessUnitFilter) { ApplicationArea = All; Caption = 'Business Unit Filter'; }
                }
            }
        }
    }

    trigger OnPostReport()
    var
        PerformanceWorksheet: Page lvngPerformanceWorksheet;
    begin
        Clear(PerformanceWorksheet);
        PerformanceWorksheet.SetParams(RowSchemaCode, BandSchemaCode, AsOfDate, Dim1Filter, Dim2Filter, Dim3Filter, Dim4Filter, BusinessUnitFilter);
        PerformanceWorksheet.RunModal();
    end;

    var
        AsOfDate: Date;
        RowSchemaCode: Code[20];
        BandSchemaCode: Code[20];
        Dim1Filter: Code[20];
        Dim2Filter: Code[20];
        Dim3Filter: Code[20];
        Dim4Filter: Code[20];
        BusinessUnitFilter: Code[20];

}