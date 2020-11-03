table 14135121 "lvnLoanFundedDocument"
{
    Caption = 'Loan Funded Document';
    DataClassification = CustomerContent;
    LookupPageId = lvnPostedFundedDocuments;

    fields
    {
        field(2; "Document No."; code[20]) { Caption = 'Document No.'; DataClassification = CustomerContent; }
        field(10; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvnLoan; }
        field(11; "Customer No."; Code[20]) { Caption = 'Customer No.'; DataClassification = CustomerContent; TableRelation = Customer; }
        field(12; Void; Boolean) { Caption = 'Void'; DataClassification = CustomerContent; }
        field(13; "Posting Date"; Date) { Caption = 'Posting Date'; DataClassification = CustomerContent; }
        field(14; "Reason Code"; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(15; "Document Type"; enum lvnLoanDocumentType) { Caption = 'Document Type'; DataClassification = CustomerContent; }
        field(56; "External Document No."; Code[35]) { Caption = 'External Document No.'; DataClassification = CustomerContent; }
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
        field(200; "Warehouse Line Code"; Code[50]) { Caption = 'Warehouse Line Code'; DataClassification = CustomerContent; TableRelation = lvnWarehouseLine.Code; }
        field(1000; "Void Document No."; Code[20]) { Caption = 'Void Document No.'; DataClassification = CustomerContent; }
        field(10000; "Borrower Search Name"; Code[50]) { Caption = 'Borrower Search Name'; FieldClass = FlowField; CalcFormula = lookup(lvnLoan."Search Name" where("No." = field("Loan No."))); Editable = false; }
    }

    keys
    {
        key(PK; "Document No.") { Clustered = true; }
    }
}