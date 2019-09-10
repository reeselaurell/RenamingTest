page 14135402 lvngBranchUserMapping
{
    PageType = List;
    SourceTable = lvngBranchUserMapping;
    Caption = 'Branch User Mapping';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID") { ApplicationArea = All; }
                field(Type; Type) { ApplicationArea = All; }
                field(Code; Code) { ApplicationArea = All; }
                field(Sequence; Sequence) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AutoSequence)
            {
                Caption = 'Auto Sequence';
                Image = CalculateHierarchy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Message(RegeneratePermissionReminderMsg);
    end;

    var
        NotLinkedItemsExistMsg: Label 'There are some items in the list which cannot be automatically arranged. They will not appear on the branch portal unless you specify their sequence manually.';
        RegeneratePermissionReminderMsg: Label 'Please make sure to select Regenerate Permissions box on Branch User page and press Generate Permissions button on ribbon to complete configuration.';
}