pagecustomization "lvnPurchCrMemoSubform" customizes "Purch. Cr. Memo Subform"
{
    layout
    {
        moveafter(Description; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; lvnShortcutDimension1Name)
        moveafter(lvnShortcutDimension1Name; "Shortcut Dimension 2 Code")
        moveafter("Shortcut Dimension 2 Code"; lvnShortcutDimension2Name)
        moveafter(lvnShortcutDimension2Name; lvnLoanNo)
        moveafter(lvnLoanNo; BorrowerName)
        moveafter("Line Amount"; ShortcutDimCode3)
        moveafter(ShortcutDimCode3; ShortcutDimCode4)
        moveafter(ShortcutDimCode4; ShortcutDimCode5)
        moveafter(ShortcutDimCode5; ShortcutDimCode6)
        moveafter(ShortcutDimCode6; ShortcutDimCode7)
        moveafter(ShortcutDimCode7; ShortcutDimCode8)
        movelast(Control1; "Use Tax")
        movebefore("Use Tax"; "Tax Liable")
        movebefore("Tax Liable"; "IRS 1099 Liable")
        movebefore("IRS 1099 Liable"; lvnUseSalesTax)
        movebefore(lvnUseSalesTax; lvnDeliveryState)
    }


}