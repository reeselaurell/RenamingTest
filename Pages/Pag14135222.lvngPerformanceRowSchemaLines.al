page 14135222 lvngPerformanceRowSchemaLines
{
    PageType = List;
    Caption = 'Performance Row Schema Lines';
    SourceTable = lvngPerformanceRowSchemaLine;
    DelayedInsert = true;
    AutoSplitKey = true;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Row Type"; "Row Type") { ApplicationArea = All; }
            }
            part(SubList; lvngPerfRowSchemaSubLines) { ApplicationArea = All; SubPageLink = "Schema Code" = field("Schema Code"), "Line No." = field("Line No."); }
        }
    }

    var
        UnderlyingColumnSchemaCode: Code[20];

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PerformanceRowSchemaLine: Record lvngPerformanceRowSchemaLine;
    begin
        PerformanceRowSchemaLine.Reset();
        PerformanceRowSchemaLine.SetRange("Schema Code", "Schema Code");
        PerformanceRowSchemaLine.SetRange("Column No.", 1);
        if PerformanceRowSchemaLine.FindLast() then
            "Line No." := PerformanceRowSchemaLine."Line No." + 10
        else
            "Line No." := 10;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        RowLine: Record lvngPerformanceRowSchemaLine;
        ColLine: Record lvngPerformanceColSchemaLine;
    begin
        ColLine.Reset();
        ColLine.SetRange("Schema Code", UnderlyingColumnSchemaCode);
        ColLine.FindSet();
        ColLine.TestField("Column No.", 1);
        while ColLine.Next() <> 0 do begin
            Clear(RowLine);
            RowLine."Schema Code" := "Schema Code";
            RowLine."Line No." := "Line No.";
            RowLine."Column No." := ColLine."Column No.";
            RowLine.Insert();
        end;
    end;

    procedure SetColumnSchemaCode(SchemaCode: Code[20])
    begin
        UnderlyingColumnSchemaCode := SchemaCode;
        CurrPage.SubList.Page.SetColumnSchemaCode(SchemaCode);
    end;
}