page 14135251 lvngCloseManagerTemplateList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngCloseManagerTemplateHeader;
    CardPageId = lvngCloseManagerTemplateCard;
    Caption = 'Close Manager Templates';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("No."; "No.") { ApplicationArea = All; }
                field(Name; Name) { ApplicationArea = All; }
            }
        }
    }
}