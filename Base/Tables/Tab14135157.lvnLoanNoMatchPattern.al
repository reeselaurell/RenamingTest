table 14135157 "lvnLoanNoMatchPattern"
{
    DataClassification = CustomerContent;
    Caption = 'Loan No. Match Pattern';
    LookupPageId = lvnLoanNoMatchPatterns;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; Caption = 'Code'; }
        field(10; Description; Text[100]) { DataClassification = CustomerContent; Caption = 'Description'; }
        field(11; "Min. Field Length"; Integer) { DataClassification = CustomerContent; Caption = 'Min. Field Length'; }
        field(12; "Max. Field Length"; Integer) { DataClassification = CustomerContent; Caption = 'Max. Field Length'; }
        field(13; "Match Pattern"; Text[250]) { DataClassification = CustomerContent; Caption = 'Match Pattern'; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}