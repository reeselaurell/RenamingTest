page 14135235 lvngDimensionPerformanceView
{
    PageType = Worksheet;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    Caption = 'Dimension Performance View';

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                field(SchemaName; SchemaName) { ApplicationArea = All; Caption = 'View Name'; ShowCaption = false; Editable = false; }
                field(Dim1Filter; Dim1Filter) { ApplicationArea = All; Caption = 'Dimension 1 Filter'; Editable = false; Visible = Dim1Visible; CaptionClass = '1,3,1'; }
                field(Dim2Filter; Dim2Filter) { ApplicationArea = All; Caption = 'Dimension 2 Filter'; Editable = false; Visible = Dim2Visible; CaptionClass = '1,3,2'; }
                field(Dim3Filter; Dim3Filter) { ApplicationArea = All; Caption = 'Dimension 3 Filter'; Editable = false; Visible = Dim3Visible; CaptionClass = '1,2,3'; }
                field(Dim4Filter; Dim4Filter) { ApplicationArea = All; Caption = 'Dimension 4 Filter'; Editable = false; Visible = Dim4Visible; CaptionClass = '1,2,4'; }
                field(BusinessUnitFilter; BusinessUnitFilter) { ApplicationArea = All; Caption = 'Business Unit Filter'; Editable = false; Visible = BusinessUnitVisible; }
                field(DateFilter; DateFilter) { ApplicationArea = All; Caption = 'Date Filter'; Editable = false; }
            }
            usercontrol(DataGrid; DataGridControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    InitializeDataGrid();
                end;

                trigger CellClick(BandIndex: Integer; ColIndex: Integer; RowIndex: Integer)
                begin
                    ProcessCellClick(BandIndex, ColIndex, RowIndex);
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
                Caption = 'Excel Export';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::lvngXlsx);
                end;
            }
            action(PdfExport)
            {
                Caption = 'Pdf Export';
                Image = ExportFile;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::lvngPdf);
                end;
            }
            action(HtmlExport)
            {
                Caption = 'Html Export';
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;

                trigger OnAction()
                begin
                    ExportToExcel(GridExportMode::lvngHtml);
                end;
            }
        }
    }

    var
        RowSchema: Record lvngPerformanceRowSchema;
        ColSchema: Record lvngPerformanceColSchema;
        BandSchema: Record lvngPeriodPerfBandSchema;
        SchemaName: Text;
        Dim1Filter: Code[20];
        Dim2Filter: Code[20];
        Dim3Filter: Code[20];
        Dim4Filter: Code[20];
        BusinessUnitFilter: Code[20];
        Dim1Visible: Boolean;
        Dim2Visible: Boolean;
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;
        BusinessUnitVisible: Boolean;
        DateFilter: Text;
        RowSchemaCode: Code[20];
        BandSchemaCode: Code[20];
        GridExportMode: Enum lvngGridExportMode;

    procedure SetParams(RowSchema: Code[20]; BandSchema: Code[20]; DateRange: Text; Dim1Code: Code[20]; Dim2Code: Code[20]; Dim3Code: Code[20]; Dim4Code: Code[20]; BUCode: Code[20])
    begin
        RowSchemaCode := RowSchema;
        BandSchemaCode := BandSchema;
        BusinessUnitFilter := BUCode;
        Dim1Filter := Dim1Code;
        Dim2Filter := Dim2Code;
        Dim3Filter := Dim3Code;
        Dim4Filter := Dim4Code;
        BusinessUnitVisible := BUCode <> '';
        Dim1Visible := Dim1Code <> '';
        Dim2Visible := Dim2Code <> '';
        Dim3Visible := Dim3Code <> '';
        Dim4Visible := Dim4Code <> '';
        DateFilter := DateRange;
    end;

    local procedure InitializeDataGrid()
    begin
        Error('Not Implemented');
    end;

    local procedure ProcessCellClick(BandIndex: Integer; ColIndex: Integer; RowIndex: Integer)
    begin
        Error('Not Implemented');
    end;

    local procedure ExportToExcel(Mode: Enum lvngGridExportMode)
    begin
        Error('Not Implemented');
    end;
}