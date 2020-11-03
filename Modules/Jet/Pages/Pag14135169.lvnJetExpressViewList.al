page 14135169 "lvnJetExpressViewList"
{
    Caption = 'Jet Express View List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvnLoanNormalizedViewSetup;
    CardPageId = lvnJetExpressViewCard;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field(Code; Rec.Code) { ApplicationArea = All; Editable = false; Lookup = true; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Last Update Date Time"; Rec."Last Update DateTime") { ApplicationArea = All; }
                field("Last Updated By"; Rec."Last Updated By") { ApplicationArea = All; }
                field("Entries Count"; Rec."Entries Count") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshViewData)
            {
                Caption = 'Refresh View Data';
                ApplicationArea = All;
                Image = RefreshLines;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RefreshJetExpressView: Report lvnRefreshJetExpressView;
                begin
                    Clear(RefreshJetExpressView);
                    RefreshJetExpressView.SetView(Rec.Code);
                    RefreshJetExpressView.RunModal();
                end;
            }
        }
    }
}