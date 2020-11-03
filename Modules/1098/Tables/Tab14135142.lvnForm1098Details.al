table 14135142 "lvnForm1098Details"
{
    Caption = 'Form 1098 Details';
    DataClassification = CustomerContent;
    LookupPageId = lvnForm1098Details;

    fields
    {
        field(1; "Loan No."; Code[20]) { DataClassification = CustomerContent; Caption = 'Loan No.'; TableRelation = lvnLoan; }
        field(2; "Box No."; Integer) { DataClassification = CustomerContent; Caption = 'Box No.'; }
        field(3; "Line No."; Integer) { DataClassification = CustomerContent; Caption = 'Line No.'; }
        field(10; Type; Enum lvnForm1098EntryType) { DataClassification = CustomerContent; Caption = 'Type'; }
        field(11; "G/L Entry No."; Integer) { DataClassification = CustomerContent; Caption = 'G/L Entry No.'; }
        field(12; Description; Text[50]) { DataClassification = CustomerContent; Caption = 'Description'; }
        field(13; Amount; Decimal) { DataClassification = CustomerContent; Caption = 'Amount'; }
        field(14; "Rule Line No."; Integer) { DataClassification = CustomerContent; Caption = 'Rule Line No.'; }
        field(15; "Rule Description"; Text[50]) { FieldClass = FlowField; Caption = 'Rule Description'; CalcFormula = lookup(lvnForm1098ColRuleDetails.Description where("Box No." = field("Box No."), "Line No." = field("Rule Line No."))); }
        field(100; "Posting Date"; Date) { FieldClass = FlowField; Caption = 'Posting Date'; CalcFormula = lookup("G/L Entry"."Posting Date" where("Entry No." = field("G/L Entry No."))); }
        field(101; "Closed at Date"; Date) { DataClassification = CustomerContent; Caption = 'Closed at Date'; }
    }

    keys
    {
        key(PK; "Loan No.", "Box No.", "Line No.") { Clustered = true; }
    }
}