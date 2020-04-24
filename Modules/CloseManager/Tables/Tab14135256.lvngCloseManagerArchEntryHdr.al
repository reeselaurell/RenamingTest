table 14135256 lvngCloseManagerArchEntryHdr
{
    DataClassification = CustomerContent;
    LookupPageId = lvngCloseManagerArchEntryList;
    DrillDownPageId = lvngCloseManagerArchEntryList;
    Caption = 'Close Manager Archive Entry Header';

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; DataClassification = CustomerContent; }
        field(5; "Template No."; Code[20]) { Caption = 'Template No.'; DataClassification = CustomerContent; }
        field(10; "Period Date"; Date) { Caption = 'Period Date'; DataClassification = CustomerContent; }
        field(11; "Total Tasks"; Integer) { Caption = 'Total Tasks'; FieldClass = FlowField; CalcFormula = count (lvngCloseManagerArchEntryLine where("No." = field("No."))); Editable = false; }
        field(12; "Outstanding Reconcilliations"; Integer) { Caption = 'Outstanding Reconcilliations'; FieldClass = FlowField; CalcFormula = count (lvngCloseManagerArchEntryLine where("No." = field("No."), "Reconciled Date" = filter(''))); Editable = false; }
        field(13; "Tasks Awaiting Approval"; Integer) { Caption = 'Tasks Awaiting Approval'; FieldClass = FlowField; CalcFormula = count (lvngCloseManagerArchEntryLine where("No." = field("No."), Approved = const(false))); Editable = false; }
        field(14; "Tasks Approved"; Integer) { Caption = 'Tasks Approved'; FieldClass = FlowField; CalcFormula = count (lvngCloseManagerArchEntryLine where("No." = field("No."), Approved = const(true))); Editable = false; }
        field(14135999; "Document Guid"; Guid) { Caption = 'Document Guid'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }

    trigger OnDelete()
    var
        CloseManagerArchEntryLine: Record lvngCloseManagerArchEntryLine;
    begin
        CloseManagerArchEntryLine.Reset();
        CloseManagerArchEntryLine.SetRange("No.", "No.");
        CloseManagerArchEntryLine.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if "Document Guid" = EmptyGuid then
            "Document Guid" := CreateGuid();
    end;
}