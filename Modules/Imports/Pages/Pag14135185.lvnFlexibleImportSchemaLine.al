page 14135185 "lvnFlexibleImportSchemaLine"
{
    PageType = ListPart;
    SourceTable = lvnFlexibleImportSchemaLine;
    Caption = 'Flexible Import Schema Line';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Amount Column No."; Rec."Amount Column No.")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Custom Description"; Rec."Custom Description")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                }
                field("Dimension Validation Rule 1"; Rec."Dimension Validation Rule 1")
                {
                    ApplicationArea = All;
                    Caption = 'First Take Dim. Value';
                }
                field("Dimension Validation Rule 2"; Rec."Dimension Validation Rule 2")
                {
                    ApplicationArea = All;
                    Caption = 'Then Take Dim. Value';
                }
                field("Dimension Validation Rule 3"; Rec."Dimension Validation Rule 3")
                {
                    ApplicationArea = All;
                    Caption = 'Finally Take Dim. Value';
                }
                field("Reverse Amount"; Rec."Reverse Amount")
                {
                    ApplicationArea = All;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                }
                field("Validate From Hierarchy"; Rec."Validate From Hierarchy")
                {
                    ApplicationArea = All;
                }
                field("Servicing Type"; Rec."Servicing Type")
                {
                    ApplicationArea = All;
                }
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
                RunObject = page lvnFlexImportSchemaConditions;
                RunPageView = sorting("Schema Code", "Amount Column No.", "Condition Line No.");
                RunPageLink = "Schema Code" = field("Schema Code"), "Amount Column No." = field("Amount Column No.");
            }
        }
    }
}