page 14135171 lvngQuickPayPresets
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
                field(Code; Rec.Code) { ApplicationArea = All; Caption = 'Code'; }
                field(Description; Rec.Description) { ApplicationArea = All; Caption = 'Description'; }
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
                    Rec.MakeFilter();
                    CurrPage.Update(true);
                end;
            }
        }
    }
}