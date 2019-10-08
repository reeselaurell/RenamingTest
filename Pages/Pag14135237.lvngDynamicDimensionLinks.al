page 14135237 lvngDynamicDimensionLinks
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
                field(Code; Code) { ApplicationArea = All; }
                field(Name; Name) { ApplicationArea = All; }
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
                RunObject = page lvngDynamicBandLinks;
                RunPageView = sorting("Dimension Code", "Dimension Value Code");
                RunPageLink = "Dimension Code" = field(Code);
            }
        }
    }
}