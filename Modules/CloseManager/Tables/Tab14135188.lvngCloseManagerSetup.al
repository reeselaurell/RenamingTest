table 14135188 lvngCloseManagerSetup
{
    DataClassification = CustomerContent;
    Caption = 'Close Manager Setup';

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; DataClassification = CustomerContent; }
        field(10; "Quick Entry Archive Nos."; Code[10]) { Caption = 'Quick Entry Archive Nos.'; DataClassification = CustomerContent; TableRelation = "No. Series"; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}