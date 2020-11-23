page 14135217 "lvnDynamicBandLinks"
{
    PageType = List;
    SourceTable = lvnDynamicBandLink;
    Caption = 'Dynamic Band Links';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Dimension Value Code"; Rec."Dimension Value Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
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
            action(GetAllValues)
            {
                ApplicationArea = All;
                Caption = 'Get All Values';
                Image = GetLines;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                var
                    DimensionValue: Record "Dimension Value";
                    DynamicBandLink: Record lvnDynamicBandLink;
                begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Dimension Code", Rec."Dimension Code");
                    DimensionValue.FindSet();
                    repeat
                        Clear(DynamicBandLink);
                        DynamicBandLink."Dimension Code" := Rec."Dimension Code";
                        DynamicBandLink."Dimension Value Code" := DimensionValue.Code;
                        if DynamicBandLink.Insert() then;
                        CurrPage.Update(false);
                        Message(UpdatedMsg);
                    until DimensionValue.Next() = 0;
                end;
            }
        }
        /* It is empty in LV BC OnPrem
               action(Update)
                   ApplicationArea = All;
                   Caption = 'Update from Dimension Code Links';
                   Image = UpdateDescription;
                   Promoted = true;
                   PromotedCategory = Process;
                   PromotedIsBig = true;

                   trigger OnAction()
                   begin
                   end;
        */
    }

    var
        UpdatedMsg: Label 'Updated';
}