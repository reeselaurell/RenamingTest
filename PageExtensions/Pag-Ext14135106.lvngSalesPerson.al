pageextension 14135106 "lvngSalesPerson" extends "Salespersons/Purchasers" //MyTargetPageId
{
    layout
    {
        modify("Commission %")
        {
            Visible = false;
        }

    }
}