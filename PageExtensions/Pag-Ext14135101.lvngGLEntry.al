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
            field(lvngShortcutDimension3Code; "Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
            }
            field(lvngShortcutDimension4Code; "Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
            }
            field(lvngShortcutDimension5Code; "Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
            }
            field(lvngShortcutDimension6Code; "Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
            }
            field(lvngShortcutDimension7Code; "Shortcut Dimension 7 Code")
            {
                ApplicationArea = All;
            }
            field(lvngShortcutDimension8Code; "Shortcut Dimension 8 Code")
            {
                ApplicationArea = All;
            }
            field(lvngLoanNo; "Loan No.")
            {
                ApplicationArea = All;
            }
            field(lvngServicingType; "Servicing Type")
            {
                ApplicationArea = All;
            }
            field(lvngBorrowerSearchName; "Borrower Search Name")
            {
                ApplicationArea = All;
            }
            field(lvngEntryDate; "Entry Date")
            {
                ApplicationArea = All;
            }
            field(lvngVoided; Voided)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
    }
}