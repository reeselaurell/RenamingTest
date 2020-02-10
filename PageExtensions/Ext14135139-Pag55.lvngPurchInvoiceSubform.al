pageextension 14135139 lvngPurchInvoiceSubform extends "Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addlast(PurchDetailLine)
        {
            field(lvngReasonCode; lvngReasonCode) { ApplicationArea = All; }
            field(lvngLoanNo; lvngLoanNo) { ApplicationArea = All; }
            field(lvngUseSalesTax; lvngUseSalesTax) { ApplicationArea = All; }
            field(lvngDeliveryState; lvngDeliveryState) { ApplicationArea = All; }
        }
    }
}