table 14135144 lvngPaymentImportBuffer
{
    DataClassification = CustomerContent;
    Caption = 'Payment Import Buffer';

    fields
    {
        field(1; "Vendor No."; Code[20]) { Caption = 'Vendor No.'; TableRelation = Vendor; DataClassification = CustomerContent; }
        field(2; "Check No."; Code[20]) { Caption = 'Check No.'; DataClassification = CustomerContent; }
        field(3; "Vendor Invoice No."; Code[35]) { Caption = 'Vendor Invoice No.'; DataClassification = CustomerContent; }
        field(10; "Payment Amount"; Decimal) { Caption = 'Payment Amount'; DataClassification = CustomerContent; }
        field(11; "Payment Date"; Date) { Caption = 'Payment Date'; DataClassification = CustomerContent; }
        field(12; "Invoice Amount"; Decimal) { Caption = 'Invoice Amount'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Vendor No.", "Check No.", "Vendor Invoice No.") { Clustered = true; }
    }
}