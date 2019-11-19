table 14135123 lvngLedgerVoidEntry
{
    Caption = 'Ledger Void Entry';
    DataClassification = CustomerContent;
    Permissions = tabledata "G/L Entry" = RM, tabledata "Bank Account Ledger Entry" = RM, tabledata "Cust. Ledger Entry" = RM, tabledata "Vendor Ledger Entry" = RM;

    fields
    {
        field(1; "Table ID"; Integer) { Caption = 'Table ID'; DataClassification = CustomerContent; }
        field(2; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = CustomerContent; }
        field(3; "Change No."; Integer) { Caption = 'Change No.'; DataClassification = CustomerContent; AutoIncrement = true; }
        field(10; Date; Date) { Caption = 'Date'; DataClassification = CustomerContent; }
        field(11; Time; Time) { Caption = 'Time'; DataClassification = CustomerContent; }
        field(12; "User ID"; Code[50]) { Caption = 'User ID'; DataClassification = CustomerContent; }
        field(13; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; }
        field(14; "Reason Code"; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; }
        field(15; "Document No."; Code[20]) { Caption = 'Document No.'; DataClassification = CustomerContent; }
        field(16; "Transaction No."; Integer) { Caption = 'Transaction No.'; DataClassification = CustomerContent; }
        field(80; "Global Dimension 1 Code"; Code[20]) { Caption = 'Global Dimension 1 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(81; "Global Dimension 2 Code"; Code[20]) { Caption = 'Global Dimension 2 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(82; "Shortcut Dimension 3 Code"; Code[20]) { Caption = 'Shortcut Dimension 3 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(83; "Shortcut Dimension 4 Code"; Code[20]) { Caption = 'Shortcut Dimension 4 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(84; "Shortcut Dimension 5 Code"; Code[20]) { Caption = 'Shortcut Dimension 5 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(85; "Shortcut Dimension 6 Code"; Code[20]) { Caption = 'Shortcut Dimension 6 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(86; "Shortcut Dimension 7 Code"; Code[20]) { Caption = 'Shortcut Dimension 7 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(87; "Shortcut Dimension 8 Code"; Code[20]) { Caption = 'Shortcut Dimension 8 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(88; "Business Unit Code"; Code[20]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; TableRelation = "Business Unit"; }
        field(89; "Dimension Set ID"; Integer) { Caption = 'Dimension Set ID'; DataClassification = CustomerContent; }
        field(200; "Servicing Type"; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
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
        "Shortcut Dimension 3 Code" := GLEntry."Shortcut Dimension 3 Code";
        "Shortcut Dimension 4 Code" := GLEntry."Shortcut Dimension 4 Code";
        "Shortcut Dimension 5 Code" := GLEntry."Shortcut Dimension 5 Code";
        "Shortcut Dimension 6 Code" := GLEntry."Shortcut Dimension 6 Code";
        "Shortcut Dimension 7 Code" := GLEntry."Shortcut Dimension 7 Code";
        "Shortcut Dimension 8 Code" := GLEntry."Shortcut Dimension 8 Code";
        "Business Unit Code" := GLEntry."Business Unit Code";
        "Dimension Set ID" := GLEntry."Dimension Set ID";
        "Document No." := GLEntry."Document No.";
        "Transaction No." := GLEntry."Transaction No.";
        "Loan No." := GLEntry."Loan No.";
        "Servicing Type" := GLEntry."Servicing Type";
        Insert(true);
        Clear(GLEntry."Reason Code");
        Clear(GLEntry."Global Dimension 1 Code");
        Clear(GLEntry."Global Dimension 2 Code");
        Clear(GLEntry."Shortcut Dimension 3 Code");
        Clear(GLEntry."Shortcut Dimension 4 Code");
        Clear(GLEntry."Shortcut Dimension 5 Code");
        Clear(GLEntry."Shortcut Dimension 6 Code");
        Clear(GLEntry."Shortcut Dimension 7 Code");
        Clear(GLEntry."Shortcut Dimension 8 Code");
        Clear(GLEntry."Business Unit Code");
        Clear(GLEntry."Dimension Set ID");
        Clear(GLEntry."Loan No.");
        Clear(GLEntry."Servicing Type");
        GLEntry.Voided := true;
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
        "Loan No." := CustLedgEntry."Loan No.";
        Insert(true);
        Clear(CustLedgEntry."Reason Code");
        Clear(CustLedgEntry."Global Dimension 1 Code");
        Clear(CustLedgEntry."Global Dimension 2 Code");
        Clear(CustLedgEntry."Dimension Set ID");
        Clear(CustLedgEntry."Loan No.");
        CustLedgEntry.Voided := true;
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
        "Loan No." := BankAccountLedgerEntry."Loan No.";
        Insert(true);
        Clear(BankAccountLedgerEntry."Reason Code");
        Clear(BankAccountLedgerEntry."Global Dimension 1 Code");
        Clear(BankAccountLedgerEntry."Global Dimension 2 Code");
        Clear(BankAccountLedgerEntry."Dimension Set ID");
        Clear(BankAccountLedgerEntry."Loan No.");
        BankAccountLedgerEntry.Voided := true;
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
        "Loan No." := VendorLedgerEntry."Loan No.";
        Insert(true);
        Clear(VendorLedgerEntry."Reason Code");
        Clear(VendorLedgerEntry."Global Dimension 1 Code");
        Clear(VendorLedgerEntry."Global Dimension 2 Code");
        Clear(VendorLedgerEntry."Dimension Set ID");
        Clear(VendorLedgerEntry."Loan No.");
        VendorLedgerEntry.Voided := true;
        VendorLedgerEntry.Modify();
    end;
}