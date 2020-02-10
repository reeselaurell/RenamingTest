pageextension 14135142 lvngPostedPurchCrMemoSubform extends "Posted Purch. Cr. Memo Subform"
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