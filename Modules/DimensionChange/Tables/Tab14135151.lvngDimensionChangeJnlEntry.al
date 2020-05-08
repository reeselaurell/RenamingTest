table 14135151 lvngDimensionChangeJnlEntry
{
    Caption = 'Dimension Change Journal Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Change Set ID"; Guid) { Caption = 'Change Set ID'; DataClassification = CustomerContent; }
        field(2; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = CustomerContent; }
        field(10; "Old Dimension 1 Code"; Code[20]) { Caption = 'Old Dimension 1 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(11; "Old Dimension 2 Code"; Code[20]) { Caption = 'Old Dimension 2 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(12; "Old Dimension 3 Code"; Code[20]) { Caption = 'Old Dimension 3 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(13; "Old Dimension 4 Code"; Code[20]) { Caption = 'Old Dimension 4 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(14; "Old Dimension 5 Code"; Code[20]) { Caption = 'Old Dimension 5 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(15; "Old Dimension 6 Code"; Code[20]) { Caption = 'Old Dimension 6 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(16; "Old Dimension 7 Code"; Code[20]) { Caption = 'Old Dimension 7 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(17; "Old Dimension 8 Code"; Code[20]) { Caption = 'Old Dimension 8 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(18; "Old Dimension Set ID"; Integer) { Caption = 'Old Dimension Set ID'; DataClassification = CustomerContent; }
        field(19; "Old Business Unit Code"; Code[20]) { Caption = 'Old Business Unit Code'; DataClassification = CustomerContent; }
        field(20; "New Dimension 1 Code"; Code[20]) { Caption = 'New Dimension 1 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(21; "New Dimension 2 Code"; Code[20]) { Caption = 'New Dimension 2 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(22; "New Dimension 3 Code"; Code[20]) { Caption = 'New Dimension 3 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(23; "New Dimension 4 Code"; Code[20]) { Caption = 'New Dimension 4 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(24; "New Dimension 5 Code"; Code[20]) { Caption = 'New Dimension 5 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(25; "New Dimension 6 Code"; Code[20]) { Caption = 'New Dimension 6 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(26; "New Dimension 7 Code"; Code[20]) { Caption = 'New Dimension 7 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(27; "New Dimension 8 Code"; Code[20]) { Caption = 'New Dimension 8 Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(28; "New Dimension Set ID"; Integer) { Caption = 'New Dimension Set ID'; DataClassification = CustomerContent; }
        field(29; "New Business Unit Code"; Code[20]) { Caption = 'New Business Unit Code'; DataClassification = CustomerContent; }
        field(50; "New Loan No."; Code[20]) { Caption = 'New Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
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

    procedure TransferValues()
    var
        GLEntry: Record "G/L Entry";
    begin
        if GLEntry.Get("Entry No.") then
            TransferValuesFromRecord(GLEntry);
    end;

    procedure TransferValuesFromRecord(var GLEntry: Record "G/L Entry")
    begin
        "Entry No." := GLEntry."Entry No.";
        "Old Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
        "New Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
        "Old Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
        "New Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
        "Old Dimension 3 Code" := GLEntry.lvngShortcutDimension3Code;
        "New Dimension 3 Code" := GLEntry.lvngShortcutDimension3Code;
        "Old Dimension 4 Code" := GLEntry.lvngShortcutDimension4Code;
        "New Dimension 4 Code" := GLEntry.lvngShortcutDimension4Code;
        "Old Dimension 5 Code" := GLEntry.lvngShortcutDimension5Code;
        "New Dimension 5 Code" := GLEntry.lvngShortcutDimension5Code;
        "Old Dimension 6 Code" := GLEntry.lvngShortcutDimension6Code;
        "New Dimension 6 Code" := GLEntry.lvngShortcutDimension6Code;
        "Old Dimension 7 Code" := GLEntry.lvngShortcutDimension7Code;
        "New Dimension 7 Code" := GLEntry.lvngShortcutDimension7Code;
        "Old Dimension 8 Code" := GLEntry.lvngShortcutDimension8Code;
        "New Dimension 8 Code" := GLEntry.lvngShortcutDimension8Code;
        "Old Business Unit Code" := GLEntry."Business Unit Code";
        "New Business Unit Code" := GLEntry."Business Unit Code";
        "Old Dimension Set ID" := GLEntry."Dimension Set ID";
        "New Loan No." := GLEntry.lvngLoanNo;
        "Old Loan No." := GLEntry.lvngLoanNo;
    end;

    procedure TransferValuesImport()
    var
        GLEntry: Record "G/L Entry";
    begin
        if GLEntry.Get("Entry No.") then
            TransferValuesFromRecordImport(GLEntry);
    end;

    procedure TransferValuesFromRecordImport(var GLEntry: Record "G/L Entry")
    begin
        "Entry No." := GLEntry."Entry No.";
        "Old Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
        "Old Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
        "Old Dimension 3 Code" := GLEntry.lvngShortcutDimension3Code;
        "Old Dimension 4 Code" := GLEntry.lvngShortcutDimension4Code;
        "Old Dimension 5 Code" := GLEntry.lvngShortcutDimension5Code;
        "Old Dimension 6 Code" := GLEntry.lvngShortcutDimension6Code;
        "Old Dimension 7 Code" := GLEntry.lvngShortcutDimension7Code;
        "Old Dimension 8 Code" := GLEntry.lvngShortcutDimension8Code;
        "Old Business Unit Code" := GLEntry."Business Unit Code";
        "Old Dimension Set ID" := GLEntry."Dimension Set ID";
        "New Loan No." := GLEntry.lvngLoanNo;
        "Old Loan No." := GLEntry.lvngLoanNo;
    end;
}