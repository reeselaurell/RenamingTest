page 14135200 lvngPerformanceRowSchemaList
{
    PageType = List;
    SourceTable = lvngPerformanceRowSchema;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Performance Row Schema List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Schema Type"; Rec."Schema Type") { ApplicationArea = All; }
                field("Column Schema"; Rec."Column Schema") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SchemaLines)
            {
                Caption = 'Schema Lines';
                ApplicationArea = All;
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RowLine: Record lvngPerformanceRowSchemaLine;
                    RowLines: Page lvngPerformanceRowSchemaLines;
                begin
                    Rec.TestField("Column Schema");
                    Clear(RowLines);
                    RowLines.SetColumnSchemaCode(Rec."Column Schema");
                    RowLine.Reset();
                    RowLine.SetRange("Schema Code", Rec.Code);
                    RowLine.SetRange("Column No.", 1);
                    RowLines.SetTableView(RowLine);
                    RowLines.Run();
                end;
            }

            action(CopyFrom)
            {
                Caption = 'Copy From';
                Image = CopyToTask;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FromRecord: Record lvngPerformanceRowSchema;
                    FromRecordLine: Record lvngPerformanceRowSchemaLine;
                    ToRecordLine: Record lvngPerformanceRowSchemaLine;
                begin
                    if Page.RunModal(0, FromRecord) = Action::LookupOK then begin
                        FromRecordLine.Reset();
                        FromRecordLine.SetRange("Schema Code", FromRecord.Code);
                        FromRecordLine.FindSet();
                        repeat
                            ToRecordLine := FromRecordLine;
                            ToRecordLine."Schema Code" := Rec.Code;
                            ToRecordLine.Insert();
                        until FromRecordLine.Next() = 0;
                    end;
                end;
            }

        }
    }
}