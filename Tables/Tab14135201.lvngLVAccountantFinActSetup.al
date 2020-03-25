table 14135201 lvngLVAccountantFinActSetup
{
    DataClassification = CustomerContent;
    Caption = 'Activities Setup';

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; DataClassification = CustomerContent; }
        field(10; "Loans Held, for Sale Accounts"; Text[250]) { Caption = 'Loans Held, for Sale Category'; DataClassification = CustomerContent; TableRelation = "G/L Account Category"; }
        field(11; "Accounts Payable Accounts"; Text[250]) { Caption = 'Accounts Payable Category'; DataClassification = CustomerContent; TableRelation = "G/L Account Category"; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}