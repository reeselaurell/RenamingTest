page 14135158 "lvngLoanServicingSetup"
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

                field(lvngBorrowerCustomerTemplate; "Borrower Customer Template")
                {
                    ApplicationArea = All;
                }
                field(lvngServicedReasonCode; "Serviced Reason Code")
                {
                    ApplicationArea = All;
                }
                field(lvngServicedVoidReasonCode; "Serviced Void Reason Code")
                {
                    ApplicationArea = All;
                }
                field(lvngServicedSourceCode; "Serviced Source Code")
                {
                    ApplicationArea = All;
                }
                field(lvngServicedNoSeries; "Serviced No. Series")
                {
                    ApplicationArea = All;
                }
                field(lvngVoidServicedNoSeries; "Void Serviced No. Series")
                {
                    ApplicationArea = All;
                }
                field(lvngTestEscrowTotals; "Test Escrow Totals")
                {
                    ApplicationArea = All;
                }

                group(Interest)
                {
                    field(lvngInterestGLAccountNo; "Interest G/L Account No.")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngInterestGLAccSwitchCode; "Interest G/L Acc. Switch Code")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngInterestCostCenterOption; "Interest Cost Center Option")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngInterestCostCenter; "Interest Cost Center")
                    {
                        ApplicationArea = All;
                    }
                }

                group(Principal)
                {
                    Caption = 'Principal';

                    field(lvngPrincipalGLAccountNo; "Principal G/L Account No.")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngPrincipalGLAccSwitchCode; "Principal G/L Acc. Switch Code")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngPrincipalCostCenterOption; "Principal Cost Center Option")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngPrincipalCostCenter; "Principal Cost Center")
                    {
                        ApplicationArea = All;
                    }

                    field(lvngPrincipalRedGLAccountNo; "Principal Red. G/L Account No.")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngPrincipalRedReasonCode; "Principal Red. Reason Code")
                    {
                        ApplicationArea = All;
                    }
                }

                group(Other)
                {
                    field(lvngAddEscrowGLAccountNo; "Add. Escrow G/L Account No.")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngAdditionalEscrowReasonCode; "Additional Escrow Reason Code")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngLatePaymentGLAccountNo; "Late Payment G/L Account No.")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngLatePaymentReasonCode; "Late Payment Reason Code")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngLateFeeRule; "Late Fee Rule")
                    {
                        ApplicationArea = All;
                    }

                }

            }

        }
        //You might want to add fields here

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
        InsertIfNotExists();
    end;

    local procedure InsertIfNotExists()
    begin
        reset;
        if not get then begin
            Init();
            Insert();
        end;
    end;

}
