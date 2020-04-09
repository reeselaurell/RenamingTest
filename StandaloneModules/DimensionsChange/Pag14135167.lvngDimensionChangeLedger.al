page 14135167 lvngDimensionChangeLedger
{
    Caption = 'Dimension Change Ledger';
    PageType = List;
    SourceTable = lvngDimensionChangeLedgerEntry;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.") { ApplicationArea = All; }
                field("Old Dimension 1 Code"; "Old Dimension 1 Code") { ApplicationArea = All; }
                field("New Dimension 1 Code"; "New Dimension 1 Code") { ApplicationArea = All; }
                field("Old Dimension 2 Code"; "Old Dimension 2 Code") { ApplicationArea = All; }
                field("New Dimension 2 Code"; "New Dimension 2 Code") { ApplicationArea = All; }
                field("Old Dimension 3 Code"; "Old Dimension 3 Code") { ApplicationArea = All; }
                field("New Dimension 3 Code"; "New Dimension 3 Code") { ApplicationArea = All; }
                field("Old Dimension 4 Code"; "Old Dimension 4 Code") { ApplicationArea = All; }
                field("New Dimension 4 Code"; "New Dimension 4 Code") { ApplicationArea = All; }
                field("Old Dimension 5 Code"; "Old Dimension 5 Code") { ApplicationArea = All; }
                field("New Dimension 5 Code"; "New Dimension 5 Code") { ApplicationArea = All; }
                field("Old Dimension 6 Code"; "Old Dimension 6 Code") { ApplicationArea = All; }
                field("New Dimension 6 Code"; "New Dimension 6 Code") { ApplicationArea = All; }
                field("Old Dimension 7 Code"; "Old Dimension 7 Code") { ApplicationArea = All; }
                field("New Dimension 7 Code"; "New Dimension 7 Code") { ApplicationArea = All; }
                field("Old Dimension 8 Code"; "Old Dimension 8 Code") { ApplicationArea = All; }
                field("New Dimension 8 Code"; "New Dimension 8 Code") { ApplicationArea = All; }
                field("Old Business Unit Code"; "Old Business Unit Code") { ApplicationArea = All; }
                field("New Business Unit Code"; "New Business Unit Code") { ApplicationArea = All; }
                field("Old Loan No."; "Old Loan No.") { ApplicationArea = All; }
                field("New Loan No."; "New Loan No.") { ApplicationArea = All; }
                field("Old Dimension Set ID"; "Old Dimension Set ID") { ApplicationArea = All; }
                field("New Dimension Set ID"; "New Dimension Set ID") { ApplicationArea = All; }
            }
        }
    }
}