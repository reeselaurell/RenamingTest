page 14135124 "lvnLoanImportValueEdit"
{
    PageType = List;
    SourceTable = lvnLoanJournalValue;
    Caption = 'Edit Values';
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Field No."; Rec."Field No.") { ApplicationArea = All; }
                field("Field Name"; Rec."Field Name") { ApplicationArea = All; }
                field("Field Value"; Rec."Field Value") { ApplicationArea = All; }
            }
        }
    }
}