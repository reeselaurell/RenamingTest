page 14135157 "lvnLoanServicingSetup"
{
    PageType = Card;
    SourceTable = lvnLoanServicingSetup;
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

                field("Borrower Customer Template"; Rec."Borrower Customer Template")
                {
                    ApplicationArea = All;
                }
                field("Serviced Reason Code"; Rec."Serviced Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Serviced Void Reason Code"; Rec."Serviced Void Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Serviced Source Code"; Rec."Serviced Source Code")
                {
                    ApplicationArea = All;
                }
                field("Serviced No. Series"; Rec."Serviced No. Series")
                {
                    ApplicationArea = All;
                }
                field("Void Serviced No. Series"; Rec."Void Serviced No. Series")
                {
                    ApplicationArea = All;
                }
                field("Test Escrow Totals"; Rec."Test Escrow Totals")
                {
                    ApplicationArea = All;
                }
                field("Last Servicing Month Day"; Rec."Last Servicing Month Day")
                {
                    ApplicationArea = All;
                }
                group(Interest)
                {
                    Caption = 'Interest';

                    field("Interest G/L Account No."; Rec."Interest G/L Account No.")
                    {
                        Caption = 'G/L Account No.';
                        ApplicationArea = All;
                    }
                    field("Interest G/L Acc. Switch Code"; Rec."Interest G/L Acc. Switch Code")
                    {
                        Caption = 'G/L Expression Code';
                        ApplicationArea = All;
                    }
                    field("Interest Cost Center Option"; Rec."Interest Cost Center Option")
                    {
                        Caption = 'Cost Center Option';
                        ApplicationArea = All;
                    }
                    field("Interest Cost Center"; Rec."Interest Cost Center")
                    {
                        Caption = 'Cost Center';
                        ApplicationArea = All;
                    }
                }
                group(Principal)
                {
                    Caption = 'Principal';

                    field("Principal G/L Account No."; Rec."Principal G/L Account No.")
                    {
                        Caption = 'G/L Account No.';
                        ApplicationArea = All;
                    }
                    field("Principal G/L Acc. Switch Code"; Rec."Principal G/L Acc. Switch Code")
                    {
                        Caption = 'G/L Expression Code';
                        ApplicationArea = All;
                    }
                    field("Principal Cost Center Option"; Rec."Principal Cost Center Option")
                    {
                        Caption = 'Cost Center Option';
                        ApplicationArea = All;
                    }
                    field("Principal Cost Center"; Rec."Principal Cost Center")
                    {
                        Caption = 'Cost Center';
                        ApplicationArea = All;
                    }
                    field("Principal Red. G/L Account No."; Rec."Principal Red. G/L Account No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Principal Red. Reason Code"; Rec."Principal Red. Reason Code")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Other)
                {
                    Caption = 'Other';

                    field("Add. Escrow G/L Account No."; Rec."Add. Escrow G/L Account No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Additional Escrow Reason Code"; Rec."Additional Escrow Reason Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Late Payment G/L Account No."; Rec."Late Payment G/L Account No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Late Payment Reason Code"; Rec."Late Payment Reason Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Late Fee Amount Rule"; Rec."Late Fee Amount Rule")
                    {
                        ApplicationArea = All;
                    }
                    field("Late Fee Date Formula"; Rec."Late Fee Date Formula")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(lvnEscrowFieldsMapping)
            {
                Caption = 'Escrow Fields Mapping';
                Image = MapAccounts;
                ApplicationArea = All;
                RunObject = page lvnEscrowFieldsMapping;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}