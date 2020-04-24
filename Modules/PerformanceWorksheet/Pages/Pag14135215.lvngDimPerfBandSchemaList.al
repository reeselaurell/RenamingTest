page 14135215 lvngDimPerfBandSchemaList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngDimensionPerfBandSchema;
    Caption = 'Dimension Performance Band Schema List';

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
                ApplicationArea = All;
                Caption = 'Schema Lines';
                Visible = "Dynamic Layout" = false;
                Image = Column;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DimPerfBandSchemaLines: Page lvngDimPerfBandSchemaLines;
                    DimPerfBandSchemaLine: Record lvngDimPerfBandSchemaLine;
                begin
                    DimPerfBandSchemaLine.Reset();
                    DimPerfBandSchemaLine.SetRange("Schema Code", Code);
                    Clear(DimPerfBandSchemaLines);
                    DimPerfBandSchemaLines.SetParams("Dimension Code");
                    DimPerfBandSchemaLines.SetTableView(DimPerfBandSchemaLine);
                    DimPerfBandSchemaLines.RunModal();
                end;
            }
            action(DynamicSchema)
            {
                ApplicationArea = All;
                Caption = 'Schema Lines';
                Visible = "Dynamic Layout" = true;
                Image = DimensionSets;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page lvngDynamicDimensionLinks;
            }
        }
    }
}