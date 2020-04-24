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
            repeater(Group)
            {
                field("Dimension Code"; "Dimension Code") { ApplicationArea = All; }
                field("Mapping Value"; "Mapping Value") { ApplicationArea = All; }
                field("Dimension Value Code"; "Dimension Value Code") { ApplicationArea = All; }
            }
        }
    }
}