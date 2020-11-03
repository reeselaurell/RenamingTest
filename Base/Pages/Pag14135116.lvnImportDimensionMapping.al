page 14135116 "lvnImportDimensionMapping"
{
    Caption = 'Import Dimension Mappings';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnImportDimensionMapping;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Dimension Code"; Rec."Dimension Code") { ApplicationArea = All; }
                field("Mapping Value"; Rec."Mapping Value") { ApplicationArea = All; }
                field("Dimension Value Code"; Rec."Dimension Value Code") { ApplicationArea = All; }
            }
        }
    }
}