page 14135161 lvngPerformanceSchema
{
    PageType = List;
    SourceTable = lvngRowPerformanceSchema;
    UsageCategory = Administration;
    Caption = 'Performance Schema';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Schema Type"; "Schema Type") { ApplicationArea = All; }
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
                RunObject = page lvngPerformanceSchemaFields;
                RunPageView = sorting("Performance Schema Code", "Line No.") order(ascending);
                RunPageLink = "Performance Schema Code" = field(Code);
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
                    FromRecord: Record lvngRowPerformanceSchema;
                    FromRecordLine: Record lvngPerformanceSchemaLine;
                    ToRecordLine: Record lvngPerformanceSchemaLine;
                begin
                    if Page.RunModal(0, FromRecord) = Action::LookupOK then begin
                        FromRecordLine.Reset();
                        FromRecordLine.SetRange("Performance Schema Code", FromRecord.Code);
                        FromRecordLine.FindSet();
                        repeat
                            ToRecordLine := FromRecordLine;
                            ToRecordLine."Performance Schema Code" := Code;
                            ToRecordLine.Insert();
                        until FromRecordLine.Next() = 0;
                    end;
                end;
            }

        }
    }
}