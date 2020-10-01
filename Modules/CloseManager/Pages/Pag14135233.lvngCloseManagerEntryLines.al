page 14135233 lvngCloseManagerEntryLines
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

                field("Task Category"; Rec."Task Category") { ApplicationArea = All; }
                field("Task Name"; Rec."Task Name") { ApplicationArea = All; }
                field("Due Date Calculation"; Rec."Due Date Calculation") { ApplicationArea = All; }
                field("Account Number"; Rec."Account Number") { ApplicationArea = All; }
                field(DueDate; DueDate) { ApplicationArea = All; Caption = 'Due Date'; }
                field("G/L Total"; Rec."G/L Total") { ApplicationArea = All; }
                field("Reconciled Total"; Rec."Reconciled Total") { ApplicationArea = All; }
                field(Reconciled; Rec.Reconciled) { ApplicationArea = All; }
                field("Reconciled By"; Rec."Reconciled By") { ApplicationArea = All; }
                field("Assigned To"; Rec."Assigned To") { ApplicationArea = All; }
                field("Reconciled Date"; Rec."Reconciled Date") { ApplicationArea = All; }
                field("Assigned Approver"; Rec."Assigned Approver") { ApplicationArea = All; }
                field("Awaiting Approval"; Rec."Awaiting Approval") { ApplicationArea = All; }
                field(Approved; Rec.Approved) { ApplicationArea = All; }
                field("Approved By"; Rec."Approved By") { ApplicationArea = All; }
                field("Approved Date"; Rec."Approved Date") { ApplicationArea = All; }
                field(Note; Rec.Note) { ApplicationArea = All; }
                field(Instructions; Rec.Instructions) { ApplicationArea = All; }
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
        Rec."Document Guid" := CreateGuid();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Period Date");
        if Rec."Period Date" = 0D then
            DueDate := 0D
        else
            if Format(Rec."Due Date Calculation") = '' then
                DueDate := Rec."Period Date"
            else
                DueDate := CalcDate(Rec."Due Date Calculation", Rec."Period Date");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentsExchange.Page.ReloadDocuments(Rec."Document Guid");
    end;
}