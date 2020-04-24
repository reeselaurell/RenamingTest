page 14135208 lvngCalculationUnitLines
{
    PageType = ListPart;
    SourceTable = lvngCalculationUnitLine;
    Caption = 'Expression Data Source';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line no."; "Line no.") { ApplicationArea = All; }
                field("Source Unit Code"; "Source Unit Code") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
            }
        }
    }
}