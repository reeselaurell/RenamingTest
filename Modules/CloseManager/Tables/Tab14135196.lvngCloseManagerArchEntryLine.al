table 14135196 lvngCloseManagerArchEntryLine
{
    DataClassification = CustomerContent;
    Caption = 'Close Manager Entry Line Archive';

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; DataClassification = CustomerContent; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(5; "Template No."; Code[20]) { Caption = 'Template No.'; DataClassification = CustomerContent; }
        field(10; "Task Category"; Code[20]) { Caption = 'Task Category'; DataClassification = CustomerContent; TableRelation = lvngCloseManagerCategory; Editable = false; }
        field(11; "Task Name"; Text[50]) { Caption = 'Task Name'; DataClassification = CustomerContent; Editable = false; }
        field(12; "Due Date Calculation"; DateFormula) { Caption = 'Due Date Calculation'; DataClassification = CustomerContent; }
        field(13; "Account Number"; Code[20]) { Caption = 'Account Name'; DataClassification = CustomerContent; Editable = false; }
        field(14; "Assigned To"; Code[50]) { Caption = 'Assigned To'; DataClassification = CustomerContent; TableRelation = "User Setup"."User ID"; ValidateTableRelation = false; }
        field(15; "Assigned Approver"; Code[50]) { Caption = 'Assigned Approver'; DataClassification = CustomerContent; TableRelation = "User Setup"."User ID"; ValidateTableRelation = false; }
        field(16; Instructions; Text[250]) { Caption = 'Instructions'; DataClassification = CustomerContent; }
        field(17; "G/L Total"; Decimal) { Caption = 'G/L Total'; FieldClass = FlowField; CalcFormula = sum ("G/L Entry".Amount where("G/L Account No." = field("Account Number"))); Editable = false; }
        field(18; "Reconciled Total"; Decimal) { Caption = 'Reconciled Total'; DataClassification = CustomerContent; }
        field(19; Reconciled; Boolean) { Caption = 'Reconciled'; DataClassification = CustomerContent; }
        field(20; "Reconciled By"; Code[50]) { Caption = 'Reconciled By'; DataClassification = CustomerContent; Editable = false; }
        field(21; "Reconciled Date"; DateTime) { Caption = 'Reconciled Date'; DataClassification = CustomerContent; }
        field(22; "Awaiting Approval"; Boolean) { Caption = 'Awaiting Approval'; DataClassification = CustomerContent; }
        field(23; "Approved"; Boolean) { Caption = 'Approved'; DataClassification = CustomerContent; }
        field(24; "Approved By"; Code[50]) { Caption = 'Approved By'; DataClassification = CustomerContent; Editable = false; }
        field(25; "Approved Date"; DateTime) { Caption = 'Approved Date'; DataClassification = CustomerContent; Editable = false; }
        field(26; Note; Text[250]) { Caption = 'Note'; DataClassification = CustomerContent; }
        field(101; "Period Date"; Date) { Caption = 'Period Date'; FieldClass = FlowField; CalcFormula = lookup (lvngCloseManagerArchEntryHdr."Period Date" where("No." = field("No."))); }
        field(14135999; "Document Guid"; Guid) { Caption = 'Document Guid'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "No.", "Line No.") { Clustered = true; }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if "Document Guid" = EmptyGuid then
            "Document Guid" := CreateGuid();
    end;
}