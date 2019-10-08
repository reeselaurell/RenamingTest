page 14135238 lvngDynamicBandLinks
{
    PageType = List;
    SourceTable = lvngDynamicBandLink;
    Caption = 'Dynamic Band Links';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Dimension Value Code"; "Dimension Value Code") { ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; }
                field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetAllValues)
            {
                ApplicationArea = All;
                Caption = 'Get All Values';
                Image = GetLines;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction();
                var
                    DimensionValue: Record "Dimension Value";
                    DynamicBandLink: Record lvngDynamicBandLink;
                begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Dimension Code", "Dimension Code");
                    DimensionValue.FindSet();
                    repeat
                        Clear(DynamicBandLink);
                        DynamicBandLink."Dimension Code" := "Dimension Code";
                        DynamicBandLink."Dimension Value Code" := DimensionValue.Code;
                        if DynamicBandLink.Insert() then;
                        CurrPage.Update(false);
                        Message(UpdatedMsg);
                    until DimensionValue.Next() = 0;
                end;
            }
            /** It is empty in LV BC OnPrem
            action(Update)
            {
                ApplicationArea = All;
                Caption = 'Update from Dimension Code Links';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                end;
            }
            */
        }
    }

    var
        UpdatedMsg: Label 'Updated';
}