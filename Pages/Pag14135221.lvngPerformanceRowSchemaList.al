page 14135221 lvngPerformanceRowSchemaList
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
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Schema Type"; "Schema Type") { ApplicationArea = All; }
                field("Column Schema"; "Column Schema") { ApplicationArea = All; }
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
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RowLine: Record lvngPerformanceRowSchemaLine;
                    RowLines: Page lvngPerformanceRowSchemaLines;
                begin
                    TestField("Column Schema");
                    Clear(RowLines);
                    RowLines.SetColumnSchemaCode("Column Schema");
                    RowLine.Reset();
                    RowLine.SetRange("Schema Code", Code);
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
                            ToRecordLine."Schema Code" := Code;
                            ToRecordLine.Insert();
                        until FromRecordLine.Next() = 0;
                    end;
                end;
            }

        }
    }
}