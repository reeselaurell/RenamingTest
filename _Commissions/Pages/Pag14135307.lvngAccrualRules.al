page 14135307 "lvngAccrualRules"
{
    Caption = 'Accrual Rules';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngAccrualRules;
    CardPageId = lvngAccrualRuleCard;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension1AccrualOption; lvngDimension1AccrualOption)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDefaultDimension1Code; lvngDefaultDimension1Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDimension2AccrualOption; lvngDimension2AccrualOption)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDefaultDimension2Code; lvngDefaultDimension2Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDimension3AccrualOption; lvngDimension3AccrualOption)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDefaultDimension3Code; lvngDefaultDimension3Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDimension4AccrualOption; lvngDimension4AccrualOption)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDefaultDimension4Code; lvngDefaultDimension4Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDimension5AccrualOption; lvngDimension5AccrualOption)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDefaultDimension5Code; lvngDefaultDimension5Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDimension6AccrualOption; lvngDimension6AccrualOption)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDefaultDimension6Code; lvngDefaultDimension6Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDimension7AccrualOption; lvngDimension7AccrualOption)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDefaultDimension7Code; lvngDefaultDimension7Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDimension8AccrualOption; lvngDimension8AccrualOption)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDefaultDimension8Code; lvngDefaultDimension8Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngBusinessUnitAccrualOption; lvngBusinessUnitAccrualOption)
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field(lvngDefaultBusinessUnitCode; lvngDefaultBusinessUnitCode)
                {
                    ApplicationArea = All;
                    Visible = false;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}