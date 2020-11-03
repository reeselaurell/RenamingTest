table 14135115 "lvnLoanDocumentLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Document Line';
    fields
    {
        field(1; "Transaction Type"; enum lvnLoanTransactionType) { Caption = 'Document Type'; DataClassification = CustomerContent; }
        field(2; "Document No."; Code[20]) { Caption = 'Document No.'; DataClassification = CustomerContent; TableRelation = lvnLoanDocument."Document No." where("Transaction Type" = field("Transaction Type")); }
        field(3; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(10; "Account Type"; enum lvnLoanAccountType) { Caption = 'Account Type'; DataClassification = CustomerContent; }
        field(11; "Account No."; Code[20]) { Caption = 'Account No.'; DataClassification = CustomerContent; TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"."No." where("Account Type" = const(Posting), Blocked = const(false)) else if ("Account Type" = const("Bank Account")) "Bank Account" where(Blocked = const(false)); }
        field(12; "Reason Code"; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(13; Description; Text[50]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(14; Amount; Decimal) { Caption = 'Amount'; DataClassification = CustomerContent; }
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
        field(88; "Business Unit Code"; Code[20]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; TableRelation = "Business Unit"; }
        field(89; "Dimension Set ID"; Integer) { Caption = 'Dimension Set ID'; DataClassification = CustomerContent; }
        field(200; "Servicing Type"; enum lvnServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(1000; "Processing Schema Code"; code[20]) { Caption = 'Processing Schema Code'; DataClassification = CustomerContent; TableRelation = lvnLoanProcessingSchema.Code; }
        field(1001; "Processing Schema Line No."; Integer) { Caption = 'Processing Schema Line No.'; DataClassification = CustomerContent; TableRelation = lvnLoanProcessingSchemaline."Line No." where("Processing Code" = field("Processing Schema Code")); }
        field(1002; "Balancing Entry"; boolean) { Caption = 'Balancing Entry'; DataClassification = CustomerContent; }
        field(1003; "Tag Code"; Code[10]) { Caption = 'Tag Code'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Transaction Type", "Document No.", "Line No.") { Clustered = true; }
    }

    var
        DimensionManagement: Codeunit DimensionManagement;

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