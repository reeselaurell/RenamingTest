table 14135130 lvngServiceHeader
{
    Caption = 'Service Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Servicing Document Type"; enum lvngServicingDocumentType) { Caption = 'Document Type'; DataClassification = CustomerContent; }
        field(2; "No."; Code[20]) { Caption = 'No.'; DataClassification = CustomerContent; }
        field(10; "Borrower Customer No."; Code[20]) { Caption = 'Borrower Customer No.'; DataClassification = CustomerContent; TableRelation = Customer; }
        field(11; "Posting Date"; Date) { Caption = 'Posting Date'; DataClassification = CustomerContent; }
        field(12; "Due Date"; Date) { Caption = 'Due Date'; DataClassification = CustomerContent; }
        field(13; Description; Text[100]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(14; "Reason Code"; Code[10]) { Caption = 'Reason Code'; TableRelation = "Reason Code"; DataClassification = CustomerContent; }
        field(15; "Loan No."; Code[20]) { Caption = 'Loan No.'; TableRelation = lvngLoan; DataClassification = CustomerContent; }
        field(80; "Global Dimension 1 Code"; Code[20]) { Caption = 'Global Dimension 1 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(1)); trigger OnValidate() begin DimensionManagement.ValidateShortcutDimValues(1, "Global Dimension 1 Code", "Dimension Set ID"); end; }
        field(81; "Global Dimension 2 Code"; Code[20]) { Caption = 'Global Dimension 2 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(2)); trigger OnValidate() begin DimensionManagement.ValidateShortcutDimValues(2, "Global Dimension 2 Code", "Dimension Set ID"); end; }
        field(82; "Shortcut Dimension 3 Code"; Code[20]) { Caption = 'Shortcut Dimension 3 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(3)); trigger OnValidate() begin DimensionManagement.ValidateShortcutDimValues(3, "Shortcut Dimension 3 Code", "Dimension Set ID"); end; }
        field(83; "Shortcut Dimension 4 Code"; Code[20]) { Caption = 'Shortcut Dimension 4 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(4)); trigger OnValidate() begin DimensionManagement.ValidateShortcutDimValues(4, "Shortcut Dimension 4 Code", "Dimension Set ID"); end; }
        field(84; "Shortcut Dimension 5 Code"; Code[20]) { Caption = 'Shortcut Dimension 5 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(5)); trigger OnValidate() begin DimensionManagement.ValidateShortcutDimValues(5, "Shortcut Dimension 5 Code", "Dimension Set ID"); end; }
        field(85; "Shortcut Dimension 6 Code"; Code[20]) { Caption = 'Shortcut Dimension 6 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(6)); trigger OnValidate() begin DimensionManagement.ValidateShortcutDimValues(6, "Shortcut Dimension 6 Code", "Dimension Set ID"); end; }
        field(86; "Shortcut Dimension 7 Code"; Code[20]) { Caption = 'Shortcut Dimension 7 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(7)); trigger OnValidate() begin DimensionManagement.ValidateShortcutDimValues(7, "Shortcut Dimension 7 Code", "Dimension Set ID"); end; }
        field(87; "Shortcut Dimension 8 Code"; Code[20]) { Caption = 'Shortcut Dimension 8 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(8)); trigger OnValidate() begin DimensionManagement.ValidateShortcutDimValues(8, "Shortcut Dimension 8 Code", "Dimension Set ID"); end; }
        field(88; "Business Unit Code"; Code[10]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; TableRelation = "Business Unit"; }
        field(89; "Dimension Set ID"; Integer) { Caption = 'Dimension Set ID'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Servicing Document Type", "No.") { Clustered = true; }
    }

    var
        DimensionManagement: Codeunit DimensionManagement;

    trigger OnDelete()
    var
        ServiceLine: Record lvngServiceLine;
    begin
        ServiceLine.Reset();
        ServiceLine.SetRange("Servicing Document Type", "Servicing Document Type");
        ServiceLine.SetRange("Document No.", "No.");
        ServiceLine.DeleteAll(true);
    end;
}