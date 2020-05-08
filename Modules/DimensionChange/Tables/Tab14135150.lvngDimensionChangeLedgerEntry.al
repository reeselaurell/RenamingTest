table 14135150 lvngDimensionChangeLedgerEntry
{
    Caption = 'Dimension Change Ledger Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Change Set ID"; Guid) { Caption = 'Change Set ID'; DataClassification = CustomerContent; Editable = false; }
        field(2; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = CustomerContent; Editable = false; }
        field(10; "Old Dimension 1 Code"; Code[20]) { Caption = 'Old Dimension 1 Code'; DataClassification = CustomerContent; Editable = false; }
        field(11; "Old Dimension 2 Code"; Code[20]) { Caption = 'Old Dimension 2 Code'; DataClassification = CustomerContent; Editable = false; }
        field(12; "Old Dimension 3 Code"; Code[20]) { Caption = 'Old Dimension 3 Code'; DataClassification = CustomerContent; Editable = false; }
        field(13; "Old Dimension 4 Code"; Code[20]) { Caption = 'Old Dimension 4 Code'; DataClassification = CustomerContent; Editable = false; }
        field(14; "Old Dimension 5 Code"; Code[20]) { Caption = 'Old Dimension 5 Code'; DataClassification = CustomerContent; Editable = false; }
        field(15; "Old Dimension 6 Code"; Code[20]) { Caption = 'Old Dimension 6 Code'; DataClassification = CustomerContent; Editable = false; }
        field(16; "Old Dimension 7 Code"; Code[20]) { Caption = 'Old Dimension 7 Code'; DataClassification = CustomerContent; Editable = false; }
        field(17; "Old Dimension 8 Code"; Code[20]) { Caption = 'Old Dimension 8 Code'; DataClassification = CustomerContent; Editable = false; }
        field(18; "Old Dimension Set ID"; Integer) { Caption = 'Old Dimension Set ID'; DataClassification = CustomerContent; Editable = false; }
        field(19; "Old Business Unit Code"; Code[20]) { Caption = 'Old Business Unit Code'; DataClassification = CustomerContent; Editable = false; }
        field(20; "New Dimension 1 Code"; Code[20]) { Caption = 'New Dimension 1 Code'; DataClassification = CustomerContent; Editable = false; }
        field(21; "New Dimension 2 Code"; Code[20]) { Caption = 'New Dimension 2 Code'; DataClassification = CustomerContent; Editable = false; }
        field(22; "New Dimension 3 Code"; Code[20]) { Caption = 'New Dimension 3 Code'; DataClassification = CustomerContent; Editable = false; }
        field(23; "New Dimension 4 Code"; Code[20]) { Caption = 'New Dimension 4 Code'; DataClassification = CustomerContent; Editable = false; }
        field(24; "New Dimension 5 Code"; Code[20]) { Caption = 'New Dimension 5 Code'; DataClassification = CustomerContent; Editable = false; }
        field(25; "New Dimension 6 Code"; Code[20]) { Caption = 'New Dimension 6 Code'; DataClassification = CustomerContent; Editable = false; }
        field(26; "New Dimension 7 Code"; Code[20]) { Caption = 'New Dimension 7 Code'; DataClassification = CustomerContent; Editable = false; }
        field(27; "New Dimension 8 Code"; Code[20]) { Caption = 'New Dimension 8 Code'; DataClassification = CustomerContent; Editable = false; }
        field(28; "New Dimension Set ID"; Integer) { Caption = 'New Dimension Set ID'; DataClassification = CustomerContent; Editable = false; }
        field(29; "New Business Unit Code"; Code[20]) { Caption = 'New Business Unit Code'; DataClassification = CustomerContent; Editable = false; }
        field(50; "New Loan No."; Code[20]) { Caption = 'New Loan No.'; DataClassification = CustomerContent; }
        field(51; "Old Loan No."; Code[20]) { Caption = 'Old Loan No.'; DataClassification = CustomerContent; }
        field(100; Change; Boolean) { Caption = 'Change'; DataClassification = CustomerContent; }
        field(101; "G/L Account Name"; Text[50]) { Caption = 'G/L Account Name'; FieldClass = FlowField; CalcFormula = lookup ("G/L Entry"."G/L Account Name" where("Entry No." = field("Entry No."))); Editable = false; }
        field(102; Description; Text[50]) { Caption = 'Description'; FieldClass = FlowField; CalcFormula = lookup ("G/L Entry".Description where("Entry No." = field("Entry No."))); Editable = false; }
        field(103; "Posting Date"; Date) { Caption = 'Posting Date'; FieldClass = FlowField; CalcFormula = lookup ("G/L Entry"."Posting Date" where("Entry No." = field("Entry No."))); Editable = false; }
    }

    keys
    {
        key(PK; "Change Set ID", "Entry No.") { Clustered = true; }
    }
}