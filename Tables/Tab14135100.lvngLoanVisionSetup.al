table 14135100 "lvngLoanVisionSetup"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Vision Setup';

    fields
    {
        field(1; lvngPrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }

        field(10; lvngFundedReasonCode; Code[10])
        {
            Caption = 'Funded Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }

        field(11; lvngSoldReasonCode; Code[10])
        {
            Caption = 'Sold Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }

        field(12; lvngServicedReasonCode; Code[10])
        {
            Caption = 'Serviced Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }

        field(13; lvngSearchNameTemplate; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Search Name Template';
        }
        field(14; lvngFundedVoidReasonCode; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Funded Void Reason Code';
            TableRelation = "Reason Code";
        }
        field(15; lvngSoldVoidReasonCode; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Sold Void Reason Code';
            TableRelation = "Reason Code";
        }
        field(16; lvngServicedVoidReasonCode; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Serviced Void Reason Code';
            TableRelation = "Reason Code";
        }

        field(300; lvngLoanOfficerDimensionCode; Code[20])
        {
            Caption = 'Loan Officer Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }

        field(301; lvngPropertyStateDimensionCode; Code[20])
        {
            Caption = 'Property State Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }

        field(302; lvngLoanTypeDimensionCode; Code[20])
        {
            Caption = 'Loan Type Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }

        field(303; lvngCostCenterDimensionCode; Code[20])
        {
            Caption = 'Cost Center Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }

        field(304; lvngLoanPurposeDimensionCode; Code[20])
        {
            Caption = 'Loan Purpose Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }

        field(400; lvngHierarchyLevels; Integer)
        {
            Caption = 'Hierarchy Levels';
            DataClassification = CustomerContent;
        }

        field(401; lvngLevel1; enum lvngHierarchyLevels)
        {
            Caption = 'Level 1';
            DataClassification = CustomerContent;
        }

        field(402; lvngLevel2; enum lvngHierarchyLevels)
        {
            Caption = 'Level 2';
            DataClassification = CustomerContent;
        }

        field(403; lvngLevel3; enum lvngHierarchyLevels)
        {
            Caption = 'Level 3';
            DataClassification = CustomerContent;
        }

        field(404; lvngLevel4; enum lvngHierarchyLevels)
        {
            Caption = 'Level 4';
            DataClassification = CustomerContent;
        }

        field(405; lvngLevel5; enum lvngHierarchyLevels)
        {
            Caption = 'Level 5';
            DataClassification = CustomerContent;
        }

        field(90000; lvngMaintenanceMode; Boolean)
        {
            Caption = 'Maintenance Mode';
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

}