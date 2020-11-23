table 14135300 "lvnCommissionSetup"
{
    DataClassification = CustomerContent;
    Caption = 'Commission Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(10; "Commission Identifier Code"; Code[20])
        {
            Caption = 'Commission Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
        field(11; "Use Period Identifiers"; Boolean)
        {
            Caption = 'Use Period Identifiers';
            DataClassification = CustomerContent;
        }
        field(12; "Accruals Reason Code"; Code[20])
        {
            Caption = 'Accruals Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(200; "Inside LO Recovery Identifier"; Code[20])
        {
            Caption = 'Inside LO Recovery Identifier';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
        field(201; "Outside LO Recovery Identifier"; Code[20])
        {
            Caption = 'Outside LO Recovery Identifier';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
        field(202; "Inside LO Advance Identifier"; Code[20])
        {
            Caption = 'Inside LO Advance Identifier';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
        field(203; "Outside LO Advance Identifier"; Code[20])
        {
            Caption = 'Outside LO Advance Identifier';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
        field(204; "Debt Log Balance Identifier"; Code[20])
        {
            Caption = 'Debt Log Balance Identifier';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}