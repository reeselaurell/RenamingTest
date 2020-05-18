table 14135250 lvngPayablesFinActSetup
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; DataClassification = CustomerContent; }
        field(10; "Filter by User"; Code[50]) { Caption = 'Filter by User'; DataClassification = CustomerContent; TableRelation = User."User Security ID"; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}