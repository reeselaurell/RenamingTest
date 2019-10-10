page 50000 Test
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

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
}