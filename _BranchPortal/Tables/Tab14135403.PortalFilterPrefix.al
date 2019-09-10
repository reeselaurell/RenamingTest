table 14135403 lvngPortalFilterPrefix
{
    fields
    {
        field(1; Type; Enum lvngPortalLevel) { DataClassification = CustomerContent; }
        field(2; "Prefix Code"; Code[20]) { DataClassification = CustomerContent; }
        field(10; Filter; Text[250]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Type, "Prefix Code") { Clustered = true; }
    }
}