page 14135238 "lvnCloseManagerActivities"
{
    PageType = CardPart;
    SourceTable = lvnCloseManagerCue;
    Caption = 'Close Manager Activities';

    layout
    {
        area(Content)
        {
            field("Filter By Assigned To"; Rec."Filter By Assigned To")
            {
                ApplicationArea = All;
            }
            field("Filter By Assigned Approver"; Rec."Filter By Assigned Approver")
            {
                ApplicationArea = All;
            }
            cuegroup(CloseManagerStatus)
            {
                Caption = 'Close Manager Status';
                CuegroupLayout = Wide;

                field("Total Tasks"; Rec."Total Tasks")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Reconcilliations"; Rec."Outstanding Reconcilliations")
                {
                    ApplicationArea = All;
                }
                field("Tasks Awaiting Approval"; Rec."Tasks Awaiting Approval")
                {
                    ApplicationArea = All;
                }
                field("Tasks Approved"; Rec."Tasks Approved")
                {
                    ApplicationArea = All;
                }
                field(ItemDiscrepancy; ItemDiscrepancy)
                {
                    ApplicationArea = All;
                    Caption = 'Approved Item Discrepancy';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SetUpCues)
            {
                ApplicationArea = All;
                Caption = 'Set Up Cues';
                Image = Setup;

                trigger OnAction()
                var
                    CueSetup: Codeunit "Cues And KPIs";
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
            action(ToggleFilterByAssignedTo)
            {
                ApplicationArea = All;
                Image = ToggleBreakpoint;
                Caption = 'Toggle Filter By Assigned To';

                trigger OnAction()
                begin
                    Rec.Validate("Filter By Assigned To", not Rec."Filter By Assigned To");
                    Rec.Modify(true);
                    CurrPage.Update(true);
                end;
            }
            action(ToggleFilterByAssignedApprover)
            {
                ApplicationArea = All;
                Image = ToggleBreakpoint;
                Caption = 'Toggle Filter By Assigned Approver';

                trigger OnAction()
                begin
                    Rec.Validate("Filter By Assigned Approver", not Rec."Filter By Assigned Approver");
                    Rec.Modify(true);
                    CurrPage.Update(true);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        CloseManagerEntryLine: Record lvnCloseManagerEntryLine;
    begin
        Rec.Reset();
        if not Rec.Get(UserId) then begin
            Rec.Init();
            Rec.Validate("User ID", UserId);
            Rec.Insert(true);
        end;
        if Rec."Filter By Assigned To" then
            Rec.SetFilter("Assigned To Filter", UserId);
        if Rec."Filter By Assigned Approver" then
            Rec.SetFilter("Assigned Approver Filter", UserId);
        ItemDiscrepancy := 0;
        Clear(CloseManagerEntryLine);
        CloseManagerEntryLine.SetRange(Reconciled, true);
        CloseManagerEntryLine.SetAutoCalcFields("G/L Total");
        if CloseManagerEntryLine.FindSet() then
            if CloseManagerEntryLine."G/L Total" <> CloseManagerEntryLine."Reconciled Total" then
                ItemDiscrepancy := ItemDiscrepancy + 1;
    end;

    var
        ItemDiscrepancy: Integer;
}