pageextension 14135143 lvngSalesCrSubform extends "Sales Cr. Memo Subform"
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
}