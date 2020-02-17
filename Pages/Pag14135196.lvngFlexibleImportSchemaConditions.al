page 14135196 lvngFlexImportSchemaConditions
{
    PageType = List;
    SourceTable = lvngFlexImportSchemaExpression;
    Caption = 'Flexible Import Schema Conditions';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Expression Type"; "Expression Type") { ApplicationArea = All; }
                field("Expression Code"; "Expression Code") { ApplicationArea = All; }
                field(Value; Value) { ApplicationArea = All; }
                field("Assign Result To Field"; "Assign Result To Field") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}