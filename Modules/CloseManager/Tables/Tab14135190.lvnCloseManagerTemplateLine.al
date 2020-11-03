table 14135190 "lvnCloseManagerTemplateLine"
{
    DataClassification = CustomerContent;
    Caption = 'Close Manager Template Line';

    fields
    {
        field(1; "Template No."; Code[20]) { Caption = 'Template No.'; DataClassification = CustomerContent; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(10; "Task Category"; Code[10]) { Caption = 'Task Category'; DataClassification = CustomerContent; TableRelation = lvnCloseManagerCategory; }
        field(11; "Task Name"; Text[50]) { Caption = 'Task Name'; DataClassification = CustomerContent; }
        field(12; "Due Date Calculation"; DateFormula) { Caption = 'Due Date Calculation'; DataClassification = CustomerContent; }
        field(13; "Account No."; Code[20]) { Caption = 'Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"; }
        field(14; "Assigned To"; Code[50]) { Caption = 'Assigned To'; DataClassification = CustomerContent; TableRelation = "User Setup"."User ID"; ValidateTableRelation = false; }
        field(15; "Assigned Approver"; Code[50]) { Caption = 'Assigned Approver'; DataClassification = CustomerContent; TableRelation = "User Setup"."User ID"; ValidateTableRelation = false; }
        field(16; Instructions; Text[250]) { Caption = 'Instructions'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Template No.", "Line No.") { Clustered = true; }
    }
}