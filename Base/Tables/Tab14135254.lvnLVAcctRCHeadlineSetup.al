table 14135254 "lvnLVAcctRCHeadlineSetup"
{
    Caption = 'Headline Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; DataClassification = CustomerContent; }
        field(10; "Branch Performace Date Range"; Enum lvnLVAcctDateRange) { Caption = 'Branch Performance Date Range'; DataClassification = CustomerContent; }
        field(11; "LO Performace Date Range"; Enum lvnLVAcctDateRange) { Caption = 'LO Performance Date Range'; DataClassification = CustomerContent; }
        field(12; "Net Income G/L Account No."; Code[20]) { Caption = 'Net Income G/L Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}