pageextension 14135140 lvngPurchCrMemoSubform extends "Purch. Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(lvngReasonCode; lvngReasonCode) { ApplicationArea = All; Visible = false; }
            field(lvngLoanNo; lvngLoanNo) { ApplicationArea = All; }
            field(BorrowerName; BorrowerName) { Caption = 'Borrower Name'; ApplicationArea = All; }
            field(lvngUseSalesTax; lvngUseSalesTax) { ApplicationArea = All; }
            field(lvngDeliveryState; lvngDeliveryState) { ApplicationArea = All; }
            field(lnvgServicingType; lnvgServicingType) { ApplicationArea = All; }
            field(lvngShortcutDimension1Name; lvngShortcutDimension1Name) { ApplicationArea = All; }
            field(lvngShortcutDimension2Name; lvngShortcutDimension2Name) { ApplicationArea = All; }
        }
        modify(Control47) { Visible = false; }
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
        modify("IRS 1099 Liable") { Visible = true; }
    }

    var
        BorrowerName: Text[250];

    trigger OnAfterGetRecord()
    var
        Loan: Record lvngLoan;
    begin
        BorrowerName := '';
        if lvngLoanNo <> '' then
            if Loan.Get(lvngLoanNo) then
                BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::"G/L Account";
    end;
}