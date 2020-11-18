page 14135166 "lvnDimensionChangeLedger"
{
    Caption = 'Dimension Change Ledger';
    PageType = List;
    SourceTable = lvnDimensionChangeLedgerEntry;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field(GLAccountName; GLAccountName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'G/L Account Name';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Old Dimension 1 Code"; Rec."Old Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("New Dimension 1 Code"; Rec."New Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Old Dimension 2 Code"; Rec."Old Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("New Dimension 2 Code"; Rec."New Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Old Dimension 3 Code"; Rec."Old Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("New Dimension 3 Code"; Rec."New Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Old Dimension 4 Code"; Rec."Old Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("New Dimension 4 Code"; Rec."New Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Old Dimension 5 Code"; Rec."Old Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("New Dimension 5 Code"; Rec."New Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("Old Dimension 6 Code"; Rec."Old Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field("New Dimension 6 Code"; Rec."New Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field("Old Dimension 7 Code"; Rec."Old Dimension 7 Code")
                {
                    ApplicationArea = All;
                }
                field("New Dimension 7 Code"; Rec."New Dimension 7 Code")
                {
                    ApplicationArea = All;
                }
                field("Old Dimension 8 Code"; Rec."Old Dimension 8 Code")
                {
                    ApplicationArea = All;
                }
                field("New Dimension 8 Code"; Rec."New Dimension 8 Code")
                {
                    ApplicationArea = All;
                }
                field("Old Business Unit Code"; Rec."Old Business Unit Code")
                {
                    ApplicationArea = All;
                }
                field("New Business Unit Code"; Rec."New Business Unit Code")
                {
                    ApplicationArea = All;
                }
                field("Old Loan No."; Rec."Old Loan No.")
                {
                    ApplicationArea = All;
                }
                field("New Loan No."; Rec."New Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Old Dimension Set ID"; Rec."Old Dimension Set ID")
                {
                    ApplicationArea = All;
                }
                field("New Dimension Set ID"; Rec."New Dimension Set ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(GLAccountName);
        if GLAccount."No." <> Rec."G/L Account No." then
            if GLAccount.Get(Rec."G/L Account No.") then
                GLAccountName := GLAccount.Name;
    end;

    var
        GLAccount: Record "G/L Account";
        GLAccountName: Text;
}