page 14135227 lvngCloseManagerTemplateList
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

                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
            }
        }
    }
}