page 14135165 lvngCalculationUnitList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngCalculationUnit;
    Caption = 'Calculation Units';
    CardPageId = lvngCalculationUnitCard;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Type; Type) { ApplicationArea = All; }
            }
        }
    }
}