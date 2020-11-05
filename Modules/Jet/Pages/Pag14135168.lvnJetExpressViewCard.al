page 14135168 "lvnJetExpressViewCard"
{
    Caption = 'Jet Express View Card';
    PageType = Card;
    SourceTable = lvnLoanNormalizedViewSetup;

    layout
    {
        area(Content)
        {
            group(TextFields)
            {
                Caption = 'Text Fields';

                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Custom Text 1"; Rec."Custom Text 1")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Text));
                }
                field("Custom Text 2"; Rec."Custom Text 2")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Text));
                }
                field("Custom Text 3"; Rec."Custom Text 3")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Text));
                }
                field("Custom Text 4"; Rec."Custom Text 4")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Text));
                }
                field("Custom Text 5"; Rec."Custom Text 5")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Text));
                }
                field("Custom Text 6"; Rec."Custom Text 6")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Text));
                }
                field("Custom Text 7"; Rec."Custom Text 7")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Text));
                }
                field("Custom Text 8"; Rec."Custom Text 8")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Text));
                }
                field("Custom Text 9"; Rec."Custom Text 9")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Text));
                }
                field("Custom Text 10"; Rec."Custom Text 10")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Text));
                }
            }
            group(DecimalFields)
            {
                Caption = 'Decimal Fields';

                field("Custom Decimal 1"; Rec."Custom Decimal 1")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 2"; Rec."Custom Decimal 2")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 3"; Rec."Custom Decimal 3")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 4"; Rec."Custom Decimal 4")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 5"; Rec."Custom Decimal 5")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 6"; Rec."Custom Decimal 6")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 7"; Rec."Custom Decimal 7")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 8"; Rec."Custom Decimal 8")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 9"; Rec."Custom Decimal 9")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 10"; Rec."Custom Decimal 10")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 11"; Rec."Custom Decimal 11")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 12"; Rec."Custom Decimal 12")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 13"; Rec."Custom Decimal 13")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 14"; Rec."Custom Decimal 14")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 15"; Rec."Custom Decimal 15")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 16"; Rec."Custom Decimal 16")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 17"; Rec."Custom Decimal 17")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 18"; Rec."Custom Decimal 18")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 19"; Rec."Custom Decimal 19")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
                field("Custom Decimal 20"; Rec."Custom Decimal 20")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Decimal));
                }
            }
            group(DateFields)
            {
                Caption = 'Date Fields';

                field("Custom Date 1"; Rec."Custom Date 1")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Date));
                }
                field("Custom Date 2"; Rec."Custom Date 2")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Date));
                }
                field("Custom Date 3"; Rec."Custom Date 3")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Date));
                }
                field("Custom Date 4"; Rec."Custom Date 4")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Date));
                }
                field("Custom Date 5"; Rec."Custom Date 5")
                {
                    ApplicationArea = All;
                    TableRelation = lvnLoanFieldsConfiguration where("Value Type" = filter(Date));
                }
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