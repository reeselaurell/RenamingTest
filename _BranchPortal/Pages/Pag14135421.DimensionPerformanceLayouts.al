page 14135421 lvngDimensionPerfLayouts
{
    PageType = List;
    SourceTable = lvngDimensionPerformanceLayout;
    Caption = 'Dimension Performance Layouts';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}