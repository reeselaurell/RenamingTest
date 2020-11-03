table 14135134 "lvnGLEntryBuffer"
{
    Caption = 'G/L Entry Buffer';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = CustomerContent; }
        field(2; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; }
        field(3; "Date Funded"; Date) { Caption = 'Date Funded'; DataClassification = CustomerContent; }
        field(4; "Posting Date"; Date) { Caption = 'Posting Date'; DataClassification = CustomerContent; }
        field(5; Name; Text[50]) { Caption = 'Name'; DataClassification = CustomerContent; }
        field(7; "Debit Amount"; Decimal) { Caption = 'Debit Amount'; DataClassification = CustomerContent; }
        field(8; "Credit Amount"; Decimal) { Caption = 'Credit Amount'; DataClassification = CustomerContent; }
        field(9; "Current Balance"; Decimal) { Caption = 'Current Balance'; DataClassification = CustomerContent; }
        field(10; "G/L Account No."; Code[20]) { Caption = 'G/L Account No.'; DataClassification = CustomerContent; }
        field(17; Amount; Decimal) { Caption = 'Amount'; DataClassification = CustomerContent; }
        field(18; "Reason Code"; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; }
        field(19; "External Document No."; Code[35]) { Caption = 'External Document No.'; DataClassification = CustomerContent; }
        field(20; "G/L Entry No."; Integer) { Caption = 'G/L Entry No.'; DataClassification = CustomerContent; }
        field(21; "Date Sold"; Date) { Caption = 'Date Funded'; DataClassification = CustomerContent; }
        field(22; "Loan Search Name"; Code[100]) { Caption = 'Loan Search Name'; DataClassification = CustomerContent; }
        field(23; "Source Code"; Code[20]) { Caption = 'Source Code'; DataClassification = CustomerContent; }
        field(30; "Investor Name"; Text[100]) { Caption = 'Investor Name'; DataClassification = CustomerContent; }
        field(31; "Shortcut Dimension 1 Code"; Code[20]) { Caption = 'Shortcut Dimension 1 Code'; DataClassification = CustomerContent; CaptionClass = '1,4,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(32; "Shortcut Dimension 2 Code"; Code[20]) { Caption = 'Shortcut Dimension 2 Code'; DataClassification = CustomerContent; CaptionClass = '1,4,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(33; "Shortcut Dimension 3 Code"; Code[20]) { Caption = 'Shortcut Dimension 3 Code'; DataClassification = CustomerContent; CaptionClass = '1,4,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(34; "Shortcut Dimension 4 Code"; Code[20]) { Caption = 'Shortcut Dimension 4 Code'; DataClassification = CustomerContent; CaptionClass = '1,4,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(35; "Shortcut Dimension 5 Code"; Code[20]) { Caption = 'Shortcut Dimension 5 Code'; DataClassification = CustomerContent; CaptionClass = '1,4,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(36; "Shortcut Dimension 6 Code"; Code[20]) { Caption = 'Shortcut Dimension 6 Code'; DataClassification = CustomerContent; CaptionClass = '1,4,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(37; "Shortcut Dimension 7 Code"; Code[20]) { Caption = 'Shortcut Dimension 7 Code'; DataClassification = CustomerContent; CaptionClass = '1,4,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(38; "Shortcut Dimension 8 Code"; Code[20]) { Caption = 'Shortcut Dimension 8 Code'; DataClassification = CustomerContent; CaptionClass = '1,4,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(26; "Reference No."; code[20]) { Caption = 'Reference No.'; DataClassification = CustomerContent; }
        field(204; "Payment Due Date"; Date) { Caption = 'Payment Due Date'; DataClassification = CustomerContent; }
        field(206; "Document No."; Code[20]) { Caption = 'Document No.'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}