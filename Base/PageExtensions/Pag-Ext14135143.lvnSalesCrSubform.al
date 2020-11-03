pageextension 14135143 "lvnSalesCrSubform" extends "Sales Cr. Memo Subform"
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