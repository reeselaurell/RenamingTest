page 14135119 lvngJournalValidationRules
{
    PageType = List;
    Caption = 'Loan Journal Validation Rules';
    SourceTable = lvngJournalValidationRule;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Condition Code"; "Condition Code") { ApplicationArea = All; }
                field("Error Message"; "Error Message") { ApplicationArea = All; }
            }
        }
    }
}