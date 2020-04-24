page 14135238 lvngCloseManagerActivities
{
    PageType = CardPart;
    SourceTable = lvngCloseManagerCue;
    Caption = 'Close Manager Activities';

    layout
    {
        area(Content)
        {
            field("Filter By Assigned To"; "Filter By Assigned To") { ApplicationArea = All; }
            field("Filter By Assigned Approver"; "Filter By Assigned Approver") { ApplicationArea = All; }

            cuegroup(CloseManagerStatus)
            {
                Caption = 'Close Manager Status';
                CuegroupLayout = Wide;

                field("Total Tasks"; "Total Tasks") { ApplicationArea = All; }
                field("Outstanding Reconcilliations"; "Outstanding Reconcilliations") { ApplicationArea = All; }
                field("Tasks Awaiting Approval"; "Tasks Awaiting Approval") { ApplicationArea = All; }
                field("Tasks Approved"; "Tasks Approved") { ApplicationArea = All; }
                field(ItemDiscrepancy; ItemDiscrepancy) { ApplicationArea = All; Caption = 'Approved Item Discrepancy'; Editable = false; }
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
                    CueRecordRef: RecordRef;
                    CueSetup: Codeunit "Cues And KPIs";
                begin
                    CueRecordRef.GetTable(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }

            action(ToggleFilterByAssignedTo)
            {
                ApplicationArea = All;
                Caption = 'Toggle Filter By Assigned To';

                trigger OnAction()
                begin
                    Validate("Filter By Assigned To", not "Filter By Assigned To");
                    Modify(true);
                    CurrPage.Update(true);
                end;
            }

            action(ToggleFilterByAssignedApprover)
            {
                ApplicationArea = All;
                Caption = 'Toggle Filter By Assigned Approver';

                trigger OnAction()
                begin
                    Validate("Filter By Assigned Approver", not "Filter By Assigned Approver");
                    Modify(true);
                    CurrPage.Update(true);
                end;
            }
        }
    }

    var
        ItemDiscrepancy: Integer;

    trigger OnOpenPage()
    var
        CloseManagerEntryLine: Record lvngCloseManagerEntryLine;
    begin
        Reset();
        if not Get(UserId) then begin
            Init();
            Validate("User ID", UserId);
            Insert(true);
        end;
        if "Filter By Assigned To" then
            SetFilter("Assigned To Filter", UserId);
        if "Filter By Assigned Approver" then
            SetFilter("Assigned Approver Filter", UserId);
        ItemDiscrepancy := 0;
        Clear(CloseManagerEntryLine);
        CloseManagerEntryLine.SetRange(Reconciled, true);
        CloseManagerEntryLine.SetAutoCalcFields("G/L Total");
        if CloseManagerEntryLine.FindSet() then
            if CloseManagerEntryLine."G/L Total" <> CloseManagerEntryLine."Reconciled Total" then
                ItemDiscrepancy := ItemDiscrepancy + 1;
    end;
}