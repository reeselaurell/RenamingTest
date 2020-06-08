pageextension 14135105 lvngSalesInvoiceSubpage extends "Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(lvngLoanNo; lvngLoanNo) { ApplicationArea = All; }
            field(lvngReasonCode; lvngReasonCode) { ApplicationArea = All; Visible = false; }
            field(BorrowerName; BorrowerName) { Caption = 'Borrower Name'; ApplicationArea = All; Editable = false; }
            field(lvngServicingType; lvngServicingType) { ApplicationArea = All; }
            field(lvngShortcutDimension1Name; lvngShortcutDimension1Name) { ApplicationArea = All; }
            field(lvngShortcutDimension2Name; lvngShortcutDimension2Name) { ApplicationArea = All; }
            field(lvngDeliveryState; lvngDeliveryState) { ApplicationArea = All; }
            field(lvngUseSalesTax; lvngUseSalesTax) { ApplicationArea = All; }
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