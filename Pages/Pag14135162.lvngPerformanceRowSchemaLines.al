page 14135162 lvngPerformanceRowSchemaLines
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
                field("Column No."; "Column No.")
                {
                    ApplicationArea = All;
                    Lookup = true;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ColPerformanceSchemaLine: Record lvngPerformanceColSchemaLine;
                        ColPerformanceSchemaLines: Page lvngPerformanceColSchemaLines;
                    begin
                        ColPerformanceSchemaLine.Reset();
                        ColPerformanceSchemaLine.SetRange("Schema Code", UnderlyingColumnSchemaCode);
                        Clear(ColPerformanceSchemaLines);
                        ColPerformanceSchemaLines.SetTableView(ColPerformanceSchemaLine);
                        ColPerformanceSchemaLines.LookupMode(true);
                        if ColPerformanceSchemaLines.RunModal() = Action::LookupOK then begin
                            ColPerformanceSchemaLines.GetRecord(ColPerformanceSchemaLine);
                            Text := Format(ColPerformanceSchemaLine."Column No.");
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field(Description; Description) { ApplicationArea = All; }
                field("Calculation Unit Code"; "Calculation Unit Code") { ApplicationArea = All; LookupPageId = lvngCalculationUnitList; }
                field("Number Format Code"; "Number Format Code") { ApplicationArea = All; LookupPageId = lvngNumberFormatList; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            /*
            action(Details)
            {
                Image = FiledOverview;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PerfSchemaFieldCard: Page lvngPerformanceSchemaFieldCard;
                begin
                    Clear(PerfSchemaFieldCard);
                    PerfSchemaFieldCard.SetRecord(Rec);
                    PerfSchemaFieldCard.RunModal();
                end;
            }
            */
        }
    }

    var
        UnderlyingColumnSchemaCode: Code[20];

    procedure SetColumnSchemaCode(SchemaCode: Code[20])
    begin
        UnderlyingColumnSchemaCode := SchemaCode;
    end;
}