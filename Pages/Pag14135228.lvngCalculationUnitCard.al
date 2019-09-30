page 14135228 lvngCalculationUnitCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
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
                                NewCode := ExpressionList.SelectExpression(Code);
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
        }
    }

    var
        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
        Dummy: Text;
}