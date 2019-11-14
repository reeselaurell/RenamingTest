page 14135403 lvngBranchUserMapping
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
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CalculateHierarchy;
                Caption = 'Auto Sequence';

                trigger OnAction()
                begin
                    Error('Not Implemented');
                end;
            }
        }
    }
}