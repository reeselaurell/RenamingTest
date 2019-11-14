table 14135406 lvngBranchUserGLMapping
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Code[50]) { DataClassification = CustomerContent; }
        field(2; "G/L Account No."; Code[20]) { DataClassification = CustomerContent; }
        field(10; "G/L Account Name"; Text[100]) { FieldClass = FlowField; Editable = false; CalcFormula = lookup ("G/L Account".Name where("No." = field("G/L Account No."))); }
    }
}