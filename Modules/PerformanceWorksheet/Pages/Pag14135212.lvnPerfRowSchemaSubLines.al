page 14135212 "lvnPerfRowSchemaSubLines"
{
    PageType = ListPart;
    SourceTable = lvnPerformanceRowSchemaLine;
    Caption = 'Performance Row Columns';
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Description; ColumnDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Column';
                    Editable = false;
                }
                field("Calculation Unit Code"; Rec."Calculation Unit Code")
                {
                    ApplicationArea = All;
                    LookupPageId = lvnCalculationUnitList;
                }
                field("Number Format Code"; Rec."Number Format Code")
                {
                    ApplicationArea = All;
                    LookupPageId = lvnNumberFormatList;
                }
                field("Style Code"; Rec."Style Code")
                {
                    ApplicationArea = All;
                    LookupPageId = lvnStyleList;
                }
                field("Neg. Style Code"; Rec."Neg. Style Code")
                {
                    ApplicationArea = All;
                    LookupPageId = lvnStyleList;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ColSchemaLine: Record lvnPerformanceColSchemaLine;
    begin
        if ColSchemaLine.Get(UnderlyingColumnSchemaCode, Rec."Column No.") then
            ColumnDescription := ColSchemaLine.Description
        else
            ColumnDescription := '';
    end;

    var
        ColumnDescription: Text;
        UnderlyingColumnSchemaCode: Code[20];

    procedure SetColumnSchemaCode(SchemaCode: Code[20])
    begin
        UnderlyingColumnSchemaCode := SchemaCode;
    end;
}