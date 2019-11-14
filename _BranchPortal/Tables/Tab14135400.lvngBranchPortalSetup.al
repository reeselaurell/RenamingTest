table 14135400 lvngBranchPortalSetup
{
    DataClassification = CustomerContent;
    Caption = 'Branch Portal Setup';

    fields
    {
        field(1; "Primary Key"; Code[10]) { DataClassification = CustomerContent; }
        field(10; "Show Performance Worksheet"; Boolean) { DataClassification = CustomerContent; InitValue = true; }
        field(11; "Show KPI"; Boolean) { DataClassification = CustomerContent; InitValue = true; }
        field(12; "Show General Ledger"; Boolean) { DataClassification = CustomerContent; InitValue = true; }
        field(13; "Show Loan Level Report"; Boolean) { DataClassification = CustomerContent; }
        field(14; "Block Data To Date"; Date) { DataClassification = CustomerContent; }
        field(15; "Block Data From Date"; Date) { DataClassification = CustomerContent; }
        field(16; "Show Corporate Tile"; Boolean) { DataClassification = CustomerContent; }
        field(17; "Corporate Tile Color"; Text[50]) { DataClassification = CustomerContent; }
        field(18; "Chart 1 Type"; Enum lvngDashboardChartType) { DataClassification = CustomerContent; }
        field(19; "Chart 2 Type"; Enum lvngDashboardChartType) { DataClassification = CustomerContent; }
        field(20; "Chart 1 Kind"; Enum lvngChartKind) { DataClassification = CustomerContent; }
        field(21; "Chart 2 Kind"; Enum lvngChartKind) { DataClassification = CustomerContent; }
        field(22; "Level 1 Tile Color"; Text[50]) { DataClassification = CustomerContent; }
        field(23; "Level 2 Tile Color"; Text[50]) { DataClassification = CustomerContent; }
        field(24; "Level 3 Tile Color"; Text[50]) { DataClassification = CustomerContent; }
        field(25; "Level 4 Tile Color"; Text[50]) { DataClassification = CustomerContent; }
        field(26; "Level 5 Tile Color"; Text[50]) { DataClassification = CustomerContent; }
        field(27; "Level 1 Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(28; "Level 2 Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(29; "Level 3 Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(30; "Level 4 Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(31; "Level 5 Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(32; "Initial Dashboard Period"; Enum lvngInitialDashboardPeriod) { DataClassification = CustomerContent; }
        /*
        field(60; "Basic Permission Set"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Permission Set"."Role ID"; }
        field(100; "Permission Identifier"; Code[2]) { DataClassification = CustomerContent; }
        */
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}