table 14135159 lvngFlexibleImportSchemaLine
{
    Caption = 'Flexible Import Schema Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Schema Code"; Code[20]) { Caption = 'Schema Code'; DataClassification = CustomerContent; TableRelation = lvngFlexibleImportSchema.Code; }
        field(2; "Amount Column No."; Integer) { Caption = 'Amount Column No.'; DataClassification = CustomerContent; }
        field(10; "Account Type"; Enum lvngGenJnlAccountType) { Caption = 'Account Type'; DataClassification = CustomerContent; }
        field(11; "Account No."; Code[20]) { Caption = 'Account No.'; DataClassification = CustomerContent; TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting), Blocked = const(false)) else if ("Account Type" = const(Customer)) Customer else if ("Account Type" = const(Vendor)) Vendor else if ("Account Type" = const("Bank Account")) "Bank Account"; }
        field(12; "Bal. Account Type"; Enum lvngGenJnlAccountType) { Caption = 'Bal. Account Type'; DataClassification = CustomerContent; }
        field(13; "Bal. Account No."; Code[20]) { Caption = 'Bal. Acount No.'; DataClassification = CustomerContent; TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting), Blocked = const(false)) else if ("Bal. Account Type" = const(Customer)) Customer else if ("Bal. Account Type" = const(Vendor)) Vendor else if ("Bal. Account Type" = const("Bank Account")) "Bank Account"; }
        field(15; "Reverse Amount"; Boolean) { Caption = 'Reverse Amount'; DataClassification = CustomerContent; }
        field(16; "Custom Description"; Text[50]) { Caption = 'Custom Description'; DataClassification = CustomerContent; }
        field(17; "Validate From Hierarchy"; Boolean) { Caption = 'Validate From Hierarchy'; DataClassification = CustomerContent; }
        field(20; "Dimension Validation Rule 1"; Enum lvngFlexImportDimValidationRule) { Caption = 'Dimension Validation Rule 1'; DataClassification = CustomerContent; }
        field(21; "Dimension Validation Rule 2"; Enum lvngFlexImportDimValidationRule) { Caption = 'Dimension Validation Rule 2'; DataClassification = CustomerContent; }
        field(22; "Dimension Validation Rule 3"; Enum lvngFlexImportDimValidationRule) { Caption = 'Dimension Validation Rule 3'; DataClassification = CustomerContent; }
        field(80; "Global Dimension 1 Code"; Code[20]) { Caption = 'Global Dimension 1 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(81; "Global Dimension 2 Code"; Code[20]) { Caption = 'Global Dimension 2 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(82; "Shortcut Dimension 3 Code"; Code[20]) { Caption = 'Shortcut Dimension 3 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(83; "Shortcut Dimension 4 Code"; Code[20]) { Caption = 'Shortcut Dimension 4 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(84; "Shortcut Dimension 5 Code"; Code[20]) { Caption = 'Shortcut Dimension 5 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(85; "Shortcut Dimension 6 Code"; Code[20]) { Caption = 'Shortcut Dimension 6 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(86; "Shortcut Dimension 7 Code"; Code[20]) { Caption = 'Shortcut Dimension 7 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(87; "Shortcut Dimension 8 Code"; Code[20]) { Caption = 'Shortcut Dimension 8 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(88; "Business Unit Code"; Code[20]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; TableRelation = "Business Unit".Code; }
        field(14135108; "Servicing Type"; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Schema Code", "Amount Column No.") { Clustered = true; }
    }
}