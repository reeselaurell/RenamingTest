page 14135228 lvngCalculationUnitCard
{
    PageType = Card;
    SourceTable = lvngCalculationUnit;
    Caption = 'Calculation Unit';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Type; Type) { ApplicationArea = All; }
            }
            group(Constant)
            {
                Visible = Type = Type::lvngConstant;

                field("Constant Value"; "Constant Value") { ApplicationArea = All; }
            }
            group(Lookup)
            {
                Visible = (Type = Type::lvngAmountLookup) or (Type = Type::lvngCountLookup);

                field("Lookup Source"; "Lookup Source") { ApplicationArea = All; }
                group("Loan Card")
                {
                    Visible = "Lookup Source" = "Lookup Source"::lvngLoanCard;

                    field("Based On Date"; "Based On Date") { ApplicationArea = All; }
                }
                group("Ledger Entries")
                {
                    Visible = "Lookup Source" = "Lookup Source"::lvngLedgerEntries;

                    field("Account No. Filter"; "Account No. Filter") { ApplicationArea = All; }
                    field("Amount Type"; "Amount Type") { ApplicationArea = All; }
                }
            }
            group(Expression)
            {
                Visible = Type = Type::lvngExpression;

                grid(ExpressionCode)
                {
                    ShowCaption = false;
                    GridLayout = Rows;
                    group(ExpressionGroup)
                    {
                        ShowCaption = false;

                        field("Expression Code"; "Expression Code")
                        {
                            ApplicationArea = All;
                            AssistEdit = true;
                            Editable = false;
                            ColumnSpan = 2;

                            trigger OnAssistEdit()
                            var
                                ExpressionList: Page lvngExpressionList;
                                NewCode: Code[20];
                            begin
                                NewCode := ExpressionList.SelectExpression(PerformanceMgmt.GetCalcUnitConsumerId(), Code);
                                if NewCode <> '' then
                                    "Expression Code" := NewCode;
                            end;
                        }
                        part("Data Source"; lvngCalculationUnitLines) { ApplicationArea = All; SubPageLink = "Unit Code" = field(Code); }
                    }
                }
            }
            group("Provider Value")
            {
                Visible = Type = Type::lvngProviderValue;

                field("Provider Metadata"; "Provider Metadata") { ApplicationArea = All; }
            }
            group(Filters)
            {
                field("Dimension 1 Filter"; "Dimension 1 Filter") { ApplicationArea = All; CaptionClass = '1,3,1'; }
                field("Dimension 2 Filter"; "Dimension 2 Filter") { ApplicationArea = All; CaptionClass = '1,3,2'; }
                field("Dimension 3 Filter"; "Dimension 3 Filter") { ApplicationArea = All; CaptionClass = '1,4,3'; }
                field("Dimension 4 Filter"; "Dimension 4 Filter") { ApplicationArea = All; CaptionClass = '1,4,4'; }
                field("Dimension 5 Filter"; "Dimension 5 Filter") { ApplicationArea = All; CaptionClass = '1,4,5'; }
                field("Dimension 6 Filter"; "Dimension 6 Filter") { ApplicationArea = All; CaptionClass = '1,4,6'; }
                field("Dimension 7 Filter"; "Dimension 7 Filter") { ApplicationArea = All; CaptionClass = '1,4,7'; }
                field("Dimension 8 Filter"; "Dimension 8 Filter") { ApplicationArea = All; CaptionClass = '1,4,8'; }
                field("Business Unit Filter"; "Business Unit Filter") { ApplicationArea = All; }
            }
        }
    }

    var
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
        Dummy: Text;
}