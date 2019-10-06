page 14135236 lvngDimPerfBandSchemaList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngDimensionPerfBandSchema;
    Caption = 'Dimension Performance Band List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Dimension Code"; "Dimension Code") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PredefinedSchema)
            {
                Caption = 'Schema Lines';
                Visible = "Dynamic Layout" = false;
                Image = Column;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
            }
        }
    }
}