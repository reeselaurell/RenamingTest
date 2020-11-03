page 14135227 "lvnCloseManagerTemplateList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvnCloseManagerTemplateHeader;
    CardPageId = lvnCloseManagerTemplateCard;
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