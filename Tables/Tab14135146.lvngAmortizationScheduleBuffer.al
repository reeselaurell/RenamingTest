table 14135146 lvngAmortizationScheduleBuffer
{
    Caption = 'Amortization Schedule Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = CustomerContent; }
        field(10; Date; Date) { Caption = 'Date'; DataClassification = CustomerContent; }
        field(11; Principal; Decimal) { Caption = 'Principal'; DataClassification = CustomerContent; }
        field(12; Interest; Decimal) { Caption = 'Interest'; DataClassification = CustomerContent; }
        field(13; Balance; Decimal) { Caption = 'Balance'; DataClassification = CustomerContent; }
        field(14; "Payment Amount"; Decimal) { Caption = 'Payment Amount'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}