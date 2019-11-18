table 14135122 lvngLoanFundedDocumentLine
{
    DataClassification = CustomerContent;
    Caption = 'Loan Funded Document Line';
    fields
    {
        field(2; "Document No."; Code[20]) { DataClassification = CustomerContent; }
        field(3; "Line No."; Integer) { DataClassification = CustomerContent; }
        field(10; "Account Type"; enum lvngLoanAccountType) { DataClassification = CustomerContent; }
        field(11; "Account No."; Code[20]) { DataClassification = CustomerContent; TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"."No." where("Account Type" = const(Posting), Blocked = const(false)) else if ("Account Type" = const("Bank Account")) "Bank Account" where(Blocked = const(false)); }
        field(12; "Reason Code"; Code[10]) { DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(13; Description; Text[50]) { DataClassification = CustomerContent; }
        field(14; Amount; Decimal) { DataClassification = CustomerContent; }
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
        field(1000; "Processing Schema Code"; code[20]) { DataClassification = CustomerContent; TableRelation = lvngLoanProcessingSchema.Code; }
        field(1001; "Processing Schema Line No."; Integer) { DataClassification = CustomerContent; TableRelation = lvngLoanProcessingSchemaline."Line No." where("Processing Code" = field("Processing Schema Code")); }
        field(1002; "Balancing Entry"; boolean) { DataClassification = CustomerContent; }
        field(1003; "Tag Code"; Code[10]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Document No.", "Line No.") { Clustered = true; }
    }

    var
        DimensionManagement: Codeunit DimensionManagement;
}