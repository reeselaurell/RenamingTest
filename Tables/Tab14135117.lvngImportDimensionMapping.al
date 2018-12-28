table 14135117 "lvngImportDimensionMapping"
{
    Caption = 'Import Dimension Mapping';
    DataClassification = CustomerContent;
    LookupPageId = lvngImportDimensionMapping;

    fields
    {
        field(1; lvngDimensionCode; Code[20])
        {
            Caption = 'Dimension Code';
            DataClassification = CustomerContent;
        }
        field(2; lvngMappingValue; Code[50])
        {
            Caption = 'Mapping Value';
            DataClassification = CustomerContent;
        }
        field(10; lvngDimensionValueCode; code[20])
        {
            Caption = 'Dimension Value Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where ("Dimension Code" = field (lvngDimensionCode));
        }
    }

    keys
    {
        key(PK; lvngDimensionCode, lvngMappingValue)
        {
            Clustered = true;
        }
    }

}