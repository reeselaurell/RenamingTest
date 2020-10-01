pageextension 14135142 lvngPostedPurchCrMemoSubform extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(lvngReasonCode; Rec.lvngReasonCode) { ApplicationArea = All; }
            field(lvngLoanNo; Rec.lvngLoanNo) { ApplicationArea = All; }
            field(lvngUseSalesTax; Rec.lvngUseSalesTax) { ApplicationArea = All; }
            field(lvngDeliveryState; Rec.lvngDeliveryState) { ApplicationArea = All; }
        }
    }
}