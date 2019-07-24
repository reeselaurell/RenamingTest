table 14135137 "lvngLoanServicingSetup"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Servicing Setup';

    fields
    {
        field(1; lvngPrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }

        field(10; lvngPrincipalRedReasonCode; Code[10])
        {
            Caption = 'Principal Reduction Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(11; lvngAdditionalEscrowReasonCode; Code[10])
        {
            Caption = 'Additional Escrow Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(12; lvngServicedReasonCode; Code[10])
        {
            Caption = 'Serviced Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(13; lvngLatePaymentReasonCode; Code[10])
        {
            Caption = 'Late Payment Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(16; lvngServicedVoidReasonCode; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Serviced Void Reason Code';
            TableRelation = "Reason Code";
        }
        field(19; lvngServicedSourceCode; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Serviced Source Code';
            TableRelation = "Source Code".Code;
        }
        field(30; lvngInterestGLAccSwitchCode; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = lvngExpressionHeader.Code where (Type = const (Switch));
            Caption = 'Interest G/L Account Switch Code';
        }
        field(31; lvngPrincipalGLAccSwitchCode; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = lvngExpressionHeader.Code where (Type = const (Switch));
            Caption = 'Principal G/L Account Switch Code';
        }
        field(35; lvngInterestCostCenterOption; enum lvngServDimSelectionType)
        {
            Caption = 'Interest Cost Center Option';
            DataClassification = CustomerContent;
        }
        field(36; lvngPrincipalCostCenterOption; enum lvngServDimSelectionType)
        {
            Caption = 'Principal Cost Center Option';
            DataClassification = CustomerContent;
        }
        field(37; lvngInterestCostCenter; Code[20])
        {
            Caption = 'Interest Cost Center';
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                lvngDimensionsManagement.LookupCostCenter(lvngInterestCostCenter);
            end;
        }
        field(38; lvngPrincipalCostCenter; Code[20])
        {
            Caption = 'Principal Cost Center';
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                lvngDimensionsManagement.LookupCostCenter(lvngPrincipalCostCenter);
            end;
        }
        field(40; lvngInterestGLAccountNo; Code[20])
        {
            Caption = 'Interest G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(41; lvngPrincipalGLAccountNo; Code[20])
        {
            Caption = 'Principal G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(42; lvngPrincipalRedGLAccountNo; Code[20])
        {
            Caption = 'Principal Reduction G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where ("Account Type" = const (Posting));
        }
        field(43; lvngAddEscrowGLAccountNo; Code[20])
        {
            Caption = 'Additional Escrow G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where ("Account Type" = const (Posting));
        }
        field(44; lvngLatePaymentGLAccountNo; Code[20])
        {
            Caption = 'Late Payment G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where ("Account Type" = const (Posting));
        }
        field(52; lvngServicedNoSeries; Code[20])
        {
            Caption = 'Serviced No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        field(55; lvngVoidServicedNoSeries; Code[20])
        {
            Caption = 'Serviced Void No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        field(56; lvngLateFeeRule; enum lvngServicingLateFeeRule)
        {
            Caption = 'Late Fee Rule';
            DataClassification = CustomerContent;
        }
        field(60; lvngBorrowerCustomerTemplate; Code[20])
        {
            Caption = 'Borrower Customer Template';
            DataClassification = CustomerContent;
            TableRelation = "Customer Template".Code;
        }
        field(100; lvngTestEscrowTotals; Boolean)
        {
            Caption = 'Test Escrow Total Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngPrimaryKey)
        {
            Clustered = true;
        }
    }

    var
        lvngDimensionsManagement: Codeunit lvngDimensionsManagement;

}