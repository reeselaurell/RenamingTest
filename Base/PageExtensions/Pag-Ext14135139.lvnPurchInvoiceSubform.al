pageextension 14135139 "lvnPurchInvoiceSubform" extends "Purch. Invoice Subform"
{
    layout
    {

        // Add changes to page layout here
        addlast(PurchDetailLine)
        {
            field(lvnReasonCode; Rec.lvnReasonCode) { ApplicationArea = All; Visible = false; }
            field(lvnServicingType; Rec.lvnServicingType) { ApplicationArea = All; }
            field(lvnLoanNo; Rec.lvnLoanNo) { ApplicationArea = All; }
            field(BorrowerName; BorrowerName) { Caption = 'Borrower Name'; ApplicationArea = All; Editable = false; }
            field(lvnDeliveryState; Rec.lvnDeliveryState) { ApplicationArea = All; }
            field(lvnUseSalesTax; Rec.lvnUseSalesTax) { ApplicationArea = All; }
            field(lvnShortcutDimension1Name; Rec.lvnShortcutDimension1Name) { ApplicationArea = All; }
            field(lvnShortcutDimension2Name; Rec.lvnShortcutDimension2Name) { ApplicationArea = All; }
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
        lvnLoanManagement: Codeunit lvnLoanManagement;
        BorrowerName: Text;


    trigger OnAfterGetRecord()
    var
        lvnLoan: Record lvnLoan;
    begin
        Clear(BorrowerName);
        if Rec.lvnLoanNo <> '' then
            if lvnLoan.Get(Rec.lvnLoanNo) then
                BorrowerName := lvnLoanManagement.GetBorrowerName(lvnLoan);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"G/L Account";
    end;
}