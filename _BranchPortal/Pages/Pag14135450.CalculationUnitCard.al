page 14135450 lvngCalculationUnitCard
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
                Visible = Type = Type::Constant;

                field("Constant Value"; "Constant Value") { ApplicationArea = All; }
            }
            group(Lookup)
            {
                Visible = (Type = Type::"Amount Lookup") or (Type = Type::"Count Lookup");

                field("Lookup Source"; "Lookup Source") { ApplicationArea = All; }
                group("Loan Card")
                {
                    Visible = "Lookup Source" = "Lookup Source"::"Loan Card";

                    field("Based On Date"; "Based On Date") { ApplicationArea = All; }
                }
                group("Ledger Entries")
                {
                    Visible = "Lookup Source" = "Lookup Source"::"Ledger Entries";

                    field("Account No. Filter"; "Account No. Filter") { ApplicationArea = All; }
                    field("Amount Type"; "Amount Type") { ApplicationArea = All; }
                }
            }
            group(Expression)
            {
                Visible = Type = Type::Expression;

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
                                NewCode := ExpressionList.SelectExpression(BranchPortalMgmt.GetCalcUnitConsumerId(), Code);
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
                Visible = Type = Type::"Provider Value";

                field("Provider Metadata"; "Provider Metadata") { ApplicationArea = All; }
            }
        }
    }

    var
        BranchPortalMgmt: Codeunit lvngBranchPortalManagement;
        Dummy: Text;
}