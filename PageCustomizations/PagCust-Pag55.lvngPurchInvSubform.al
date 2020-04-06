pagecustomization lvngPurchInvSubform customizes "Purch. Invoice Subform"
{
    layout
    {
        moveafter(Description; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; lvngShortcutDimension1Name)
        moveafter(lvngShortcutDimension1Name; "Shortcut Dimension 2 Code")
        moveafter("Shortcut Dimension 2 Code"; lvngShortcutDimension2Name)
        moveafter(lvngShortcutDimension2Name; lvngLoanNo)
        moveafter(lvngLoanNo; BorrowerName)
        moveafter("Line Amount"; ShortcutDimCode3)
        moveafter(ShortcutDimCode3; ShortcutDimCode4)
        moveafter(ShortcutDimCode4; ShortcutDimCode5)
        moveafter(ShortcutDimCode5; ShortcutDimCode6)
        moveafter(ShortcutDimCode6; ShortcutDimCode7)
        moveafter(ShortcutDimCode7; ShortcutDimCode8)
        movelast(PurchDetailLine; "Use Tax")
        movebefore("Use Tax"; "Tax Liable")
        movebefore("Tax Liable"; "Line No.")
        movebefore("Line No."; "IRS 1099 Liable")
        movebefore("IRS 1099 Liable"; "Document No.")
        movebefore("Document No."; lvngUseSalesTax)
    }
}