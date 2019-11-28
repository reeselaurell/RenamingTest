table 14135141 lvngGenLedgerReconcile
{
    Caption = 'Gen. Ledger Reconcile';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { DataClassification = CustomerContent; Caption = 'Entry No.'; }
        field(2; "Loan No."; Code[20]) { DataClassification = CustomerContent; Caption = 'Loan No.'; }
        field(3; "Date Funded"; Date) { DataClassification = CustomerContent; Caption = 'Date Funded'; }
        field(4; "Last Transaction Date"; Date) { DataClassification = CustomerContent; Caption = 'Transaction Date'; }
        field(5; Name; Text[50]) { DataClassification = CustomerContent; Caption = 'Name'; }
        field(6; "Loan Card Value"; Decimal) { DataClassification = CustomerContent; Caption = 'Loan Card Value'; }
        field(7; "Debit Amount"; Decimal) { DataClassification = CustomerContent; Caption = 'Debit Amount'; }
        field(8; "Credit Amount"; Decimal) { DataClassification = CustomerContent; Caption = 'Credit Amount'; }
        field(9; "Current Balance"; Decimal) { DataClassification = CustomerContent; Caption = 'Current Balance'; }
        field(10; "G/L Account No."; Code[20]) { DataClassification = CustomerContent; Caption = 'G/L Account No.'; }
        field(11; "Shortcut Dimension 1 Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Shortcut Dimension 1 Code'; CaptionClass = '1,4,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(12; "Shortcut Dimension 2 Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Shortcut Dimension 2 Code'; CaptionClass = '1,4,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(13; "Shortcut Dimension 3 Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Shortcut Dimension 3 Code'; CaptionClass = '1,4,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(14; "Shortcut Dimension 4 Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Shortcut Dimension 4 Code'; CaptionClass = '1,4,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(15; "Shortcut Dimension 5 Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Shortcut Dimension 5 Code'; CaptionClass = '1,4,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(16; "Shortcut Dimension 6 Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Shortcut Dimension 6 Code'; CaptionClass = '1,4,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(17; "Shortcut Dimension 7 Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Shortcut Dimension 7 Code'; CaptionClass = '1,4,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(18; "Shortcut Dimension 8 Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Shortcut Dimension 8 Code'; CaptionClass = '1,4,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(19; "Date Sold"; Date) { DataClassification = CustomerContent; Caption = 'Date Sold'; }
        field(20; "Investor Name"; Text[50]) { DataClassification = CustomerContent; Caption = 'Investor Name'; }
        field(22; "Includes Multi-Payment"; Boolean) { DataClassification = CustomerContent; Caption = 'Includes Multi-Payment'; }
        field(23; "Invoice Ledger Entry No."; Integer) { DataClassification = CustomerContent; Caption = 'Invoice Ledger Entry No.'; }
        field(24; "Payment Ledger Entry No."; Integer) { DataClassification = CustomerContent; Caption = 'Payment Ledger Entry No.'; }
        field(25; "G/L Entry No."; Integer) { DataClassification = CustomerContent; Caption = 'G/L Entry No.'; }
        field(26; "Reference No."; Code[20]) { DataClassification = CustomerContent; Caption = 'Reference No.'; }
        field(27; "External Document No."; Code[35]) { DataClassification = CustomerContent; Caption = 'External Document No.'; }
        field(28; "Reason Code"; Code[10]) { DataClassification = CustomerContent; Caption = 'Reason Code'; }
        field(100; "Date Filter"; Text[250]) { DataClassification = CustomerContent; Caption = 'Date Filter'; }
        field(200; Escrow; Decimal) { DataClassification = CustomerContent; Caption = 'Escrow'; }
        field(201; Principal; Decimal) { DataClassification = CustomerContent; Caption = 'Principal'; }
        field(202; Interest; Decimal) { DataClassification = CustomerContent; Caption = 'Interest'; }
        field(203; "Late Fee"; Decimal) { DataClassification = CustomerContent; Caption = 'Late Fee'; }
        field(204; "Payment Due Date"; Date) { DataClassification = CustomerContent; Caption = 'Payment Due Date'; }
        field(205; "Payment Received Date"; Date) { DataClassification = CustomerContent; Caption = 'Payment Received Date'; }
        field(206; "Document No."; Code[20]) { DataClassification = CustomerContent; Caption = 'Document No.'; }
        field(207; "Add. Principal"; Decimal) { DataClassification = CustomerContent; Caption = 'Add. Principal'; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}