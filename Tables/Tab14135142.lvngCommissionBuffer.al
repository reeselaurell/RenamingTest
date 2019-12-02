table 14135142 lvngCommissionBuffer
{
    DataClassification = CustomerContent;
    Caption = 'Commission Buffer';

    fields
    {
        field(1; "Loan No."; Code[20]) { DataClassification = CustomerContent; Caption = 'Loan No.'; }
        field(10; "Borrower First Name"; Text[30]) { DataClassification = CustomerContent; Caption = 'Borrower First Name'; }
        field(11; "Borrower Middle Name"; Text[30]) { DataClassification = CustomerContent; Caption = 'Borrower Middle Name'; }
        field(12; "Borrower Last Name"; Text[30]) { DataClassification = CustomerContent; Caption = 'Borrower Last Name'; }
        field(13; "Date Funded"; Date) { DataClassification = CustomerContent; Caption = 'Date Funded'; }
        field(20; "Fee 1 Amount"; Decimal) { DataClassification = CustomerContent; Caption = 'Fee 1 Amount'; }
        field(21; "Fee 2 Amount"; Decimal) { DataClassification = CustomerContent; Caption = 'Fee 2 Amount'; }
        field(22; "Fee 3 Amount"; Decimal) { DataClassification = CustomerContent; Caption = 'Fee 3 Amount'; }
    }

    keys
    {
        key(PK; "Loan No.") { Clustered = true; }
    }
}