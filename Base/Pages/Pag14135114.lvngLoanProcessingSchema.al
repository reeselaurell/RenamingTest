page 14135114 lvngLoanProcessingSchema
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoanProcessingSchema;
    Caption = 'Processing Schemas';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("No. Series"; "No. Series") { ApplicationArea = All; }
                field("Document Type Option"; "Document Type Option") { ApplicationArea = All; }
                field("Global Schema"; "Global Schema") { ApplicationArea = All; }
                field("Use Global Schema Code"; "Use Global Schema Code") { ApplicationArea = All; }
                field("Dimension 1 Rule"; "Dimension 1 Rule") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Dimension 2 Rule"; "Dimension 2 Rule") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Dimension 3 Rule"; "Dimension 3 Rule") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Dimension 4 Rule"; "Dimension 4 Rule") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Dimension 5 Rule"; "Dimension 5 Rule") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Dimension 6 Rule"; "Dimension 6 Rule") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Dimension 7 Rule"; "Dimension 7 Rule") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Dimension 8 Rule"; "Dimension 8 Rule") { ApplicationArea = All; Visible = DimensionVisible8; }
                field("Business Unit Rule"; "Business Unit Rule") { ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ProcessingLines)
            {
                ApplicationArea = All;
                Caption = 'Processing Schema Lines';
                Image = LineDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page lvngLoanProcessingSchemaLines;
                RunPageLink = "Processing Code" = field(Code);
            }
        }
    }

    var
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;
}