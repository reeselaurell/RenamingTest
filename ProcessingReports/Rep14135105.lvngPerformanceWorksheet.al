report 14135105 lvngPerformanceWorksheet
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Performance Worksheet';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    field(RowSchemaCode; RowSchemaCode) { Caption = 'Row Schema'; ApplicationArea = All; TableRelation = lvngRowPerformanceSchema; }
                    field(ColSchemaCode; ColSchemaCode) { Caption = 'Column Schema'; ApplicationArea = All; }
                    field(AsOfDate; AsOfDate) { Caption = 'As of Date'; ApplicationArea = All; }
                }
                group(Dimensions)
                {
                    field(Dim1Filter; Dim1Filter) { ApplicationArea = All; Caption = 'Dimension 1 Filter'; CaptionClass = '1,3,1'; }
                    field(Dim2Filter; Dim1Filter) { ApplicationArea = All; Caption = 'Dimension 2 Filter'; CaptionClass = '1,3,2'; }
                    field(Dim3Filter; Dim1Filter) { ApplicationArea = All; Caption = 'Dimension 3 Filter'; CaptionClass = '1,2,3'; }
                    field(Dim4Filter; Dim1Filter) { ApplicationArea = All; Caption = 'Dimension 4 Filter'; CaptionClass = '1,2,4'; }
                    field(BusinessUnitFilter; BusinessUnitFilter) { ApplicationArea = All; Caption = 'Business Unit Filter'; }
                }
            }
        }
    }

    var
        AsOfDate: Date;
        RowSchemaCode: Code[20];
        ColSchemaCode: Code[20];
        Dim1Filter: Code[20];
        Dim2Filter: Code[20];
        Dim3Filter: Code[20];
        Dim4Filter: Code[20];
        BusinessUnitFilter: Code[20];

}