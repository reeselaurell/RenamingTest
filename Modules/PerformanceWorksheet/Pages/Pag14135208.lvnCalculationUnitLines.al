page 14135208 "lvnCalculationUnitLines"
{
    PageType = ListPart;
    SourceTable = lvnCalculationUnitLine;
    Caption = 'Expression Data Source';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line no."; Rec."Line no.")
                {
                    ApplicationArea = All;
                }
                field("Source Unit Code"; Rec."Source Unit Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}