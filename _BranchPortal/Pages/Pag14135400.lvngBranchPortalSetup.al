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
                field("Show General Ledger"; "Show General Ledger") { ApplicationArea = All; }
                field("Show KPI"; "Show KPI") { ApplicationArea = All; }
                field("Show Performance Worksheet"; "Show Performance Worksheet") { ApplicationArea = All; }
                //field("Loan Level Report Schema Code"; "Loan Level Report Schema Code") { ApplicationArea = All; }
                field("Initial Dashboard Period"; "Initial Dashboard Period") { ApplicationArea = All; }
                field("Block Data To Date"; "Block Data To Date") { ApplicationArea = All; }
                field("Block Data From Date"; "Block Data From Date") { ApplicationArea = All; }
            }
            group(Metrics)
            {
                part("Dashboard Metrics"; lvngBranchMetricPart) { ApplicationArea = All; SubPageView = where(Type = const(lvngDashboard)); Caption = 'Dashboard Metrics'; }
                part("Tile Metrics"; lvngBranchMetricPart) { ApplicationArea = All; SubPageView = where(Type = const(lvngTile)); Caption = 'Tile Metrics'; }
            }
            group("Role Center Charts")
            {
                field("Chart 1 Type"; "Chart 1 Type") { ApplicationArea = All; }
                field("Chart 2 Type"; "Chart 2 Type") { ApplicationArea = All; }
                field("Chart 1 Kind"; "Chart 1 Kind") { ApplicationArea = All; }
                field("Chart 2 Kind"; "Chart 2 Kind") { ApplicationArea = All; }
            }
            part("Branch Performance Schemas"; lvngBranchPerfMappingPart) { ApplicationArea = All; SubPageView = sorting(Sequence) where("User ID" = const('')); }
            part("Loan Funding Schemas"; lvngLoanLevelReportMappingPart) { ApplicationArea = All; SubPageView = sorting(Sequence) where("User ID" = const('')); }
            group(Tiles)
            {
                field("Show Corporate Tile"; "Show Corporate Tile") { ApplicationArea = All; }
                field("Corporate Tile Color"; "Corporate Tile Color")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ColorPicker: Page lvngColorPicker;
                    begin
                        Clear(ColorPicker);
                        ColorPicker.SetValue(Text);
                        ColorPicker.LookupMode(true);
                        if ColorPicker.RunModal() = Action::LookupOK then begin
                            Text := ColorPicker.GetValue();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Level 1 Tile Color"; "Level 1 Tile Color")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ColorPicker: Page lvngColorPicker;
                    begin
                        Clear(ColorPicker);
                        ColorPicker.SetValue(Text);
                        ColorPicker.LookupMode(true);
                        if ColorPicker.RunModal() = Action::LookupOK then begin
                            Text := ColorPicker.GetValue();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Level 1 Permission Set"; "Level 1 Permission Set") { ApplicationArea = All; }
                field("Level 2 Tile Color"; "Level 2 Tile Color")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ColorPicker: Page lvngColorPicker;
                    begin
                        Clear(ColorPicker);
                        ColorPicker.SetValue(Text);
                        ColorPicker.LookupMode(true);
                        if ColorPicker.RunModal() = Action::LookupOK then begin
                            Text := ColorPicker.GetValue();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Level 2 Permission Set"; "Level 2 Permission Set") { ApplicationArea = All; }
                field("Level 3 Tile Color"; "Level 3 Tile Color")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ColorPicker: Page lvngColorPicker;
                    begin
                        Clear(ColorPicker);
                        ColorPicker.SetValue(Text);
                        ColorPicker.LookupMode(true);
                        if ColorPicker.RunModal() = Action::LookupOK then begin
                            Text := ColorPicker.GetValue();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Level 3 Permission Set"; "Level 3 Permission Set") { ApplicationArea = All; }
                field("Level 4 Tile Color"; "Level 4 Tile Color")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ColorPicker: Page lvngColorPicker;
                    begin
                        Clear(ColorPicker);
                        ColorPicker.SetValue(Text);
                        ColorPicker.LookupMode(true);
                        if ColorPicker.RunModal() = Action::LookupOK then begin
                            Text := ColorPicker.GetValue();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Level 4 Permission Set"; "Level 4 Permission Set") { ApplicationArea = All; }
                field("Level 5 Tile Color"; "Level 5 Tile Color")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ColorPicker: Page lvngColorPicker;
                    begin
                        Clear(ColorPicker);
                        ColorPicker.SetValue(Text);
                        ColorPicker.LookupMode(true);
                        if ColorPicker.RunModal() = Action::LookupOK then begin
                            Text := ColorPicker.GetValue();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Level 5 Permission Set"; "Level 5 Permission Set") { ApplicationArea = All; }
            }
            /*
            group(Permissions)
            {
                field("Permission Identifier"; "Permission Identifier") { ApplicationArea = All; }
                field("Basic Permission Set"; "Basic Permission Set") { ApplicationArea = All; }
            }
            */
        }
    }

    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        Level1: Text;
        Level2: Text;
        Level3: Text;
        Level4: Text;
        Level5: Text;
        Level1Visible: Boolean;
        Level2Visible: Boolean;
        Level3Visible: Boolean;
        Level4Visible: Boolean;
        Level5Visible: Boolean;

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
        LoanVisionSetup.Get();
        if LoanVisionSetup."Hierarchy Levels" > 0 then begin
            Level1Visible := true;
            Level1 := Format(LoanVisionSetup."Level 1");
            if LoanVisionSetup."Hierarchy Levels" > 1 then begin
                Level2Visible := true;
                Level2 := Format(LoanVisionSetup."Level 2");
                if LoanVisionSetup."Hierarchy Levels" > 2 then begin
                    Level3Visible := true;
                    Level3 := Format(LoanVisionSetup."Level 3");
                    if LoanVisionSetup."Hierarchy Levels" > 3 then begin
                        Level4Visible := true;
                        Level4 := Format(LoanVisionSetup."Level 4");
                        if LoanVisionSetup."Hierarchy Levels" > 4 then begin
                            Level5Visible := true;
                            Level5 := Format(LoanVisionSetup."Level 5");
                        end;
                    end;
                end;
            end;
        end;
    end;
}