page 14135212 lvngPerfRowSchemaSubLines
{
    PageType = ListPart;
    SourceTable = lvngPerformanceRowSchemaLine;
    Caption = 'Performance Row Columns';
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Description; ColumnDescription) { ApplicationArea = All; Caption = 'Column'; Editable = false; }
                field("Calculation Unit Code"; "Calculation Unit Code") { ApplicationArea = All; LookupPageId = lvngCalculationUnitList; }
                field("Number Format Code"; "Number Format Code") { ApplicationArea = All; LookupPageId = lvngNumberFormatList; }
                field("Style Code"; "Style Code") { ApplicationArea = All; LookupPageId = lvngStyleList; }
                field("Neg. Style Code"; "Neg. Style Code") { ApplicationArea = All; LookupPageId = lvngStyleList; }
            }
        }
    }

    var
        ColumnDescription: Text;
        UnderlyingColumnSchemaCode: Code[20];

    trigger OnAfterGetRecord()
    var
        ColSchemaLine: Record lvngPerformanceColSchemaLine;
    begin
        if ColSchemaLine.Get(UnderlyingColumnSchemaCode, "Column No.") then
            ColumnDescription := ColSchemaLine.Description
        else
            ColumnDescription := '';
    end;

    procedure SetColumnSchemaCode(SchemaCode: Code[20])
    begin
        UnderlyingColumnSchemaCode := SchemaCode;
    end;
}