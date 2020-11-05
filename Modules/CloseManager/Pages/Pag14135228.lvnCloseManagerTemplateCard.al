page 14135228 "lvnCloseManagerTemplateCard"
{
    PageType = Card;
    SourceTable = lvnCloseManagerTemplateHeader;
    Caption = 'Close Manager Template Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; lvnCloseManagerTemplateLines)
            {
                Caption = 'Lines';
                SubPageLink = "Template No." = field("No.");
                ApplicationArea = All;
            }
        }
    }
}