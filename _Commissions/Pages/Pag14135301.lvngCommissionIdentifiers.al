page 14135301 "lvngCommissionIdentifiers"
{
    Caption = 'Commission Identifiers';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngCommissionIdentifier;

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
                field(lvngName; lvngName)
                {
                    ApplicationArea = All;
                }
                field(lvngAdditionalIdentifier; lvngAdditionalIdentifier)
                {
                    ApplicationArea = All;
                }
                field(lvngPayrollGLAccountNo; lvngPayrollGLAccountNo)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}