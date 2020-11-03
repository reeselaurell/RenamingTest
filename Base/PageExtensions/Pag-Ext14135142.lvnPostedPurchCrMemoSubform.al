pageextension 14135142 "lvnPostedPurchCrMemoSubform" extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(lvnReasonCode; Rec.lvnReasonCode) { ApplicationArea = All; }
            field(lvnLoanNo; Rec.lvnLoanNo) { ApplicationArea = All; }
            field(lvnUseSalesTax; Rec.lvnUseSalesTax) { ApplicationArea = All; }
            field(lvnDeliveryState; Rec.lvnDeliveryState) { ApplicationArea = All; }
        }
    }
}