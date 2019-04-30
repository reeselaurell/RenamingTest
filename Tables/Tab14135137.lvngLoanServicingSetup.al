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
        field(11; lvngPrincipalRedGLAccountNo; Code[20])
        {
            Caption = 'Principal Reduction G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where ("Account Type" = const (Posting));
        }
        field(12; lvngServicedReasonCode; Code[10])
        {
            Caption = 'Serviced Reason Code';
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


    }

    keys
    {
        key(PK; lvngPrimaryKey)
        {
            Clustered = true;
        }
    }

}