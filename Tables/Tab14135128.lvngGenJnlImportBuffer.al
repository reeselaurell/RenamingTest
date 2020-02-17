table 14135128 lvngGenJnlImportBuffer
{
    DataClassification = CustomerContent;
    Caption = 'General Journal Import Buffer';

    fields
    {
        field(1; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(10; "Account Type"; enum lvngGenJnlAccountType) { Caption = 'Account Type'; DataClassification = CustomerContent; }
        field(11; "Account No."; Code[20]) { Caption = 'Account No.'; DataClassification = CustomerContent; }
        field(12; "Document Type"; Enum lvngGenJnlImportDocumentType) { Caption = 'Document Type'; DataClassification = CustomerContent; }
        field(13; "Document No."; Code[20]) { Caption = 'Document No.'; DataClassification = CustomerContent; }
        field(14; "External Document No."; Code[35]) { Caption = 'External Document No.'; DataClassification = CustomerContent; }
        field(15; Description; Text[100]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(16; Comment; Text[250]) { Caption = 'Comment'; DataClassification = CustomerContent; }
        field(17; "Bal. Account Type"; enum lvngGenJnlAccountType) { Caption = 'Bal. Account Type'; DataClassification = CustomerContent; }
        field(18; "Bal. Account No."; Code[20]) { Caption = 'Bal. Account No.'; DataClassification = CustomerContent; }
        field(19; "Reason Code"; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; }
        field(20; "Posting Group"; Code[20]) { Caption = 'Posting Group'; DataClassification = CustomerContent; }
        field(21; Amount; Decimal) { Caption = 'Amount'; DataClassification = CustomerContent; }
        field(22; "Applies-To Doc. Type"; Enum lvngGenJnlImportDocumentType) { Caption = 'Applies-to Doc. Type'; DataClassification = CustomerContent; }
        field(23; "Applies-To Doc. No."; Code[20]) { Caption = 'Applies-to Doc. No.'; DataClassification = CustomerContent; }
        field(24; "Payment Method Code"; Code[10]) { Caption = 'Payment Method Code'; DataClassification = CustomerContent; }
        field(25; "Posting Date"; Date) { Caption = 'Posting Date'; DataClassification = CustomerContent; }
        field(26; "Document Date"; Date) { Caption = 'Document Date'; DataClassification = CustomerContent; }
        field(27; "Due Date"; Date) { Caption = 'Due Date'; DataClassification = CustomerContent; }
        field(28; "Recurring Method"; enum lvngRecurrencyMethod) { Caption = 'Recurring Method'; DataClassification = CustomerContent; }
        field(29; "Recurring Frequency"; DateFormula) { Caption = 'Recurring Frequency'; DataClassification = CustomerContent; }
        field(30; "Bank Payment Type"; enum lvngBankPaymentType) { Caption = 'Bank Payment Type'; DataClassification = CustomerContent; }
        field(31; "Depreciation Book Code"; Code[10]) { Caption = 'Depreciation Book Code'; DataClassification = CustomerContent; }
        field(32; "FA Posting Type"; Enum lvngFAPostingType) { Caption = 'FA Posting Type'; DataClassification = CustomerContent; }
        field(80; "Global Dimension 1 Code"; Code[20]) { Caption = 'Global Dimension 1 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,1'; }
        field(81; "Global Dimension 2 Code"; Code[20]) { Caption = 'Global Dimension 2 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,2'; }
        field(82; "Shortcut Dimension 3 Code"; Code[20]) { Caption = 'Shortcut Dimension 3 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,3'; }
        field(83; "Shortcut Dimension 4 Code"; Code[20]) { Caption = 'Shortcut Dimension 4 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,4'; }
        field(84; "Shortcut Dimension 5 Code"; Code[20]) { Caption = 'Shortcut Dimension 5 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,5'; }
        field(85; "Shortcut Dimension 6 Code"; Code[20]) { Caption = 'Shortcut Dimension 6 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,6'; }
        field(86; "Shortcut Dimension 7 Code"; Code[20]) { Caption = 'Shortcut Dimension 7 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,7'; }
        field(87; "Shortcut Dimension 8 Code"; Code[20]) { Caption = 'Shortcut Dimension 8 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,8'; }
        field(88; "Business Unit Code"; Code[20]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; }
        field(90; "Global Dimension 1 Value"; Text[50]) { Caption = 'Global Dimension 1 Value'; DataClassification = CustomerContent; }
        field(91; "Global Dimension 2 Value"; Text[50]) { Caption = 'Global Dimension 2 Value'; DataClassification = CustomerContent; }
        field(92; "Shortcut Dimension 3 Value"; Text[50]) { Caption = 'Shortcut Dimension 3 Value'; DataClassification = CustomerContent; }
        field(93; "Shortcut Dimension 4 Value"; Text[50]) { Caption = 'Shortcut Dimension 4 Value'; DataClassification = CustomerContent; }
        field(94; "Shortcut Dimension 5 Value"; Text[50]) { Caption = 'Shortcut Dimension 5 Value'; DataClassification = CustomerContent; }
        field(95; "Shortcut Dimension 6 Value"; Text[50]) { Caption = 'Shortcut Dimension 6 Value'; DataClassification = CustomerContent; }
        field(96; "Shortcut Dimension 7 Value"; Text[50]) { Caption = 'Shortcut Dimension 7 Value'; DataClassification = CustomerContent; }
        field(97; "Shortcut Dimension 8 Value"; Text[50]) { Caption = 'Shortcut Dimension 8 Value'; DataClassification = CustomerContent; }
        field(98; "Account Value"; Text[50]) { Caption = 'Account Value'; DataClassification = CustomerContent; }
        field(99; "Bal. Account Value"; Text[50]) { Caption = 'Bal. Account Value'; DataClassification = CustomerContent; }
        field(100; "Business Unit Value"; Text[50]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; }
        field(101; "Flexible Line No."; Integer) { Caption = 'Flexible Line No.'; DataClassification = CustomerContent; }
        field(102; "Use Dimension Hierarchy"; Boolean) { Caption = 'Use Dimension Hierarchy'; DataClassification = CustomerContent; }
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; }
        field(14135108; "Servicing Type"; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Line No.") { Clustered = true; }
    }
}