page 14135101 "lvngWarehouseLines"
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
                field(Code; Code)
                {
                    ApplicationArea = All;
                }

                field(Description; Description)
                {
                    ApplicationArea = All;
                }

                field(ShowInRoleCenter; "Show In Rolecenter")
                {
                    ApplicationArea = All;
                }




            }
        }
    }
}