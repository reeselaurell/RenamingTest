page 14135301 "lvnCommissionIdentifiers"
{
    Caption = 'Commission Identifiers';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnCommissionIdentifier;

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
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(AdditionalIdentifier; Rec."Additional Identifier")
                {
                    ApplicationArea = All;
                }
                field(PayrollGLAccountNo; Rec."Payroll G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field(DebtLogCommissionIdentifier; Rec."Debt Log Commission Identifier")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}