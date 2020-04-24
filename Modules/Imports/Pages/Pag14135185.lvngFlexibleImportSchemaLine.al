page 14135185 lvngFlexibleImportSchemaLine
{
    PageType = ListPart;
    SourceTable = lvngFlexibleImportSchemaLine;
    Caption = 'Flexible Import Schema Line';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Amount Column No."; "Amount Column No.") { ApplicationArea = All; }
                field("Account Type"; "Account Type") { ApplicationArea = All; }
                field("Account No."; "Account No.") { ApplicationArea = All; }
                field("Custom Description"; "Custom Description") { ApplicationArea = All; }
                field("Bal. Account Type"; "Bal. Account Type") { ApplicationArea = All; }
                field("Bal. Account No."; "Bal. Account No.") { ApplicationArea = All; }
                field("Dimension Validation Rule 1"; "Dimension Validation Rule 1") { ApplicationArea = All; Caption = 'First Take Dim. Value'; }
                field("Dimension Validation Rule 2"; "Dimension Validation Rule 2") { ApplicationArea = All; Caption = 'Then Take Dim. Value'; }
                field("Dimension Validation Rule 3"; "Dimension Validation Rule 3") { ApplicationArea = All; Caption = 'Finally Take Dim. Value'; }
                field("Reverse Amount"; "Reverse Amount") { ApplicationArea = All; }
                field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; }
                field("Validate From Hierarchy"; "Validate From Hierarchy") { ApplicationArea = All; }
                field("Servicing Type"; "Servicing Type") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Conditions)
            {
                Caption = 'Conditions';
                ApplicationArea = All;
                Image = Planning;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page lvngFlexImportSchemaConditions;
                RunPageView = sorting("Schema Code", "Amount Column No.", "Condition Line No.");
                RunPageLink = "Schema Code" = field("Schema Code"), "Amount Column No." = field("Amount Column No.");
            }
        }
    }
}