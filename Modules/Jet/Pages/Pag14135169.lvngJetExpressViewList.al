page 14135169 lvngJetExpressViewList
{
    Caption = 'Jet Express View List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngLoanNormalizedViewSetup;
    CardPageId = lvngJetExpressViewCard;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field(Code; Code) { ApplicationArea = All; Editable = false; Lookup = true; }
                field(Description; Description) { ApplicationArea = All; }
                field("Last Update Date Time"; "Last Update DateTime") { ApplicationArea = All; }
                field("Last Updated By"; "Last Updated By") { ApplicationArea = All; }
                field("Entries Count"; "Entries Count") { ApplicationArea = All; }
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
                    RefreshJetExpressView: Report lvngRefreshJetExpressView;
                begin
                    Clear(RefreshJetExpressView);
                    RefreshJetExpressView.SetView(Code);
                    RefreshJetExpressView.RunModal();
                end;
            }
        }
    }
}