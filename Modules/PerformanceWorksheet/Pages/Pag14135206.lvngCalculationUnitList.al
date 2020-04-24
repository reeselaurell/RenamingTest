page 14135206 lvngCalculationUnitList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngCalculationUnit;
    Caption = 'Calculation Units';

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

    actions
    {
        area(Processing)
        {
            action(Details)
            {
                ApplicationArea = All;
                Caption = 'Details';
                Image = FiledOverview;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CalculationUnitCard: Page lvngCalculationUnitCard;
                begin
                    Clear(CalculationUnitCard);
                    CalculationUnitCard.SetRecord(Rec);
                    CalculationUnitCard.RunModal();
                end;
            }
        }
    }
}