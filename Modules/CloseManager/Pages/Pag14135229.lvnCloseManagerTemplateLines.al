page 14135229 "lvnCloseManagerTemplateLines"
{
    PageType = ListPart;
    SourceTable = lvnCloseManagerTemplateLine;
    DelayedInsert = true;
    AutoSplitKey = true;
    PopulateAllFields = true;
    Caption = 'Close Manager Template Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Task Category"; Rec."Task Category") { ApplicationArea = All; }
                field("Task Name"; Rec."Task Name") { ApplicationArea = All; }
                field("Account No."; Rec."Account No.") { ApplicationArea = All; }
                field("Due Date Calculation"; Rec."Due Date Calculation") { ApplicationArea = All; }
                field("Assigned To"; Rec."Assigned To") { ApplicationArea = All; }
                field("Assigned Approver"; Rec."Assigned Approver") { ApplicationArea = All; }
                field(Instructions; Rec.Instructions) { ApplicationArea = All; }
            }
        }
    }
}