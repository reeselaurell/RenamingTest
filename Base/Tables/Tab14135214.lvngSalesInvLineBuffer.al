table 14135214 lvngSalesInvLineBuffer
{
    Caption = 'Sales Invoice Line Buffer';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Document No."; Code[20]) { Caption = 'Document No.'; DataClassification = CustomerContent; TableRelation = lvngSalesInvHdrBuffer."No."; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(10; "No."; Code[20]) { Caption = 'No.'; DataClassification = CustomerContent; }
        field(11; "Unit Price"; Decimal) { Caption = 'Unit Price'; DataClassification = CustomerContent; }
        field(12; "Description"; Text[50]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(13; "Description 2"; Text[50]) { Caption = 'Description 2'; DataClassification = CustomerContent; }
        field(14; "Shortcut Dimension 1 Code"; Code[20]) { CaptionClass = '1,1,1'; DataClassification = CustomerContent; }
        field(15; "Shortcut Dimension 2 Code"; Code[20]) { CaptionClass = '1,1,2'; DataClassification = CustomerContent; }
        field(16; "Shortcut Dimension 3 Code"; Code[20]) { CaptionClass = '1,2,3'; DataClassification = CustomerContent; }
        field(17; "Shortcut Dimension 4 Code"; Code[20]) { CaptionClass = '1,2,4'; DataClassification = CustomerContent; }
        field(18; "Shortcut Dimension 5 Code"; Code[20]) { CaptionClass = '1,2,5'; DataClassification = CustomerContent; }
        field(19; "Shortcut Dimension 6 Code"; Code[20]) { CaptionClass = '1,2,6'; DataClassification = CustomerContent; }
        field(20; "Shortcut Dimension 7 Code"; Code[20]) { CaptionClass = '1,2,7'; DataClassification = CustomerContent; }
        field(21; "Shortcut Dimension 8 Code"; Code[20]) { CaptionClass = '1,2,8'; DataClassification = CustomerContent; }
        field(22; "Business Unit Code"; Code[20]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; }
        field(23; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(24; Type; Enum "Sales Line Type") { Caption = 'Type'; DataClassification = CustomerContent; }
        field(25; "Loan No. Validation"; Enum lvngLoanNoValidationRule) { Caption = 'Loan No. Validation'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Document No.", "Line No.") { Clustered = true; }
    }
}