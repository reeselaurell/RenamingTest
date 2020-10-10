pageextension 14135139 lvngPurchInvoiceSubform extends "Purch. Invoice Subform"
{
    layout
    {

        // Add changes to page layout here
        addlast(PurchDetailLine)
        {
            field(lvngReasonCode; Rec.lvngReasonCode) { ApplicationArea = All; Visible = false; }
            field(lvngServicingType; Rec.lvngServicingType) { ApplicationArea = All; }
            field(lvngLoanNo; Rec.lvngLoanNo) { ApplicationArea = All; }
            field(BorrowerName; BorrowerName) { Caption = 'Borrower Name'; ApplicationArea = All; Editable = false; }
            field(lvngDeliveryState; Rec.lvngDeliveryState) { ApplicationArea = All; }
            field(lvngUseSalesTax; Rec.lvngUseSalesTax) { ApplicationArea = All; }
            field(lvngShortcutDimension1Name; Rec.lvngShortcutDimension1Name) { ApplicationArea = All; }
            field(lvngShortcutDimension2Name; Rec.lvngShortcutDimension2Name) { ApplicationArea = All; }
        }

        modify(Control39) { Visible = false; }
        modify("Location Code") { Visible = false; }
        modify("Line Discount %") { Visible = false; }
        modify("Unit of Measure Code") { Visible = false; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Qty. Assigned") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("Deferral Code") { Visible = true; }
        modify("Use Tax") { Visible = true; }
        modify("Tax Liable") { Visible = true; }
        modify("Line No.") { Visible = true; }
        modify("IRS 1099 Liable") { Visible = true; }
        modify("Document No.") { Visible = true; }
    }

    var
        lvngLoanManagement: Codeunit lvngLoanManagement;
        BorrowerName: Text;


    trigger OnAfterGetRecord()
    var
        lvngLoan: Record lvngLoan;
    begin
        Clear(BorrowerName);
        if Rec.lvngLoanNo <> '' then
            if lvngLoan.Get(Rec.lvngLoanNo) then
                BorrowerName := lvngLoanManagement.GetBorrowerName(lvngLoan);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"G/L Account";
    end;
}