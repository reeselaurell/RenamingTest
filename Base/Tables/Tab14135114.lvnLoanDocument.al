table 14135114 "lvnLoanDocument"
{
    Caption = 'Loan Document';
    DataClassification = CustomerContent;
    LookupPageId = lvnLoanDocumentsList;

    fields
    {
        field(1; "Transaction Type"; Enum lvnLoanTransactionType) { Caption = 'Transaction Type'; DataClassification = CustomerContent; }
        field(2; "Document No."; code[20]) { Caption = 'Document No.'; DataClassification = CustomerContent; NotBlank = true; }
        field(10; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvnLoan; }
        field(11; "Customer No."; Code[20]) { Caption = 'Customer No.'; DataClassification = CustomerContent; TableRelation = Customer; }
        field(12; Void; Boolean) { Caption = 'Void'; DataClassification = CustomerContent; }
        field(13; "Posting Date"; Date) { Caption = 'Posting Date'; DataClassification = CustomerContent; }
        field(14; "Reason Code"; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(15; "Document Type"; enum lvnLoanDocumentType) { Caption = 'Document Type'; DataClassification = CustomerContent; }
        field(30; "Last Servicing Period"; Boolean) { Caption = 'Last Servicing Period'; DataClassification = CustomerContent; }
        field(56; "External Document No."; Code[35]) { Caption = 'External Document No.'; DataClassification = CustomerContent; }
        field(80; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(1, "Global Dimension 1 Code", "Dimension Set ID");
            end;
        }
        field(81; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(2, "Global Dimension 2 Code", "Dimension Set ID");
            end;
        }
        field(82; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(3, "Shortcut Dimension 3 Code", "Dimension Set ID");
            end;
        }
        field(83; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));

            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(4, "Shortcut Dimension 4 Code", "Dimension Set ID");
            end;
        }
        field(84; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 5 Code';
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));

            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(5, "Shortcut Dimension 5 Code", "Dimension Set ID");
            end;
        }
        field(85; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 6 Code';
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));

            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(6, "Shortcut Dimension 6 Code", "Dimension Set ID");
            end;
        }
        field(86; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 7 Code';
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));

            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(7, "Shortcut Dimension 7 Code", "Dimension Set ID");
            end;
        }
        field(87; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 8 Code';
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));

            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(8, "Shortcut Dimension 8 Code", "Dimension Set ID");
            end;
        }
        field(88; "Business Unit Code"; Code[10]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; TableRelation = "Business Unit"; }
        field(89; "Dimension Set ID"; Integer) { Caption = 'Dimension Set ID'; DataClassification = CustomerContent; }
        field(200; "Warehouse Line Code"; Code[50]) { Caption = 'Warehouse Line Code'; DataClassification = CustomerContent; TableRelation = lvnWarehouseLine.Code; }
        field(1000; "Void Document No."; Code[20]) { Caption = 'Void Document No.'; DataClassification = CustomerContent; }
        field(10000; "Borrower Search Name"; Code[50]) { Caption = 'Borrower Search Name'; Editable = false; FieldClass = FlowField; CalcFormula = lookup(lvnLoan."Search Name" where("No." = field("Loan No."))); }
        field(10001; "Document Amount"; Decimal) { Caption = 'Document Amount'; Editable = false; FieldClass = FlowField; CalcFormula = sum(lvnLoanDocumentLine.Amount where("Document No." = field("Document No."), "Transaction Type" = field("Transaction Type"))); }
    }

    keys
    {
        key(PK; "Transaction Type", "Document No.") { Clustered = true; }
    }

    var
        DimensionManagement: Codeunit DimensionManagement;

    trigger OnDelete()
    var
        LoanDocumentLine: Record lvnLoanDocumentLine;
    begin
        LoanDocumentLine.Reset();
        LoanDocumentLine.SetRange("Transaction Type", "Transaction Type");
        LoanDocumentLine.SetRange("Document No.", "Document No.");
        LoanDocumentLine.DeleteAll();
    end;

    procedure GenerateDimensionSetId()
    begin
        DimensionManagement.ValidateShortcutDimValues(1, "Global Dimension 1 Code", "Dimension Set ID");
        DimensionManagement.ValidateShortcutDimValues(2, "Global Dimension 2 Code", "Dimension Set ID");
        DimensionManagement.ValidateShortcutDimValues(3, "Shortcut Dimension 3 Code", "Dimension Set ID");
        DimensionManagement.ValidateShortcutDimValues(4, "Shortcut Dimension 4 Code", "Dimension Set ID");
        DimensionManagement.ValidateShortcutDimValues(5, "Shortcut Dimension 5 Code", "Dimension Set ID");
        DimensionManagement.ValidateShortcutDimValues(6, "Shortcut Dimension 6 Code", "Dimension Set ID");
        DimensionManagement.ValidateShortcutDimValues(7, "Shortcut Dimension 7 Code", "Dimension Set ID");
        DimensionManagement.ValidateShortcutDimValues(8, "Shortcut Dimension 8 Code", "Dimension Set ID");
    end;

}