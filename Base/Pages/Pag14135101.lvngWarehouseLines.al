page 14135101 lvngWarehouseLines
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngWarehouseLine;
    Caption = 'Loan Warehouse Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Show In Rolecenter"; Rec."Show In Rolecenter") { ApplicationArea = All; }
            }
        }
    }
}