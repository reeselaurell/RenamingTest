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
                field(Code; lvngCode)
                {
                    ApplicationArea = All;
                }

                field(Description; lvngDescription)
                {
                    ApplicationArea = All;
                }

                field(ShowInRoleCenter; lvngShowInRolecenter)
                {
                    ApplicationArea = All;
                }




            }
        }
    }
}