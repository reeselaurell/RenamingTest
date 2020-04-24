page 14135222 lvngRptGeneratorSequencePart
{
    PageType = ListPart;
    SourceTable = lvngReportGeneratorSequence;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Sequence No."; "Sequence No.") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Row Layout"; "Row Layout") { ApplicationArea = All; }
                field("Band Layout"; "Band Layout") { ApplicationArea = All; }
                field("Expand Filter"; "Expand Filter") { ApplicationArea = All; }
                field("Business Unit Filter"; "Business Unit Filter") { ApplicationArea = All; }
                field("Dimension 1 Filter"; "Dimension 1 Filter") { ApplicationArea = All; }
                field("Dimension 2 Filter"; "Dimension 2 Filter") { ApplicationArea = All; }
                field("Dimension 3 Filter"; "Dimension 3 Filter") { ApplicationArea = All; }
                field("Dimension 4 Filter"; "Dimension 4 Filter") { ApplicationArea = All; }
            }
        }
    }
}