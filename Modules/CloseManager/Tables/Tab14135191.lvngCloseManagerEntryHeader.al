table 14135191 lvngCloseManagerEntryHeader
{
    DataClassification = CustomerContent;
    Caption = 'Close Manager Entry Header';
    LookupPageId = lvngCloseManagerEntryList;
    DrillDownPageId = lvngCloseManagerEntryList;

    fields
    {
        field(1; "Template No."; Code[20]) { Caption = 'Template No.'; DataClassification = CustomerContent; }
        field(10; "Period Date"; Date) { Caption = 'Period Date'; DataClassification = CustomerContent; }
        field(11; "Total Tasks"; Integer) { Caption = 'Total Tasks'; FieldClass = FlowField; CalcFormula = count (lvngCloseManagerEntryLine where("Template No." = Field("Template No."))); Editable = false; }
        field(12; "Outstanding Reconcilliations"; Integer) { Caption = 'Outstanding Reconcilliations'; FieldClass = FlowField; CalcFormula = count (lvngCloseManagerEntryLine where("Template No." = field("Template No."), "Reconciled Date" = filter(''))); Editable = false; }
        field(13; "Tasks Awaiting Approval"; Integer) { Caption = 'Tasks Awaiting Approval'; FieldClass = FlowField; CalcFormula = count (lvngCloseManagerEntryLine where("Template No." = field("Template No."), "Awaiting Approval" = const(true))); Editable = false; }
        field(14; "Tasks Approved"; Integer) { Caption = 'Tasks Approved'; FieldClass = FlowField; CalcFormula = count (lvngCloseManagerEntryLine where("Template No." = field("Template No."), Approved = const(true))); Editable = false; }
        field(14135999; "Document Guid"; Guid) { Caption = 'Document Guid'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Template No.") { Clustered = true; }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if "Document Guid" = EmptyGuid then
            "Document Guid" := CreateGuid();
    end;

    trigger OnDelete()
    var
        CloseManagerEntryLine: Record lvngCloseManagerEntryLine;
    begin
        CloseManagerEntryLine.Reset();
        CloseManagerEntryLine.SetRange("Template No.", "Template No.");
        CloseManagerEntryLine.DeleteAll(true);
    end;
}