page 50000 Test
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngExpressionLine;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Expression Code"; "Expression Code") { ApplicationArea = All; }
                field("Consumer Id"; "Consumer Id") { ApplicationArea = All; }
                field("Line No."; "Line No.") { ApplicationArea = All; }
                field("Split No."; "Split No.") { ApplicationArea = All; }
                field("Left Side"; "Left Side") { ApplicationArea = All; }
                field(Comparison; Comparison) { ApplicationArea = All; }
                field("Right Side"; "Right Side") { ApplicationArea = All; }
            }
        }
    }

    /*
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(FieldIdx; FieldIdx)
                {
                    trigger OnValidate()
                    var
                        ExcelExport: Codeunit lvngExcelExport;
                    begin
                        FieldName := ExcelExport.GetExcelColumnName(FieldIdx);
                    end;
                }
                field(FieldName; FieldName) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        FieldIdx: Integer;
        FieldName: Text;
    */
}