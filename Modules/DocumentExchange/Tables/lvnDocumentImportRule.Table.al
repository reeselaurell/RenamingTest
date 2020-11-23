table 14135202 "lvnDocumentImportRule"
{
    fields
    {
        field(1; Prefix; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Fall Through"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(10; Order; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Table No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Field Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Table View"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Prefix, "Fall Through") { Clustered = true; }
        key(Order; Order) { }
    }
}