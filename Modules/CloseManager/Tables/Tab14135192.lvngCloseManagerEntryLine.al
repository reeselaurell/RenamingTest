table 14135192 lvngCloseManagerEntryLine
{
    DataClassification = CustomerContent;
    Caption = 'Close Manager Entry Line';
    LookupPageId = lvngCloseManagerEntryLines;
    DrillDownPageId = lvngCloseManagerEntryLines;

    fields
    {
        field(1; "Template No."; Code[20]) { Caption = 'Template No.'; DataClassification = CustomerContent; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(10; "Task Category"; Code[10]) { Caption = 'Task Category'; DataClassification = CustomerContent; TableRelation = lvngCloseManagerCategory; }
        field(11; "Task Name"; Text[50]) { Caption = 'Task Name'; DataClassification = CustomerContent; Editable = false; }
        field(12; "Due Date Calculation"; DateFormula) { Caption = 'Due Date Calculation'; DataClassification = CustomerContent; Editable = false; }
        field(13; "Account Number"; Code[20]) { Caption = 'Account Number'; DataClassification = CustomerContent; Editable = false; }
        field(14; "Assigned To"; Code[50]) { Caption = 'Assigned To'; DataClassification = CustomerContent; TableRelation = "User Setup"."User ID"; ValidateTableRelation = false; }
        field(15; "Assigned Approver"; Code[50]) { Caption = 'Assigned Approver'; DataClassification = CustomerContent; TableRelation = "User Setup"."User ID"; ValidateTableRelation = false; }
        field(16; Instructions; Text[250]) { Caption = 'Instructions'; DataClassification = CustomerContent; }
        field(17; "G/L Total"; Decimal) { Caption = 'G/L Total'; FieldClass = FlowField; CalcFormula = sum ("G/L Entry".Amount where("G/L Account No." = field("Account Number"), "Posting Date" = field(filter("Date Filter")))); Editable = false; }
        field(18; "Reconciled Total"; Decimal)
        {
            Caption = 'Reconciled Total';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Reconciled Total" <> xRec."Reconciled Total" then
                    TestField(Reconciled, false);
            end;
        }
        field(19; Reconciled; Boolean)
        {
            Caption = 'Reconciled';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Reconciled then begin
                    CalcFields("G/L Total");
                    if ("G/L Total" <> "Reconciled Total") and GuiAllowed() then
                        if not Confirm(ReconciliationTotalsNotMatchQst, false, Rec.FieldCaption("G/L Total"), Rec.FieldCaption("Reconciled Total")) then
                            Error(ReconciliationTotalsMustMatchErr);
                    Validate("Reconciled By", UserId);
                    Validate("Reconciled Date", CurrentDateTime);
                    Validate("Awaiting Approval", true);
                end else begin
                    Validate("Reconciled By", '');
                    Validate("Reconciled Date", 0DT);
                    Validate("Awaiting Approval", false);
                end;
            end;
        }
        field(20; "Reconciled By"; Code[50]) { Caption = 'Reconciled By'; DataClassification = CustomerContent; Editable = false; }
        field(21; "Reconciled Date"; DateTime) { Caption = 'Reconciled Date'; DataClassification = CustomerContent; Editable = false; }
        field(22; "Awaiting Approval"; Boolean) { Caption = 'Awaiting Approval'; DataClassification = CustomerContent; Editable = false; }
        field(23; Approved; Boolean)
        {
            Caption = 'Approved';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Approved then begin
                    TestField(Reconciled);
                    Validate("Approved By", UserId());
                    Validate("Approved Date", CurrentDateTime);
                    Rec.Validate("Awaiting Approval", false);
                end else begin
                    Rec.Validate("Approved By", '');
                    Rec.Validate("Approved Date", 0DT);
                    if Rec.Reconciled then
                        Rec.Validate("Awaiting Approval", true);
                end;
            end;
        }
        field(24; "Approved By"; Code[50]) { Caption = 'Approved By'; DataClassification = CustomerContent; Editable = false; }
        field(25; "Approved Date"; DateTime) { Caption = 'Approved Date'; DataClassification = CustomerContent; Editable = false; }
        field(26; Note; Text[250]) { Caption = 'Note'; DataClassification = CustomerContent; }
        field(100; "Date Filter"; Date) { Caption = 'Date Filter'; FieldClass = FlowFilter; }
        field(101; "Period Date"; Date) { Caption = 'Period Date'; FieldClass = FlowField; CalcFormula = lookup (lvngCloseManagerEntryHeader."Period Date" where("Template No." = field("Template No."))); }
        field(14135999; "Document Guid"; Guid) { Caption = 'Document Guid'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Template No.", "Line No.") { Clustered = true; }
    }

    var
        ReconciliationTotalsNotMatchQst: Label 'The %1 and %2 does not match. Are you sure you want to reconcile this entry?';
        ReconciliationTotalsMustMatchErr: Label 'Reconciliation totals must match';

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if "Document Guid" = EmptyGuid then
            "Document Guid" := CreateGuid();
    end;
}