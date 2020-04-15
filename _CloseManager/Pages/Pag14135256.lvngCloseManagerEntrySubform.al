page 14135256 lvngCloseManagerEntrySubform
{
    PageType = ListPart;
    SourceTable = lvngCloseManagerEntryLine;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Close Manager Entry Subform';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Task Category"; "Task Category") { ApplicationArea = All; }
                field("Task Name"; "Task Name") { ApplicationArea = All; }
                field(DueDate; DueDate) { ApplicationArea = All; Caption = 'Due Date'; }
                field("Assigned To"; "Assigned To") { ApplicationArea = All; }
                field("Account Number"; "Account Number") { ApplicationArea = All; }
                field("G/L Total"; "G/L Total") { ApplicationArea = All; }
                field("Reconciled Total"; "Reconciled Total") { ApplicationArea = All; }
                field(Reconciled; Reconciled) { ApplicationArea = All; }
                field("Reconciled By"; "Reconciled By") { ApplicationArea = All; }
                field("Reconciled Date"; "Reconciled Date") { ApplicationArea = All; }
                field("Assigned Approver"; "Assigned Approver") { ApplicationArea = All; }
                field("Awaiting Approval"; "Awaiting Approval") { ApplicationArea = All; }
                field(Approved; Approved) { ApplicationArea = All; }
                field("Approved By"; "Approved By") { ApplicationArea = All; }
                field("Approved Date"; "Approved Date") { ApplicationArea = All; }
                field(Note; Note) { ApplicationArea = All; }
                field(Instructions; Instructions) { ApplicationArea = All; }
            }
        }
    }

    var
        DueDate: Date;

    trigger OnAfterGetRecord()
    var
        CloseManagerEntryHeader: Record lvngCloseManagerEntryHeader;
    begin
        CloseManagerEntryHeader.Get(Rec."Template No.");
        SetFilter("Date Filter", '..%1', CloseManagerEntryHeader."Period Date");
        CalcFields("Period Date");
        if "Period Date" = 0D then
            DueDate := 0D
        else
            if Format("Due Date Calculation") = '' then
                DueDate := "Period Date"
            else
                DueDate := CalcDate("Due Date Calculation", "Period Date");
    end;
}