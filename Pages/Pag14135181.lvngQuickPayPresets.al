page 14135181 lvngQuickPayPresets
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngQuickPayFilterPreset;
    Caption = 'Quick Pay Presets';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; Caption = 'Code'; }
                field(Description; Description) { ApplicationArea = All; Caption = 'Description'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EditFilters)
            {
                ApplicationArea = All;
                Caption = 'Edit Filters';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    MakeFilter();
                    CurrPage.Update(true);
                end;
            }
        }
    }
}