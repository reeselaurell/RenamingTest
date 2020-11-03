table 14135195 "lvnCloseManagerCue"
{
    DataClassification = CustomerContent;
    Caption = 'Close Manager Cue';

    fields
    {
        field(1; "User ID"; Code[50]) { Caption = 'User ID'; DataClassification = CustomerContent; }
        field(10; "Filter By Assigned To"; Boolean)
        {
            Caption = 'Filter By Assigned To';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Filter By Assigned To" then
                    SetFilter("Assigned To Filter", UserId)
                else
                    SetRange("Assigned To Filter");
            end;
        }
        field(6; "Filter By Assigned Approver"; Boolean)
        {
            Caption = 'Filter By Assigned Approver';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Filter By Assigned Approver" then
                    SetFilter("Assigned Approver Filter", UserId)
                else
                    SetRange("Assigned Approver Filter");
            end;
        }
        field(11; "Total Tasks"; Integer) { Caption = 'Total Tasks'; FieldClass = FlowField; CalcFormula = count(lvnCloseManagerEntryLine where("Assigned To" = field("Assigned To Filter"), "Assigned Approver" = field("Assigned To Filter"))); Editable = false; }
        field(12; "Outstanding Reconcilliations"; Integer) { Caption = 'Outstanding Reconcilliations'; FieldClass = FlowField; CalcFormula = count(lvnCloseManagerEntryLine where("Reconciled Date" = filter(''), "Assigned To" = field("Assigned To Filter"), "Assigned Approver" = field("Assigned To Filter"))); Editable = false; }
        field(13; "Tasks Awaiting Approval"; Integer) { Caption = 'Tasks Awaiting Approval'; FieldClass = FlowField; CalcFormula = count(lvnCloseManagerEntryLine where("Awaiting Approval" = const(true), "Assigned To" = field("Assigned To Filter"), "Assigned Approver" = field("Assigned To Filter"))); Editable = false; }
        field(14; "Tasks Approved"; Integer) { Caption = 'Tasks Approved'; FieldClass = FlowField; CalcFormula = count(lvnCloseManagerEntryLine where(Approved = const(true), "Assigned To" = field("Assigned To Filter"), "Assigned Approver" = field("Assigned To Filter"))); Editable = false; }
        field(100; "Assigned To Filter"; Code[100]) { Caption = 'Assigned To Filter'; FieldClass = FlowFilter; }
        field(101; "Assigned Approver Filter"; Code[100]) { Caption = 'Assigned Approver Filter'; FieldClass = FlowFilter; }
    }

    keys
    {
        key(PK; "User ID") { Clustered = true; }
    }
}