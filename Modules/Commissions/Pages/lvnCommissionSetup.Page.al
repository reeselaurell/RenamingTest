page 14135300 "lvnCommissionSetup"
{
    PageType = Card;
    SourceTable = lvnCommissionSetup;
    Caption = 'Commission Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(UsePeriodIdentifiers; Rec."Use Period Identifiers")
                {
                    ApplicationArea = All;
                }
                field(CommissionIdentifierCode; Rec."Commission Identifier Code")
                {
                    ApplicationArea = All;
                }
                field(AccrualsReasonCode; Rec."Accruals Reason Code")
                {
                    ApplicationArea = All;
                }
            }
            group(DebtLog)
            {
                field(InsideLORecoveryIdentifier; Rec."Inside LO Recovery Identifier")
                {
                    ApplicationArea = All;
                }
                field(OutsideLORecoveryIdentifier; Rec."Outside LO Recovery Identifier")
                {
                    ApplicationArea = All;
                }
                field(InsideLOAdvanceIdentifier; Rec."Inside LO Advance Identifier")
                {
                    ApplicationArea = All;
                }
                field(OutsideLOAdvanceIdentifier; Rec."Outside LO Advance Identifier")
                {
                    ApplicationArea = All;
                }
                field(DebtLogBalanceIdentifier; Rec."Debt Log Balance Identifier")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}