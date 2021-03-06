table 14135123 "lvnLedgerVoidEntry"
{
    Caption = 'Ledger Void Entry';
    DataClassification = CustomerContent;
    Permissions = tabledata "G/L Entry" = RM, tabledata "Bank Account Ledger Entry" = RM, tabledata "Cust. Ledger Entry" = RM, tabledata "Vendor Ledger Entry" = RM;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(3; "Change No."; Integer)
        {
            Caption = 'Change No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(10; Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(11; Time; Time)
        {
            Caption = 'Time';
            DataClassification = CustomerContent;
        }
        field(12; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(13; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(14; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
        }
        field(15; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(16; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            DataClassification = CustomerContent;
        }
        field(80; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(81; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(82; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(83; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(84; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
        }
        field(85; "Shortcut Dimension 6 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
        }
        field(86; "Shortcut Dimension 7 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
        }
        field(87; "Shortcut Dimension 8 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
        }
        field(88; "Business Unit Code"; Code[20])
        {
            Caption = 'Business Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Business Unit";
        }
        field(89; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = CustomerContent;
        }
        field(200; "Servicing Type"; enum lvnServicingType)
        {
            Caption = 'Servicing Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Table ID", "Entry No.", "Change No.") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        Date := Today();
        Time := Time();
        "User ID" := UserId();
    end;

    procedure InsertFromGLEntry(var GLEntry: Record "G/L Entry")
    begin
        "Table ID" := Database::"G/L Entry";
        "Entry No." := GLEntry."Entry No.";
        "Reason Code" := GLEntry."Reason Code";
        "Global Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
        "Global Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
        "Shortcut Dimension 3 Code" := GLEntry.lvnShortcutDimension3Code;
        "Shortcut Dimension 4 Code" := GLEntry.lvnShortcutDimension4Code;
        "Shortcut Dimension 5 Code" := GLEntry.lvnShortcutDimension5Code;
        "Shortcut Dimension 6 Code" := GLEntry.lvnShortcutDimension6Code;
        "Shortcut Dimension 7 Code" := GLEntry.lvnShortcutDimension7Code;
        "Shortcut Dimension 8 Code" := GLEntry.lvnShortcutDimension8Code;
        "Business Unit Code" := GLEntry."Business Unit Code";
        "Dimension Set ID" := GLEntry."Dimension Set ID";
        "Document No." := GLEntry."Document No.";
        "Transaction No." := GLEntry."Transaction No.";
        "Loan No." := GLEntry.lvnLoanNo;
        "Servicing Type" := GLEntry.lvnServicingType;
        Insert(true);
        Clear(GLEntry."Reason Code");
        Clear(GLEntry."Global Dimension 1 Code");
        Clear(GLEntry."Global Dimension 2 Code");
        Clear(GLEntry.lvnShortcutDimension3Code);
        Clear(GLEntry.lvnShortcutDimension4Code);
        Clear(GLEntry.lvnShortcutDimension5Code);
        Clear(GLEntry.lvnShortcutDimension6Code);
        Clear(GLEntry.lvnShortcutDimension7Code);
        Clear(GLEntry.lvnShortcutDimension8Code);
        Clear(GLEntry."Business Unit Code");
        Clear(GLEntry."Dimension Set ID");
        Clear(GLEntry.lvnLoanNo);
        Clear(GLEntry.lvnServicingType);
        GLEntry.lvnVoided := true;
        GLEntry.Modify();
    end;

    procedure InsertFromCustLedgEntry(var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        "Table ID" := Database::"Cust. Ledger Entry";
        "Entry No." := CustLedgEntry."Entry No.";
        "Reason Code" := CustLedgEntry."Reason Code";
        "Global Dimension 1 Code" := CustLedgEntry."Global Dimension 1 Code";
        "Global Dimension 2 Code" := CustLedgEntry."Global Dimension 2 Code";
        "Dimension Set ID" := CustLedgEntry."Dimension Set ID";
        "Document No." := CustLedgEntry."Document No.";
        "Transaction No." := CustLedgEntry."Transaction No.";
        "Loan No." := CustLedgEntry.lvnLoanNo;
        Insert(true);
        Clear(CustLedgEntry."Reason Code");
        Clear(CustLedgEntry."Global Dimension 1 Code");
        Clear(CustLedgEntry."Global Dimension 2 Code");
        Clear(CustLedgEntry."Dimension Set ID");
        Clear(CustLedgEntry.lvnLoanNo);
        CustLedgEntry.lvnVoided := true;
        CustLedgEntry.Modify();
    end;

    procedure InsertFromBankAccountLedgerEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        "Table ID" := Database::"Bank Account Ledger Entry";
        "Entry No." := BankAccountLedgerEntry."Entry No.";
        "Reason Code" := BankAccountLedgerEntry."Reason Code";
        "Global Dimension 1 Code" := BankAccountLedgerEntry."Global Dimension 1 Code";
        "Global Dimension 2 Code" := BankAccountLedgerEntry."Global Dimension 2 Code";
        "Dimension Set ID" := BankAccountLedgerEntry."Dimension Set ID";
        "Document No." := BankAccountLedgerEntry."Document No.";
        "Transaction No." := BankAccountLedgerEntry."Transaction No.";
        "Loan No." := BankAccountLedgerEntry.lvnLoanNo;
        Insert(true);
        Clear(BankAccountLedgerEntry."Reason Code");
        Clear(BankAccountLedgerEntry."Global Dimension 1 Code");
        Clear(BankAccountLedgerEntry."Global Dimension 2 Code");
        Clear(BankAccountLedgerEntry."Dimension Set ID");
        Clear(BankAccountLedgerEntry.lvnLoanNo);
        BankAccountLedgerEntry.lvnVoided := true;
        BankAccountLedgerEntry.Modify();
    end;

    procedure InsertFromVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        "Table ID" := Database::"Vendor Ledger Entry";
        "Entry No." := VendorLedgerEntry."Entry No.";
        "Reason Code" := VendorLedgerEntry."Reason Code";
        "Global Dimension 1 Code" := VendorLedgerEntry."Global Dimension 1 Code";
        "Global Dimension 2 Code" := VendorLedgerEntry."Global Dimension 2 Code";
        "Dimension Set ID" := VendorLedgerEntry."Dimension Set ID";
        "Document No." := VendorLedgerEntry."Document No.";
        "Transaction No." := VendorLedgerEntry."Transaction No.";
        "Loan No." := VendorLedgerEntry.lvnLoanNo;
        Insert(true);
        Clear(VendorLedgerEntry."Reason Code");
        Clear(VendorLedgerEntry."Global Dimension 1 Code");
        Clear(VendorLedgerEntry."Global Dimension 2 Code");
        Clear(VendorLedgerEntry."Dimension Set ID");
        Clear(VendorLedgerEntry.lvnLoanNo);
        VendorLedgerEntry.lvnVoided := true;
        VendorLedgerEntry.Modify();
    end;
}