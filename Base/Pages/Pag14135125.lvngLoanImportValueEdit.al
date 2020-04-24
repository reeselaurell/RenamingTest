page 14135125 lvngLoanImportValueEdit
{
    PageType = List;
    SourceTable = lvngLoanJournalValue;
    Caption = 'Edit Values';
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Field No."; "Field No.") { ApplicationArea = All; }
                field("Field Name"; "Field Name") { ApplicationArea = All; }
                field("Field Value"; "Field Value") { ApplicationArea = All; }
            }
        }
    }
}