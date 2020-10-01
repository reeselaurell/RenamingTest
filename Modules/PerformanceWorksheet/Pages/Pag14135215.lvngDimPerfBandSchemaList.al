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
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Dimension Code"; Rec."Dimension Code") { ApplicationArea = All; }
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
                Visible = Rec."Dynamic Layout" = false;
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
                    DimPerfBandSchemaLine.SetRange("Schema Code", Rec.Code);
                    Clear(DimPerfBandSchemaLines);
                    DimPerfBandSchemaLines.SetParams(Rec."Dimension Code");
                    DimPerfBandSchemaLines.SetTableView(DimPerfBandSchemaLine);
                    DimPerfBandSchemaLines.RunModal();
                end;
            }
            action(DynamicSchema)
            {
                ApplicationArea = All;
                Caption = 'Schema Lines';
                Visible = Rec."Dynamic Layout" = true;
                Image = DimensionSets;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page lvngDynamicDimensionLinks;
            }
        }
    }
}