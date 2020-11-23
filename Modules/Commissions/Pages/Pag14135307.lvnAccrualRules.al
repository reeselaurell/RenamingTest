page 14135307 lvnAccrualRules
{
    Caption = 'Accrual Rules';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnAccrualRules;
    CardPageId = lvnAccrualRuleCard;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Dimension1AccrualOption; Rec."Dimension 1 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DefaultDimension1Code; Rec."Default Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Dimension2AccrualOption; Rec."Dimension 2 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DefaultDimension2Code; Rec."Default Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Dimension3AccrualOption; Rec."Dimension 3 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DefaultDimension3Code; Rec."Default Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Dimension4AccrualOption; Rec."Dimension 4 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DefaultDimension4Code; Rec."Default Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Dimension5AccrualOption; Rec."Dimension 5 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DefaultDimension5Code; Rec."Default Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Dimension6AccrualOption; Rec."Dimension 6 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DefaultDimension6Code; Rec."Default Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Dimension7AccrualOption; Rec."Dimension 7 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DefaultDimension7Code; Rec."Default Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Dimension8AccrualOption; Rec."Dimension 8 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DefaultDimension8Code; Rec."Default Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(BusinessUnitAccrualOption; Rec."Business Unit Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DefaultBusinessUnitCode; Rec."Default Business Unit Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}