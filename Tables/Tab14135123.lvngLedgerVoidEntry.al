table 14135123 "lvngLedgerVoidEntry"
{
    Caption = 'Ledger Void Entry';
    DataClassification = CustomerContent;
    Permissions = tabledata "G/L Entry" = RM, tabledata "Bank Account Ledger Entry" = RM, tabledata "Cust. Ledger Entry" = RM, tabledata "Vendor Ledger Entry" = RM;

    fields
    {
        field(1; lvngTableID; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }
        field(2; lvngEntryNo; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(3; lvngChangeNo; Integer)
        {
            Caption = 'Change No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(10; lvngDate; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(11; lvngTime; Time)
        {
            Caption = 'Time';
            DataClassification = CustomerContent;
        }
        field(12; lvngUserID; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(13; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(14; lvngReasonCode; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
        }
        field(15; lvngDocumentNo; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(16; lvngTransactionNo; Integer)
        {
            Caption = 'Transaction No.';
            DataClassification = CustomerContent;
        }

        field(80; lvngGlobalDimension1Code; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
        }
        field(81; lvngGlobalDimension2Code; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
        }
        field(82; lvngShortcutDimension3Code; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (3));
        }
        field(83; lvngShortcutDimension4Code; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (4));
        }
        field(84; lvngShortcutDimension5Code; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (5));
        }
        field(85; lvngShortcutDimension6Code; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (6));
        }
        field(86; lvngShortcutDimension7Code; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (7));
        }
        field(87; lvngShortcutDimension8Code; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (8));
        }

        field(88; lvngBusinessUnitCode; Code[10])
        {
            Caption = 'Business Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Business Unit";
        }

        field(89; lvngDimensionSetID; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngTableID, lvngEntryNo, lvngChangeNo)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        lvngDate := Today();
        lvngTime := Time();
        lvngUserID := UserId();
    end;

    procedure InsertFromGLEntry(var GLEntry: Record "G/L Entry")
    begin
        lvngTableID := Database::"G/L Entry";
        lvngEntryNo := GLEntry."Entry No.";
        lvngReasonCode := GLEntry."Reason Code";
        lvngGlobalDimension1Code := GLEntry."Global Dimension 1 Code";
        lvngGlobalDimension2Code := GLEntry."Global Dimension 2 Code";
        lvngShortcutDimension3Code := GLEntry.lvngShortcutDimension3Code;
        lvngShortcutDimension4Code := GLEntry.lvngShortcutDimension4Code;
        lvngShortcutDimension5Code := GLEntry.lvngShortcutDimension5Code;
        lvngShortcutDimension6Code := GLEntry.lvngShortcutDimension6Code;
        lvngShortcutDimension7Code := GLEntry.lvngShortcutDimension7Code;
        lvngShortcutDimension8Code := GLEntry.lvngShortcutDimension8Code;
        lvngBusinessUnitCode := GLEntry."Business Unit Code";
        lvngDimensionSetID := GLEntry."Dimension Set ID";
        lvngDocumentNo := GLEntry."Document No.";
        lvngTransactionNo := GLEntry."Transaction No.";
        lvngLoanNo := GLEntry.lvngLoanNo;
        Insert(true);
        clear(GLEntry."Reason Code");
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
        GLEntry.lvngVoided := true;
        GLEntry.Modify()
    end;

    procedure InsertFromCustLedgEntry(var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        lvngTableID := Database::"Cust. Ledger Entry";
        lvngEntryNo := CustLedgEntry."Entry No.";
        lvngReasonCode := CustLedgEntry."Reason Code";
        lvngGlobalDimension1Code := CustLedgEntry."Global Dimension 1 Code";
        lvngGlobalDimension2Code := CustLedgEntry."Global Dimension 2 Code";
        lvngDimensionSetID := CustLedgEntry."Dimension Set ID";
        lvngDocumentNo := CustLedgEntry."Document No.";
        lvngTransactionNo := CustLedgEntry."Transaction No.";
        lvngLoanNo := CustLedgEntry.lvngLoanNo;
        Insert(true);
        clear(CustLedgEntry."Reason Code");
        Clear(CustLedgEntry."Global Dimension 1 Code");
        Clear(CustLedgEntry."Global Dimension 2 Code");
        Clear(CustLedgEntry."Dimension Set ID");
        Clear(CustLedgEntry.lvngLoanNo);
        CustLedgEntry.lvngVoided := true;
        CustLedgEntry.Modify()
    end;

    procedure InsertFromBankAccountLedgerEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        lvngTableID := Database::"Bank Account Ledger Entry";
        lvngEntryNo := BankAccountLedgerEntry."Entry No.";
        lvngReasonCode := BankAccountLedgerEntry."Reason Code";
        lvngGlobalDimension1Code := BankAccountLedgerEntry."Global Dimension 1 Code";
        lvngGlobalDimension2Code := BankAccountLedgerEntry."Global Dimension 2 Code";
        lvngDimensionSetID := BankAccountLedgerEntry."Dimension Set ID";
        lvngDocumentNo := BankAccountLedgerEntry."Document No.";
        lvngTransactionNo := BankAccountLedgerEntry."Transaction No.";
        lvngLoanNo := BankAccountLedgerEntry.lvngLoanNo;
        Insert(true);
        clear(BankAccountLedgerEntry."Reason Code");
        Clear(BankAccountLedgerEntry."Global Dimension 1 Code");
        Clear(BankAccountLedgerEntry."Global Dimension 2 Code");
        Clear(BankAccountLedgerEntry."Dimension Set ID");
        Clear(BankAccountLedgerEntry.lvngLoanNo);
        BankAccountLedgerEntry.lvngVoided := true;
        BankAccountLedgerEntry.Modify()
    end;

    procedure InsertFromVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        lvngTableID := Database::"Vendor Ledger Entry";
        lvngEntryNo := VendorLedgerEntry."Entry No.";
        lvngReasonCode := VendorLedgerEntry."Reason Code";
        lvngGlobalDimension1Code := VendorLedgerEntry."Global Dimension 1 Code";
        lvngGlobalDimension2Code := VendorLedgerEntry."Global Dimension 2 Code";
        lvngDimensionSetID := VendorLedgerEntry."Dimension Set ID";
        lvngDocumentNo := VendorLedgerEntry."Document No.";
        lvngTransactionNo := VendorLedgerEntry."Transaction No.";
        lvngLoanNo := VendorLedgerEntry.lvngLoanNo;
        Insert(true);
        clear(VendorLedgerEntry."Reason Code");
        Clear(VendorLedgerEntry."Global Dimension 1 Code");
        Clear(VendorLedgerEntry."Global Dimension 2 Code");
        Clear(VendorLedgerEntry."Dimension Set ID");
        Clear(VendorLedgerEntry.lvngLoanNo);
        VendorLedgerEntry.lvngVoided := true;
        VendorLedgerEntry.Modify()
    end;

}