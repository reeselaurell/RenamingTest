table 14135161 "lvnGenLedgerReconcile"
{
    Caption = 'Gen. Ledger Reconile';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(11; "Date Funded"; Date)
        {
            Caption = 'Date Funded';
            DataClassification = CustomerContent;
        }
        field(12; "Last Transaction Date"; Date)
        {
            Caption = 'Last Transaction Date';
            DataClassification = CustomerContent;
        }
        field(13; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(14; "Loan Card Value"; Decimal)
        {
            Caption = 'Loan Card Value';
            DataClassification = CustomerContent;
        }
        field(15; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount';
            DataClassification = CustomerContent;
        }
        field(16; "Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount';
            DataClassification = CustomerContent;
        }
        field(17; "Current Balance"; Decimal)
        {
            Caption = 'Current Balance';
            DataClassification = CustomerContent;
        }
        field(18; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
        }
        field(19; "Shortcut Dimension 1"; Code[20])
        {
            Caption = 'Shortcut Dimension 1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            CaptionClass = '1,2,1';
        }
        field(20; "Shortcut Dimension 2"; Code[20])
        {
            Caption = 'Shortcut Dimension 1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            CaptionClass = '1,2,2';
        }
        field(21; "Shortcut Dimension 3"; Code[20])
        {
            Caption = 'Shortcut Dimension 1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            CaptionClass = '1,2,3';
        }
        field(22; "Shortcut Dimension 4"; Code[20])
        {
            Caption = 'Shortcut Dimension 1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            CaptionClass = '1,2,4';
        }
        field(23; "Shortcut Dimension 5"; Code[20])
        {
            Caption = 'Shortcut Dimension 1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            CaptionClass = '1,2,5';
        }
        field(24; "Shortcut Dimension 6"; Code[20])
        {
            Caption = 'Shortcut Dimension 1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            CaptionClass = '1,2,6';
        }
        field(25; "Shortcut Dimension 7"; Code[20])
        {
            Caption = 'Shortcut Dimension 1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
            CaptionClass = '1,2,7';
        }
        field(26; "Shortcut Dimension 8"; Code[20])
        {
            Caption = 'Shortcut Dimension 1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
            CaptionClass = '1,2,8';
        }
        field(27; "Date Sold"; Date)
        {
            Caption = 'Date Sold';
            DataClassification = CustomerContent;
        }
        field(28; "Investor Name"; Text[50])
        {
            Caption = 'Investor Name';
            DataClassification = CustomerContent;
        }
        field(29; "Includes Multi-Payment"; Boolean)
        {
            Caption = 'Includes Multi-Payment';
            DataClassification = CustomerContent;
        }
        field(30; "Invoice Ledger Entry No."; Integer)
        {
            Caption = 'Invoice Ledger Entry No.';
            DataClassification = CustomerContent;
        }
        field(31; "Payment Ledger Entry No."; Integer)
        {
            Caption = 'Payment Ledger Entry No.';
            DataClassification = CustomerContent;
        }
        field(32; "G/L Entry No."; Integer)
        {
            Caption = 'G/L Entry No.';
            DataClassification = CustomerContent;
        }
        field(33; "Reference No."; Code[20])
        {
            Caption = 'Reference No.';
            DataClassification = CustomerContent;
        }
        field(34; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(35; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
        }
        field(36; "Date Filter"; Text[250])
        {
            Caption = 'Date Filter';
            DataClassification = CustomerContent;
        }
        field(37; Escrow; Decimal)
        {
            Caption = 'Escrow';
            DataClassification = CustomerContent;
        }
        field(38; Principal; Decimal)
        {
            Caption = 'Principal';
            DataClassification = CustomerContent;
        }
        field(39; Interest; Decimal)
        {
            Caption = 'Interest';
            DataClassification = CustomerContent;
        }
        field(40; "Late Fee"; Decimal)
        {
            Caption = 'Late Fee';
            DataClassification = CustomerContent;
        }
        field(41; "Payment Due Date"; Date)
        {
            Caption = 'Payment Due Date';
            DataClassification = CustomerContent;
        }
        field(42; "Payment Received Date"; Date)
        {
            Caption = 'Payment Received Date';
            DataClassification = CustomerContent;
        }
        field(43; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(44; "Add. Principal"; Decimal)
        {
            Caption = 'Add. Principal';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}