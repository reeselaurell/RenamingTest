page 14135253 lvngCloseManagerTemplateLines
{
    PageType = ListPart;
    SourceTable = lvngCloseManagerTemplateLine;
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

                field("Task Category"; "Task Category") { ApplicationArea = All; }
                field("Task Name"; "Task Name") { ApplicationArea = All; }
                field("Account No."; "Account No.") { ApplicationArea = All; }
                field("Due Date Calculation"; "Due Date Calculation") { ApplicationArea = All; }
                field("Assigned To"; "Assigned To") { ApplicationArea = All; }
                field("Assigned Approver"; "Assigned Approver") { ApplicationArea = All; }
                field(Instructions; Instructions) { ApplicationArea = All; }
            }
        }
    }
}