table 14135400 lvngBranchPortalSetup
{
    DataClassification = CustomerContent;
    Caption = 'Branch Portal Setup';

    fields
    {
        field(1; "Primary Key"; Code[10]) { DataClassification = CustomerContent; }
        field(10; "Metric 1 Calculation Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(11; "Metric 2 Calculation Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(12; "Metric 3 Calculation Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(13; "Metric 4 Calculation Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(14; "Metric 5 Calculation Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(15; "Metric 1 Number Format"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceNumberFormat.Code; }
        field(16; "Metric 2 Number Format"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceNumberFormat.Code; }
        field(17; "Metric 3 Number Format"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceNumberFormat.Code; }
        field(18; "Metric 4 Number Format"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceNumberFormat.Code; }
        field(19; "Metric 5 Number Format"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceNumberFormat.Code; }
        field(20; "Tile Metric 1 Calculation Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(21; "Tile Metric 2 Calculation Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(22; "Tile Metric 3 Calculation Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(23; "Tile Metric 1 Number Format"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceNumberFormat.Code; }
        field(24; "Tile Metric 2 Number Format"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceNumberFormat.Code; }
        field(25; "Tile Metric 3 Number Format"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceNumberFormat.Code; }
        field(26; "Tile 1 Name"; Text[10]) { DataClassification = CustomerContent; }
        field(27; "Tile 2 Name"; Text[10]) { DataClassification = CustomerContent; }
        field(28; "Tile 3 Name"; Text[10]) { DataClassification = CustomerContent; }
        field(50; "Show Loan Level Report"; Boolean) { DataClassification = CustomerContent; }
        field(51; "Loan Level Report Schema Code"; Code[20]) { DataClassification = CustomerContent; }
        field(52; "Hide General Ledger"; Boolean) { DataClassification = CustomerContent; }
        field(53; "Hide KPI"; Boolean) { DataClassification = CustomerContent; }
        field(54; "Hide Performance Worksheet"; Boolean) { DataClassification = CustomerContent; }
        field(60; "Basic Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(61; "Level 1 Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(62; "Level 2 Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(63; "Level 3 Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(64; "Level 4 Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(65; "Level 5 Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(75; "Default Chart 1"; Enum lvngPerformanceChartType) { DataClassification = CustomerContent; }
        field(76; "Default Chart 2"; Enum lvngPerformanceChartType) { DataClassification = CustomerContent; }
        field(100; "Permission Identifier"; Code[2]) { DataClassification = CustomerContent; }
        field(200; "Block Data To Date"; Date) { DataClassification = CustomerContent; }
        field(201; "Block Data From Date"; Date) { DataClassification = CustomerContent; }
        field(300; "Corporate Tile Color"; Text[30]) { DataClassification = CustomerContent; }
        field(301; "Level 1 Tile Color"; Text[30]) { DataClassification = CustomerContent; }
        field(302; "Level 2 Tile Color"; Text[30]) { DataClassification = CustomerContent; }
        field(303; "Level 3 Tile Color"; Text[30]) { DataClassification = CustomerContent; }
        field(304; "Level 4 Tile Color"; Text[30]) { DataClassification = CustomerContent; }
        field(305; "Level 5 Tile Color"; Text[30]) { DataClassification = CustomerContent; }
        field(306; "Chart 1 Type"; Enum lvngChartKind) { DataClassification = CustomerContent; }
        field(307; "Chart 2 Type"; Enum lvngChartKind) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}