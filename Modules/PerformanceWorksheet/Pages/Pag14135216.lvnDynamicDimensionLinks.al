page 14135216 "lvnDynamicDimensionLinks"
{
    PageType = List;
    SourceTable = Dimension;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Caption = 'Dynamic Dimension Links';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DefineLinks)
            {
                ApplicationArea = All;
                Caption = 'Define Dimension Links';
                Image = DimensionSets;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page lvnDynamicBandLinks;
                RunPageView = sorting("Dimension Code", "Dimension Value Code");
                RunPageLink = "Dimension Code" = field(Code);
            }
        }
    }
}