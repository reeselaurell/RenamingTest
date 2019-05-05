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

                field(lvngServicedReasonCode; lvngServicedReasonCode)
                {
                    ApplicationArea = All;
                }
                field(lvngServicedVoidReasonCode; lvngServicedVoidReasonCode)
                {
                    ApplicationArea = All;
                }
                field(lvngServicedSourceCode; lvngServicedSourceCode)
                {
                    ApplicationArea = All;
                }
                field(lvngServicedNoSeries; lvngServicedNoSeries)
                {
                    ApplicationArea = All;
                }
                field(lvngVoidServicedNoSeries; lvngVoidServicedNoSeries)
                {
                    ApplicationArea = All;
                }

                group(Interest)
                {
                    field(lvngInterestGLAccountNo; lvngInterestGLAccountNo)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngInterestGLAccSwitchCode; lvngInterestGLAccSwitchCode)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngInterestCostCenterOption; lvngInterestCostCenterOption)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngInterestCostCenter; lvngInterestCostCenter)
                    {
                        ApplicationArea = All;
                    }
                }

                group(Principal)
                {
                    Caption = 'Principal';

                    field(lvngPrincipalGLAccountNo; lvngPrincipalGLAccountNo)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngPrincipalGLAccSwitchCode; lvngPrincipalGLAccSwitchCode)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngPrincipalCostCenterOption; lvngPrincipalCostCenterOption)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngPrincipalCostCenter; lvngPrincipalCostCenter)
                    {
                        ApplicationArea = All;
                    }

                    field(lvngPrincipalRedGLAccountNo; lvngPrincipalRedGLAccountNo)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngPrincipalRedReasonCode; lvngPrincipalRedReasonCode)
                    {
                        ApplicationArea = All;
                    }
                }

                group(Other)
                {
                    field(lvngAddEscrowGLAccountNo; lvngAddEscrowGLAccountNo)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngAdditionalEscrowReasonCode; lvngAdditionalEscrowReasonCode)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngLatePaymentGLAccountNo; lvngLatePaymentGLAccountNo)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngLatePaymentReasonCode; lvngLatePaymentReasonCode)
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
