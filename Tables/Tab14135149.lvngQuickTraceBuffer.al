table 14135149 lvngQuickTraceBuffer
{
    Caption = 'Quick Trace Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; }
    }
    keys
    {
        key(PK; "Loan No.") { Clustered = true; }
    }
}