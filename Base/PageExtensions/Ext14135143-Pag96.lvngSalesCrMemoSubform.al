pageextension 14135143 lvngSalesCrSubform extends "Sales Cr. Memo Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(lvngLoanNo; Rec.lvngLoanNo) { ApplicationArea = All; }
            field(lvngReasonCode; Rec.lvngReasonCode) { ApplicationArea = All; Visible = false; }
            field(BorrowerName; BorrowerName) { Caption = 'Borrower Name'; ApplicationArea = All; Editable = false; }
            field(lvngServicingType; Rec.lvngServicingType) { ApplicationArea = All; }
            field(lvngShortcutDimension1Name; Rec.lvngShortcutDimension1Name) { ApplicationArea = All; }
            field(lvngShortcutDimension2Name; Rec.lvngShortcutDimension2Name) { ApplicationArea = All; }
            field(lvngDeliveryState; Rec.lvngDeliveryState) { ApplicationArea = All; }
            field(lvngUseSalesTax; Rec.lvngUseSalesTax) { ApplicationArea = All; }
        }
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