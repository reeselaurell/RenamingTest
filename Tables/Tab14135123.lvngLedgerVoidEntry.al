table 14135123 "lvngLedgerVoidEntry"
{
    Caption = 'Ledger Void Entry';
    DataClassification = CustomerContent;
    Permissions = tabledata "G/L Entry" = RM, tabledata "Bank Account Ledger Entry" = RM, tabledata "Cust. Ledger Entry" = RM, tabledata "Vendor Ledger Entry" = RM;

    fields
    {
        field(1; "Table ID"; Integer) { DataClassification = CustomerContent; }
        field(2; "Entry No."; Integer) { DataClassification = CustomerContent; }
        field(3; "Change No."; Integer) { DataClassification = CustomerContent; AutoIncrement = true; }
        field(10; Date; Date) { DataClassification = CustomerContent; }
        field(11; Time; Time) { DataClassification = CustomerContent; }
        field(12; "User ID"; Code[50]) { DataClassification = CustomerContent; }
        field(13; "Loan No."; Code[20]) { DataClassification = CustomerContent; }
        field(14; "Reason Code"; Code[10]) { DataClassification = CustomerContent; }
        field(15; "Document No."; Code[20]) { DataClassification = CustomerContent; }
        field(16; "Transaction No."; Integer) { DataClassification = CustomerContent; }
        field(80; "Global Dimension 1 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,1,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(81; "Global Dimension 2 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,1,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(82; "Shortcut Dimension 3 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(83; "Shortcut Dimension 4 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(84; "Shortcut Dimension 5 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(85; "Shortcut Dimension 6 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(86; "Shortcut Dimension 7 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(87; "Shortcut Dimension 8 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(88; "Business Unit Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Business Unit"; }
        field(89; "Dimension Set ID"; Integer) { DataClassification = CustomerContent; }
        field(200; "Servicing Type"; enum lvngServicingType) { DataClassification = CustomerContent; }
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
        "Shortcut Dimension 3 Code" := GLEntry.lvngShortcutDimension3Code;
        "Shortcut Dimension 4 Code" := GLEntry.lvngShortcutDimension4Code;
        "Shortcut Dimension 5 Code" := GLEntry.lvngShortcutDimension5Code;
        "Shortcut Dimension 6 Code" := GLEntry.lvngShortcutDimension6Code;
        "Shortcut Dimension 7 Code" := GLEntry.lvngShortcutDimension7Code;
        "Shortcut Dimension 8 Code" := GLEntry.lvngShortcutDimension8Code;
        "Business Unit Code" := GLEntry."Business Unit Code";
        "Dimension Set ID" := GLEntry."Dimension Set ID";
        "Document No." := GLEntry."Document No.";
        "Transaction No." := GLEntry."Transaction No.";
        "Loan No." := GLEntry.lvngLoanNo;
        "Servicing Type" := GLEntry.lvngServicingType;
        Insert(true);
        Clear(GLEntry."Reason Code");
        Clear(GLEntry."Global Dimension 1 Code");
        Clear(GLEntry."Global Dimension 2 Code");
        Clear(GLEntry.lvngShortcutDimension3Code);
        Clear(GLEntry.lvngShortcutDimension4Code);
        Clear(GLEntry.lvngShortcutDimension5Code);
        Clear(GLEntry.lvngShortcutDimension6Code);
        Clear(GLEntry.lvngShortcutDimension7Code);
        Clear(GLEntry.lvngShortcutDimension8Code);
        Clear(GLEntry."Business Unit Code");
        Clear(GLEntry."Dimension Set ID");
        Clear(GLEntry.lvngLoanNo);
        Clear(GLEntry.lvngServicingType);
        GLEntry.lvngVoided := true;
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
        "Loan No." := CustLedgEntry.lvngLoanNo;
        Insert(true);
        Clear(CustLedgEntry."Reason Code");
        Clear(CustLedgEntry."Global Dimension 1 Code");
        Clear(CustLedgEntry."Global Dimension 2 Code");
        Clear(CustLedgEntry."Dimension Set ID");
        Clear(CustLedgEntry.lvngLoanNo);
        CustLedgEntry.lvngVoided := true;
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
        "Loan No." := BankAccountLedgerEntry.lvngLoanNo;
        Insert(true);
        Clear(BankAccountLedgerEntry."Reason Code");
        Clear(BankAccountLedgerEntry."Global Dimension 1 Code");
        Clear(BankAccountLedgerEntry."Global Dimension 2 Code");
        Clear(BankAccountLedgerEntry."Dimension Set ID");
        Clear(BankAccountLedgerEntry.lvngLoanNo);
        BankAccountLedgerEntry.lvngVoided := true;
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
        "Loan No." := VendorLedgerEntry.lvngLoanNo;
        Insert(true);
        Clear(VendorLedgerEntry."Reason Code");
        Clear(VendorLedgerEntry."Global Dimension 1 Code");
        Clear(VendorLedgerEntry."Global Dimension 2 Code");
        Clear(VendorLedgerEntry."Dimension Set ID");
        Clear(VendorLedgerEntry.lvngLoanNo);
        VendorLedgerEntry.lvngVoided := true;
        VendorLedgerEntry.Modify();
    end;
}