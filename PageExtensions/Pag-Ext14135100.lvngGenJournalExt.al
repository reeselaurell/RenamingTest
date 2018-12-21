pageextension 14135100 "lvngGenJournalExt" extends "General Journal"//MyTargetPageId
{
    layout
    {
        modify(ShortcutDimCode3)
        {
            Visible = true;
        }
        modify(ShortcutDimCode4)
        {
            Visible = true;
        }
        modify(ShortcutDimCode5)
        {
            Visible = true;
        }
        modify(ShortcutDimCode6)
        {
            Visible = true;
        }
        modify(ShortcutDimCode7)
        {
            Visible = true;
        }
        modify(ShortcutDimCode8)
        {
            Visible = true;
        }

        addlast(Control1)
        {
            field(lvngLoanNo; lvngLoanNo)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {

    }

}