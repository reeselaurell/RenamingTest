page 14135234 lvngCloseManagerCategoryList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngCloseManagerCategory;
    Caption = 'Close Manager Categories';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
        }
    }
}