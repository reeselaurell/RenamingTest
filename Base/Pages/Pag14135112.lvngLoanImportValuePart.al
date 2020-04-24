page 14135112 lvngLoanImportValuePart
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
                field("Field No."; "Field No.") { ApplicationArea = All; }
                field("Field Name"; "Field Name") { ApplicationArea = All; }
                field("Field Value"; "Field Value") { ApplicationArea = All; }
            }
        }
    }
}