page 14135315 "lvngCommissionJournalLines"
{
    Caption = 'Commission Journal Lines';
    PageType = List;
    SourceTable = lvngCommissionJournalLine;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngLineNo; lvngLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngProfileCode; lvngProfileCode)
                {
                    ApplicationArea = All;
                }
                field(lvngCalculationLineNo; lvngCalculationLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }
                field(lvngCommissionDate; lvngCommissionDate)
                {
                    ApplicationArea = All;
                }
                field(lvngBaseAmount; lvngBaseAmount)
                {
                    ApplicationArea = All;
                }
                field(lvngBps; lvngBps)
                {
                    ApplicationArea = All;
                }
                field(lvngIdentifierCode; lvngIdentifierCode)
                {
                    ApplicationArea = All;
                }
                field(lvngCommissionAmount; lvngCommissionAmount)
                {
                    ApplicationArea = All;
                }
                field(lvngPeriodIdentifierCode; lvngPeriodIdentifierCode)
                {
                    ApplicationArea = All;
                }
                field(lvngManualAdjustment; lvngManualAdjustment)
                {
                    ApplicationArea = All;
                }
                field(lvngProfileLineType; lvngProfileLineType)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}