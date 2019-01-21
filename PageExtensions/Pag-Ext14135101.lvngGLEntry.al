pageextension 14135101 "lvngGLEntry" extends "General Ledger Entries" //MyTargetPageId
{
    layout
    {
        modify("Global Dimension 1 Code")
        {
            Visible = true;
        }

        modify("Global Dimension 2 Code")
        {
            Visible = true;
        }
        addlast(Control1)
        {
            field(lvngShortcutDimension3Code; lvngShortcutDimension3Code)
            {
                ApplicationArea = All;
            }
            field(lvngShortcutDimension4Code; lvngShortcutDimension4Code)
            {
                ApplicationArea = All;
            }
            field(lvngShortcutDimension5Code; lvngShortcutDimension5Code)
            {
                ApplicationArea = All;
            }
            field(lvngShortcutDimension6Code; lvngShortcutDimension6Code)
            {
                ApplicationArea = All;
            }
            field(lvngShortcutDimension7Code; lvngShortcutDimension7Code)
            {
                ApplicationArea = All;
            }
            field(lvngShortcutDimension8Code; lvngShortcutDimension8Code)
            {
                ApplicationArea = All;
            }
            field(lvngLoanNo; lvngLoanNo)
            {
                ApplicationArea = All;
            }
            field(lvngEntryDate; lvngEntryDate)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
    }
}