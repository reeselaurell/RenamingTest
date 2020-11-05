page 14135186 "lvnFlexImportSchemaConditions"
{
    PageType = List;
    SourceTable = lvnFlexImportSchemaExpression;
    Caption = 'Flexible Import Schema Conditions';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Expression Type"; Rec."Expression Type")
                {
                    ApplicationArea = All;
                }
                field("Expression Code"; Rec."Expression Code")
                {
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                }
                field("Assign Result To Field"; Rec."Assign Result To Field")
                {
                    ApplicationArea = All;
                }
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

                trigger OnAction()
                begin

                end;
            }
        }
    }
}