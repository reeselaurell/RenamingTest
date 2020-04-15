page 14135257 lvngCloseManagerEntryLines
{
    PageType = List;
    SourceTable = lvngCloseManagerEntryLine;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Close Manager Entry Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Task Category"; "Task Category") { ApplicationArea = All; }
                field("Task Name"; "Task Name") { ApplicationArea = All; }
                field("Due Date Calculation"; "Due Date Calculation") { ApplicationArea = All; }
                field("Account Number"; "Account Number") { ApplicationArea = All; }
                field(DueDate; DueDate) { ApplicationArea = All; Caption = 'Due Date'; }
                field("G/L Total"; "G/L Total") { ApplicationArea = All; }
                field("Reconciled Total"; "Reconciled Total") { ApplicationArea = All; }
                field(Reconciled; Reconciled) { ApplicationArea = All; }
                field("Reconciled By"; "Reconciled By") { ApplicationArea = All; }
                field("Assigned To"; "Assigned To") { ApplicationArea = All; }
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

        area(FactBoxes)
        {
            part(DocumentsExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
        }
    }

    var
        DueDate: Date;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Document Guid" := CreateGuid();
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Period Date");
        if "Period Date" = 0D then
            DueDate := 0D
        else
            if Format("Due Date Calculation") = '' then
                DueDate := "Period Date"
            else
                DueDate := CalcDate("Due Date Calculation", "Period Date");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentsExchange.Page.ReloadDocuments("Document Guid");
    end;
}