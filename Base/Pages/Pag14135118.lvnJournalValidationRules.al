page 14135118 "lvnJournalValidationRules"
{
    PageType = List;
    Caption = 'Loan Journal Validation Rules';
    SourceTable = lvnJournalValidationRule;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Condition Code"; Rec."Condition Code") { ApplicationArea = All; }
                field("Error Message"; Rec."Error Message") { ApplicationArea = All; }
            }
        }
    }
}