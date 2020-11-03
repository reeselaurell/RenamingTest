page 14135222 "lvnRptGeneratorSequencePart"
{
    PageType = ListPart;
    SourceTable = lvnReportGeneratorSequence;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Sequence No."; Rec."Sequence No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Row Layout"; Rec."Row Layout") { ApplicationArea = All; }
                field("Band Layout"; Rec."Band Layout") { ApplicationArea = All; }
                field("Expand Filter"; Rec."Expand Filter") { ApplicationArea = All; }
                field("Business Unit Filter"; Rec."Business Unit Filter") { ApplicationArea = All; }
                field("Dimension 1 Filter"; Rec."Dimension 1 Filter") { ApplicationArea = All; }
                field("Dimension 2 Filter"; Rec."Dimension 2 Filter") { ApplicationArea = All; }
                field("Dimension 3 Filter"; Rec."Dimension 3 Filter") { ApplicationArea = All; }
                field("Dimension 4 Filter"; Rec."Dimension 4 Filter") { ApplicationArea = All; }
            }
        }
    }
}