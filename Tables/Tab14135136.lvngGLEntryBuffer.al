table 14135136 lvngGLEntryBuffer
{
    Caption = 'G/L Entry Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = CustomerContent; }
        field(4; "Posting Date"; Date) { Caption = 'Posting Date'; DataClassification = CustomerContent; }
        field(17; Amount; Decimal) { Caption = 'Amount'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}