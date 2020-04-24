page 14135157 lvngLoanServicingSetup
{

    PageType = Card;
    SourceTable = lvngLoanServicingSetup;
    Caption = 'Loan Servicing Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Borrower Customer Template"; "Borrower Customer Template") { ApplicationArea = All; }
                field("Serviced Reason Code"; "Serviced Reason Code") { ApplicationArea = All; }
                field("Serviced Void Reason Code"; "Serviced Void Reason Code") { ApplicationArea = All; }
                field("Serviced Source Code"; "Serviced Source Code") { ApplicationArea = All; }
                field("Serviced No. Series"; "Serviced No. Series") { ApplicationArea = All; }
                field("Void Serviced No. Series"; "Void Serviced No. Series") { ApplicationArea = All; }
                field("Test Escrow Totals"; "Test Escrow Totals") { ApplicationArea = All; }
                field("Last Servicing Month Day"; "Last Servicing Month Day") { ApplicationArea = All; }

                group(Interest)
                {
                    Caption = 'Interest';

                    field("Interest G/L Account No."; "Interest G/L Account No.") { Caption = 'G/L Account No.'; ApplicationArea = All; }
                    field("Interest G/L Acc. Switch Code"; "Interest G/L Acc. Switch Code") { Caption = 'G/L Expression Code'; ApplicationArea = All; }
                    field("Interest Cost Center Option"; "Interest Cost Center Option") { Caption = 'Cost Center Option'; ApplicationArea = All; }
                    field("Interest Cost Center"; "Interest Cost Center") { Caption = 'Cost Center'; ApplicationArea = All; }
                }

                group(Principal)
                {
                    Caption = 'Principal';

                    field("Principal G/L Account No."; "Principal G/L Account No.") { Caption = 'G/L Account No.'; ApplicationArea = All; }
                    field("Principal G/L Acc. Switch Code"; "Principal G/L Acc. Switch Code") { Caption = 'G/L Expression Code'; ApplicationArea = All; }
                    field("Principal Cost Center Option"; "Principal Cost Center Option") { Caption = 'Cost Center Option'; ApplicationArea = All; }
                    field("Principal Cost Center"; "Principal Cost Center") { Caption = 'Cost Center'; ApplicationArea = All; }
                    field("Principal Red. G/L Account No."; "Principal Red. G/L Account No.") { ApplicationArea = All; }
                    field("Principal Red. Reason Code"; "Principal Red. Reason Code") { ApplicationArea = All; }
                }

                group(Other)
                {
                    Caption = 'Other';

                    field("Add. Escrow G/L Account No."; "Add. Escrow G/L Account No.") { ApplicationArea = All; }
                    field("Additional Escrow Reason Code"; "Additional Escrow Reason Code") { ApplicationArea = All; }
                    field("Late Payment G/L Account No."; "Late Payment G/L Account No.") { ApplicationArea = All; }
                    field("Late Payment Reason Code"; "Late Payment Reason Code") { ApplicationArea = All; }
                    field("Late Fee Amount Rule"; "Late Fee Amount Rule") { ApplicationArea = All; }
                    field("Late Fee Date Formula"; "Late Fee Date Formula") { ApplicationArea = All; }
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(lvngEscrowFieldsMapping)
            {
                Caption = 'Escrow Fields Mapping';
                Image = MapAccounts;
                ApplicationArea = All;
                RunObject = page lvngEscrowFieldsMapping;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}
