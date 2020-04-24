page 14135228 lvngCloseManagerTemplateCard
{
    PageType = Card;
    SourceTable = lvngCloseManagerTemplateHeader;
    Caption = 'Close Manager Template Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; "No.") { ApplicationArea = All; }
                field(Name; Name) { ApplicationArea = All; }
            }

            part(Lines; lvngCloseManagerTemplateLines)
            {
                Caption = 'Lines';
                SubPageLink = "Template No." = field("No.");
                ApplicationArea = All;
            }
        }
    }
}