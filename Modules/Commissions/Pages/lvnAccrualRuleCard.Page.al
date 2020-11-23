page 14135308 "lvnAccrualRuleCard"
{
    Caption = 'Accrual Rule Card';
    PageType = Card;
    SourceTable = lvnAccrualRules;

    layout
    {
        area(Content)
        {
            group(General)
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
                    Visible = DimensionVisible1;
                }
                field(DefaultDimension1Code; Rec."Default Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(Dimension2AccrualOption; Rec."Dimension 2 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(DefaultDimension2Code; Rec."Default Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(Dimension3AccrualOption; Rec."Dimension 3 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(DefaultDimension3Code; Rec."Default Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(Dimension4AccrualOption; Rec."Dimension 4 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(DefaultDimension4Code; Rec."Default Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(Dimension5AccrualOption; Rec."Dimension 5 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(DefaultDimension5Code; Rec."Default Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(Dimension6AccrualOption; Rec."Dimension 6 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(DefaultDimension6Code; Rec."Default Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(Dimension7AccrualOption; Rec."Dimension 7 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(DefaultDimension7Code; Rec."Default Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(Dimension8AccrualOption; Rec."Dimension 8 Accrual Option")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(DefaultDimension8Code; Rec."Default Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(BusinessUnitAccrualOption; Rec."Business Unit Accrual Option")
                {
                    ApplicationArea = All;
                }
                field(DefaultBusinessUnitCode; Rec."Default Business Unit Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

    var
        DimensionManagement: Codeunit DimensionManagement;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;
}