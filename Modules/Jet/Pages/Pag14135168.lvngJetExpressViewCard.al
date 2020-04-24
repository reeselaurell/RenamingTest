page 14135168 lvngJetExpressViewCard
{
    Caption = 'Jet Express View Card';
    PageType = Card;
    SourceTable = lvngLoanNormalizedViewSetup;

    layout
    {
        area(Content)
        {
            group(TextFields)
            {
                Caption = 'Text Fields';

                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Custom Text 1"; "Custom Text 1") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Text)); }
                field("Custom Text 2"; "Custom Text 2") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Text)); }
                field("Custom Text 3"; "Custom Text 3") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Text)); }
                field("Custom Text 4"; "Custom Text 4") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Text)); }
                field("Custom Text 5"; "Custom Text 5") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Text)); }
                field("Custom Text 6"; "Custom Text 6") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Text)); }
                field("Custom Text 7"; "Custom Text 7") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Text)); }
                field("Custom Text 8"; "Custom Text 8") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Text)); }
                field("Custom Text 9"; "Custom Text 9") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Text)); }
                field("Custom Text 10"; "Custom Text 10") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Text)); }
            }

            group(DecimalFields)
            {
                Caption = 'Decimal Fields';

                field("Custom Decimal 1"; "Custom Decimal 1") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 2"; "Custom Decimal 2") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 3"; "Custom Decimal 3") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 4"; "Custom Decimal 4") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 5"; "Custom Decimal 5") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 6"; "Custom Decimal 6") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 7"; "Custom Decimal 7") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 8"; "Custom Decimal 8") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 9"; "Custom Decimal 9") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 10"; "Custom Decimal 10") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 11"; "Custom Decimal 11") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 12"; "Custom Decimal 12") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 13"; "Custom Decimal 13") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 14"; "Custom Decimal 14") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 15"; "Custom Decimal 15") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 16"; "Custom Decimal 16") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 17"; "Custom Decimal 17") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 18"; "Custom Decimal 18") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 19"; "Custom Decimal 19") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
                field("Custom Decimal 20"; "Custom Decimal 20") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Decimal)); }
            }

            group(DateFields)
            {
                Caption = 'Date Fields';

                field("Custom Date 1"; "Custom Date 1") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Date)); }
                field("Custom Date 2"; "Custom Date 2") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Date)); }
                field("Custom Date 3"; "Custom Date 3") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Date)); }
                field("Custom Date 4"; "Custom Date 4") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Date)); }
                field("Custom Date 5"; "Custom Date 5") { ApplicationArea = All; TableRelation = lvngLoanFieldsConfiguration where("Value Type" = filter(Date)); }
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
                PromotedCategory = Process;
                PromotedIsBig = true;

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