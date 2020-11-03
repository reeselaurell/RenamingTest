pageextension 14135105 "lvnSalesInvoiceSubpage" extends "Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(lvnLoanNo; Rec.lvnLoanNo) { ApplicationArea = All; }
            field(lvnReasonCode; Rec.lvnReasonCode) { ApplicationArea = All; Visible = false; }
            field(BorrowerName; BorrowerName) { Caption = 'Borrower Name'; ApplicationArea = All; Editable = false; }
            field(lvnServicingType; Rec.lvnServicingType) { ApplicationArea = All; }
            field(lvnShortcutDimension1Name; Rec.lvnShortcutDimension1Name) { ApplicationArea = All; }
            field(lvnShortcutDimension2Name; Rec.lvnShortcutDimension2Name) { ApplicationArea = All; }
            field(lvnDeliveryState; Rec.lvnDeliveryState) { ApplicationArea = All; }
            field(lvnUseSalesTax; Rec.lvnUseSalesTax) { ApplicationArea = All; }
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
        modify("Tax Liable") { Visible = true; }
        modify("Line No.") { Visible = true; }
        modify("Document No.") { Visible = true; }
    }

    var
        BorrowerName: Text;
        lvnLoanManagement: Codeunit lvnLoanManagement;

    trigger OnAfterGetRecord()
    var
        lvnLoan: Record lvnLoan;
    begin
        BorrowerName := '';
        if Rec.lvnLoanNo <> '' then
            if lvnLoan.Get(Rec.lvnLoanNo) then
                BorrowerName := lvnLoanManagement.GetBorrowerName(lvnLoan);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"G/L Account";
    end;
}