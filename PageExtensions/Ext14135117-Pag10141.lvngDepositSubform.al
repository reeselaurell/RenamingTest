pageextension 14135117 lvngDepositSubform extends "Deposit Subform"
{
    layout
    {
        addlast(Control1020000)
        {
            field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
            field(lvngLoanNo; "Loan No.") { ApplicationArea = All; }
        }

        modify("ShortcutDimCode[3]") { Visible = true; }
        modify("ShortcutDimCode[4]") { Visible = true; }
        modify("ShortcutDimCode[5]") { Visible = true; }
        modify("ShortcutDimCode[6]") { Visible = true; }
        modify("ShortcutDimCode[7]") { Visible = true; }
        modify("ShortcutDimCode[8]") { Visible = true; }
        modify("Reason Code") { Visible = true; }
        modify("Credit Amount") { Visible = true; }
        modify("Debit Amount") { Visible = true; }
        modify(Amount) { Visible = true; }
    }
}