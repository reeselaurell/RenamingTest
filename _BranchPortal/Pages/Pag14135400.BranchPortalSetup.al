page 14135400 lvngBranchPortalSetup
{
    PageType = Card;
    Caption = 'Branch Portal Setup';
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = lvngBranchPortalSetup;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group("View/Reports Configuration")
            {
                Caption = 'View/Reports Configuration';

                field("Show Loan Level Report"; "Show Loan Level Report") { ApplicationArea = All; }
                field("Hide General Ledger"; "Hide General Ledger") { ApplicationArea = All; }
                field("Hide KPI"; "Hide KPI") { ApplicationArea = All; }
                field("Hide Performance Worksheet"; "Hide Performance Worksheet") { ApplicationArea = All; }
                field("Loan Level Report Schema Code"; "Loan Level Report Schema Code") { ApplicationArea = All; }
                field("Block Data To Date"; "Block Data To Date") { ApplicationArea = All; }
                field("Block Data From Date"; "Block Data From Date") { ApplicationArea = All; }
            }
            part("Branch Performance Schemas"; lvngBranchPerfSchemaMapping) { SubPageView = sorting (Sequence) where ("User ID" = const ('')); UpdatePropagation = Both; }
            group("Horizontal Metrics")
            {
                group("Metric 1")
                {
                    field("Metric 1 Calculation Code"; "Metric 1 Calculation Code") { ApplicationArea = All; Caption = 'Calculation Code'; }
                    field("Metric 1 Number Format"; "Metric 1 Number Format") { ApplicationArea = All; Caption = 'Number Format'; }
                }
                group("Metric 2")
                {
                    field("Metric 2 Calculation Code"; "Metric 2 Calculation Code") { ApplicationArea = All; Caption = 'Calculation Code'; }
                    field("Metric 2 Number Format"; "Metric 2 Number Format") { ApplicationArea = All; Caption = 'Number Format'; }
                }
                group("Metric 3")
                {
                    field("Metric 3 Calculation Code"; "Metric 3 Calculation Code") { ApplicationArea = All; Caption = 'Calculation Code'; }
                    field("Metric 3 Number Format"; "Metric 3 Number Format") { ApplicationArea = All; Caption = 'Number Format'; }
                }
                group("Metric 4")
                {
                    field("Metric 4 Calculation Code"; "Metric 4 Calculation Code") { ApplicationArea = All; Caption = 'Calculation Code'; }
                    field("Metric 4 Number Format"; "Metric 4 Number Format") { ApplicationArea = All; Caption = 'Number Format'; }
                }
                group("Metric 5")
                {
                    field("Metric 5 Calculation Code"; "Metric 5 Calculation Code") { ApplicationArea = All; Caption = 'Calculation Code'; }
                    field("Metric 5 Number Format"; "Metric 5 Number Format") { ApplicationArea = All; Caption = 'Number Format'; }
                }
            }
            group(Tiles)
            {
                group("Tile Metric 1")
                {
                    Caption = 'Metric 1';

                    field("Tile 1 Name"; "Tile 1 Name") { ApplicationArea = All; Caption = 'Name'; }
                    field("Tile Metric 1 Schema Code"; "Tile Metric 1 Calculation Code") { ApplicationArea = All; Caption = 'Calculation Code'; }
                }
                group("Tile Metric 2")
                {
                    Caption = 'Metric 2';

                    field("Tile 2 Name"; "Tile 2 Name") { ApplicationArea = All; Caption = 'Name'; }
                    field("Tile Metric 2 Schema Code"; "Tile Metric 2 Calculation Code") { ApplicationArea = All; Caption = 'Calculation Code'; }
                }
                group("Tile Metric 3")
                {
                    Caption = 'Metric 3';

                    field("Tile 3 Name"; "Tile 3 Name") { ApplicationArea = All; Caption = 'Name'; }
                    field("Tile Metric 3 Schema Code"; "Tile Metric 3 Calculation Code") { ApplicationArea = All; Caption = 'Calculation Code'; }
                }
            }
            group("Tile Color Customization")
            {
                field("Corporate Tile Color"; "Corporate Tile Color") { ApplicationArea = All; }
                field("Level 1 Tile Color"; "Level 1 Tile Color") { ApplicationArea = All; }
                field("Level 2 Tile Color"; "Level 2 Tile Color") { ApplicationArea = All; }
                field("Level 3 Tile Color"; "Level 3 Tile Color") { ApplicationArea = All; }
                field("Level 4 Tile Color"; "Level 4 Tile Color") { ApplicationArea = All; }
                field("Level 5 Tile Color"; "Level 5 Tile Color") { ApplicationArea = All; }
            }
            group(Permissions)
            {
                field("Permission Identifier"; "Permission Identifier") { ApplicationArea = All; }
                field("Basic Permission Set"; "Basic Permission Set") { ApplicationArea = All; }
                field("Level 1 Permission Set"; "Level 1 Permission Set") { ApplicationArea = All; }
                field("Level 2 Permission Set"; "Level 2 Permission Set") { ApplicationArea = All; }
                field("Level 3 Permission Set"; "Level 3 Permission Set") { ApplicationArea = All; }
                field("Level 4 Permission Set"; "Level 4 Permission Set") { ApplicationArea = All; }
                field("Level 5 Permission Set"; "Level 5 Permission Set") { ApplicationArea = All; }
            }
            group("Role Center Charts")
            {
                field("Default Chart 1"; "Default Chart 1") { ApplicationArea = All; }
                field("Default Chart 2"; "Default Chart 2") { ApplicationArea = All; }
                field("Chart 1 Type"; "Chart 1 Type") { ApplicationArea = All; }
                field("Chart 2 Type"; "Chart 2 Type") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}