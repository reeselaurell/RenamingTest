page 14135173 "lvnForm1098Rules"
{
    Caption = 'Form 1098 Rules';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvnForm1098CollectionRule;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Box No."; Rec."Box No.")
                {
                    ApplicationArea = All;
                    Caption = 'Box No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RuleCollection)
            {
                ApplicationArea = All;
                Caption = 'Rules Collection';
                Image = SalesTax;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page lvnForm1098RulesCollection;
                RunPageView = sorting("Box No.", "Line No.");
                RunPageLink = "Box No." = field("Box No.");
            }
        }
    }
}