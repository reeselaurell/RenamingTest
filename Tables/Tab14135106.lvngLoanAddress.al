table 14135106 "lvngLoanAddress"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Address';

    fields
    {
        field(1; "Loan No."; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(2; "Address Type"; Enum lvngAddressType) { DataClassification = CustomerContent; }
        field(10; Address; Text[50]) { DataClassification = CustomerContent; }
        field(11; "Address 2"; Text[50]) { DataClassification = CustomerContent; }
        field(12; City; Text[30]) { DataClassification = CustomerContent; }
        field(13; State; Text[30]) { DataClassification = CustomerContent; }
        field(14; "ZIP Code"; Code[20]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Loan No.", "Address Type") { Clustered = true; }
    }

}