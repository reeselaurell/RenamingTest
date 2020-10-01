page 14135111 lvngLoanImportValuePart
{
    PageType = ListPart;
    SourceTable = lvngLoanJournalValue;
    Caption = 'Values';
    DeleteAllowed = false;
    Editable = false;

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