table 14135197 "lvnExpressionValueBuffer"
{
    fields
    {
        field(1; Number; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; Name; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(11; Type; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(12; Value; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Number) { Clustered = true; }
        key(Name; Name) { }
    }
}