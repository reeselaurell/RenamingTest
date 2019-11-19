table 14135100 lvngLoanVisionSetup
{
    DataClassification = CustomerContent;
    Caption = 'Loan Vision Setup';

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; DataClassification = CustomerContent; }
        field(10; "Funded Reason Code"; Code[10]) { Caption = 'Funded Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(11; "Sold Reason Code"; Code[10]) { Caption = 'Sold Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(13; "Search Name Template"; Text[50]) { Caption = 'Search Name Template'; DataClassification = CustomerContent; }
        field(14; "Funded Void Reason Code"; code[10]) { Caption = 'Funded Void Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(15; "Sold Void Reason Code"; Code[10]) { Caption = 'Sold Void Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(17; "Funded Source Code"; Code[20]) { Caption = 'Funded Source Code'; DataClassification = CustomerContent; TableRelation = "Source Code".Code; }
        field(18; "Sold Source Code"; Code[20]) { Caption = 'Sold Source Code'; DataClassification = CustomerContent; TableRelation = "Source Code".Code; }
        field(50; "Funded No. Series"; Code[20]) { Caption = 'Funded No. Series'; DataClassification = CustomerContent; TableRelation = "No. Series".Code; }
        field(51; "Sold No. Series"; Code[20]) { Caption = 'Sold No. Series'; DataClassification = CustomerContent; TableRelation = "No. Series".Code; }
        field(53; "Void Funded No. Series"; Code[20]) { Caption = 'Funded Void No. Series'; DataClassification = CustomerContent; TableRelation = "No. Series".Code; }
        field(54; "Void Sold No. Series"; Code[20]) { Caption = 'Sold Void No. Series'; DataClassification = CustomerContent; TableRelation = "No. Series".Code; }
        field(300; "Loan Officer Dimension Code"; Code[20]) { Caption = 'Loan Officer Dimension Code'; DataClassification = CustomerContent; TableRelation = Dimension; }
        field(301; "Property State Dimension Code"; Code[20]) { Caption = 'Property State Dimension Code'; DataClassification = CustomerContent; TableRelation = Dimension; }
        field(302; "Loan Type Dimension Code"; Code[20]) { Caption = 'Loan Type Dimension Code'; DataClassification = CustomerContent; TableRelation = Dimension; }
        field(303; "Cost Center Dimension Code"; Code[20]) { Caption = 'Cost Center Dimension Code'; DataClassification = CustomerContent; TableRelation = Dimension; }
        field(304; "Loan Purpose Dimension Code"; Code[20]) { Caption = 'Loan Purpose Dimension Code'; DataClassification = CustomerContent; TableRelation = Dimension; }
        field(305; "Loan Officer Name Template"; Text[50]) { Caption = 'Loan Officer Name Template'; DataClassification = CustomerContent; }
        field(400; "Hierarchy Levels"; Integer) { Caption = 'Hierarchy Levels'; DataClassification = CustomerContent; }
        field(401; "Level 1"; enum lvngHierarchyLevels) { Caption = 'Level 1'; DataClassification = CustomerContent; }
        field(402; "Level 2"; enum lvngHierarchyLevels) { Caption = 'Level 2'; DataClassification = CustomerContent; }
        field(403; "Level 3"; enum lvngHierarchyLevels) { Caption = 'Level 3'; DataClassification = CustomerContent; }
        field(404; "Level 4"; enum lvngHierarchyLevels) { Caption = 'Level 4'; DataClassification = CustomerContent; }
        field(405; "Level 5"; enum lvngHierarchyLevels) { Caption = 'Level 5'; DataClassification = CustomerContent; }
        field(90000; "Maintenance Mode"; Boolean) { Caption = 'Maintenance Mode'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

}