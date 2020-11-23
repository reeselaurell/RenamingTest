page 14135171 "lvnQuickPayPresets"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvnQuickPayFilterPreset;
    Caption = 'Quick Pay Presets';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
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

                trigger OnAction()
                begin
                    Rec.MakeFilter();
                    CurrPage.Update(true);
                end;
            }
        }
    }
}