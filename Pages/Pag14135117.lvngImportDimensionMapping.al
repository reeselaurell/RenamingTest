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
                field(lvngDimensionCode; lvngDimensionCode)
                {
                    ApplicationArea = All;
                }
                field(lvngMappingValue; lvngMappingValue)
                {
                    ApplicationArea = All;
                }
                field(lvngDimensionValueCode; lvngDimensionValueCode)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}