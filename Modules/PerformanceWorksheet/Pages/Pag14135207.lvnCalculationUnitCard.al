page 14135207 "lvnCalculationUnitCard"
{
    PageType = Card;
    SourceTable = lvnCalculationUnit;
    Caption = 'Calculation Unit';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
            }
            group(Constant)
            {
                Visible = Rec.Type = Rec.Type::Constant;
                Caption = 'Constant';

                field("Constant Value"; Rec."Constant Value")
                {
                    ApplicationArea = All;
                }
            }
            group(Lookup)
            {
                Visible = (Rec.Type = Rec.Type::"Amount Lookup") or (Rec.Type = Rec.Type::"Count Lookup");
                Caption = 'Lookup';

                field("Lookup Source"; Rec."Lookup Source")
                {
                    ApplicationArea = All;
                }
                group(LoanCard)
                {
                    Visible = Rec."Lookup Source" = Rec."Lookup Source"::"Loan Card";
                    Caption = 'Loan Card';

                    field(CardBasedOnDate; Rec."Based On Date")
                    {
                        ApplicationArea = All;
                    }
                }
                group(LedgerEntries)
                {
                    Visible = Rec."Lookup Source" = Rec."Lookup Source"::"Ledger Entries";
                    Caption = 'Ledger Entries';

                    field("Account No. Filter"; Rec."Account No. Filter")
                    {
                        ApplicationArea = All;
                    }
                    field("Amount Type"; Rec."Amount Type")
                    {
                        ApplicationArea = All;
                    }
                }
                group(LoanValues)
                {
                    Visible = Rec."Lookup Source" = Rec."Lookup Source"::"Loan Values";
                    Caption = 'Loan Values';

                    field(ValueBasedOnDate; Rec."Based On Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Field No."; Rec."Field No.")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Expression)
            {
                Visible = Rec.Type = Rec.Type::Expression;

                grid(ExpressionCode)
                {
                    ShowCaption = false;
                    GridLayout = Rows;

                    group(ExpressionGroup)
                    {
                        ShowCaption = false;

                        field("Expression Code"; Rec."Expression Code")
                        {
                            ApplicationArea = All;
                            AssistEdit = true;
                            Editable = false;
                            ColumnSpan = 2;

                            trigger OnAssistEdit()
                            var
                                ExpressionList: Page lvnExpressionList;
                                ExpressiontType: Enum lvnExpressionType;
                                NewCode: Code[20];
                            begin
                                NewCode := ExpressionList.SelectExpression(PerformanceMgmt.GetBandExpressionConsumerId(), Rec.Code, Rec."Expression Code", ExpressiontType::Formula);
                                if NewCode <> '' then
                                    Rec."Expression Code" := NewCode;
                            end;
                        }
                        part("Data Source"; lvnCalculationUnitLines)
                        {
                            ApplicationArea = All;
                            SubPageLink = "Unit Code" = field(Code);
                        }
                    }
                }
            }
            group("Provider Value")
            {
                Visible = Rec.Type = Rec.Type::"Provider Value";

                field("Provider Metadata"; Rec."Provider Metadata")
                {
                    ApplicationArea = All;
                }
            }
            group(Filters)
            {
                field("Dimension 1 Filter"; Rec."Dimension 1 Filter")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,3,1';
                }
                field("Dimension 2 Filter"; Rec."Dimension 2 Filter")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,3,2';
                }
                field("Dimension 3 Filter"; Rec."Dimension 3 Filter")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,4,3';
                }
                field("Dimension 4 Filter"; Rec."Dimension 4 Filter")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,4,4';
                }
                field("Dimension 5 Filter"; Rec."Dimension 5 Filter")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,4,5';
                }
                field("Dimension 6 Filter"; Rec."Dimension 6 Filter")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,4,6';
                }
                field("Dimension 7 Filter"; Rec."Dimension 7 Filter")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,4,7';
                }
                field("Dimension 8 Filter"; Rec."Dimension 8 Filter")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,4,8';
                }
                field("Business Unit Filter"; Rec."Business Unit Filter")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        PerformanceMgmt: Codeunit lvnPerformanceMgmt;
        Dummy: Text;
}