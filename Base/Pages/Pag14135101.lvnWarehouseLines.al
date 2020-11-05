page 14135101 "lvnWarehouseLines"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnWarehouseLine;
    Caption = 'Loan Warehouse Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Show In Rolecenter"; Rec."Show In Rolecenter")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}