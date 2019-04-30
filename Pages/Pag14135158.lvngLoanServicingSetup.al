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
                field(lvngPrincipalRedReasonCode; lvngPrincipalRedReasonCode)
                {
                    ApplicationArea = All;
                }

                field(lvngPrincipalRedGLAccountNo; lvngPrincipalRedGLAccountNo)
                {
                    ApplicationArea = All;
                }
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
