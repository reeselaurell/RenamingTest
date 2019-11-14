page 14135117 lvngImportDimensionMapping
{
    Caption = 'Import Dimension Mappings';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngImportDimensionMapping;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngDimensionCode; "Dimension Code")
                {
                    ApplicationArea = All;
                }
                field(lvngMappingValue; "Mapping Value")
                {
                    ApplicationArea = All;
                }
                field(lvngDimensionValueCode; "Dimension Value Code")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}