table 14135165 lvngGLAccountLoanBuffer
{
    Caption = 'G/L Account Loan Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "View Code"; Code[20])
        {
            Caption = 'View Code';
            DataClassification = CustomerContent;
        }
        field(10; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(11; "Text Value"; Text[50])
        {
            Caption = 'Text Value';
            DataClassification = CustomerContent;
        }
        field(12; "Decimal Value"; Decimal)
        {
            Caption = 'Decimal Value';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "View Code")
        {
            Clustered = true;
        }
    }
}