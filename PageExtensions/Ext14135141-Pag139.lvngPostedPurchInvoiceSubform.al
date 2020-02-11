pageextension 14135141 lvngPostedPurchInvoiceSubform extends "Posted Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(lvngReasonCode; lvngReasonCode) { ApplicationArea = All; }
            field(lvngLoanNo; lvngLoanNo) { ApplicationArea = All; }
            field(lvngUseSalesTax; lvngUseSalesTax) { ApplicationArea = All; }
            field(lvngDeliveryState; lvngDeliveryState) { ApplicationArea = All; }
        }
    }
}