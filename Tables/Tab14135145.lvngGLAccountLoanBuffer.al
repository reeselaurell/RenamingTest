table 14135145 lvngGLAccountLoanBuffer
{
    Caption = 'G/L Account Loan Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "View Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'View Code'; }
        field(2; "Loan No."; Code[20]) { DataClassification = CustomerContent; Caption = 'Loan No.'; }
        field(10; "Custom Text 1"; Text[250]) { DataClassification = CustomerContent; Caption = 'Custom Text 1'; }
        field(30; "Custom Decimal 1"; Decimal) { DataClassification = CustomerContent; Caption = 'Custom Decimal 1'; }
    }

    keys
    {
        key(PK; "View Code", "Loan No.") { Clustered = true; }
    }
}