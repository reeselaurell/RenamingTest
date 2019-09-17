table 14135150 "lvngPerformanceSchema"
{
    Caption = 'Performance Schema';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; lvngPerformanceSchemaType; enum lvngPerformanceSchemaType)
        {
            Caption = 'Schema Type';
            DataClassification = CustomerContent;
        }
        field(11; lvngDescription; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }

}