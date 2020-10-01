page 14135201 lvngPerformanceRowSchemaLines
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
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Row Type"; Rec."Row Type") { ApplicationArea = All; }
                field("Row Style"; Rec."Row Style") { ApplicationArea = All; }
                field("Hide Zero Line"; Rec."Hide Zero Line") { ApplicationArea = All; }
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
        PerformanceRowSchemaLine.SetRange("Schema Code", Rec."Schema Code");
        PerformanceRowSchemaLine.SetRange("Column No.", 1);
        if PerformanceRowSchemaLine.FindLast() then
            Rec."Line No." := PerformanceRowSchemaLine."Line No." + 10
        else
            Rec."Line No." := 10;
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
            RowLine."Schema Code" := Rec."Schema Code";
            RowLine."Line No." := Rec."Line No.";
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