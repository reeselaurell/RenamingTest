pageextension 14135141 "lvnPostedPurchInvoiceSubform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(lvnReasonCode; Rec.lvnReasonCode)
            {
                ApplicationArea = All;
            }
            field(lvnLoanNo; Rec.lvnLoanNo)
            {
                ApplicationArea = All;
            }
            field(lvnUseSalesTax; Rec.lvnUseSalesTax)
            {
                ApplicationArea = All;
            }
            field(lvnDeliveryState; Rec.lvnDeliveryState)
            {
                ApplicationArea = All;
            }
        }
    }
}