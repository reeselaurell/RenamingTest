table 14135213 lvngSalesInvHdrBuffer
{
    Caption = 'Sales Invoice Header Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; DataClassification = CustomerContent; }
        field(10; "Posting Date"; Date) { Caption = 'Posting Date'; DataClassification = CustomerContent; }
        field(11; "Document Date"; Date) { Caption = 'Document Date'; DataClassification = CustomerContent; }
        field(12; "Payment Method Code"; Code[10]) { Caption = 'Payment Method Code'; DataClassification = CustomerContent; TableRelation = "Payment Method"; }
        field(13; "Due Date"; Date) { Caption = 'Due Date'; DataClassification = CustomerContent; }
        field(14; "Posting Description"; Text[100]) { Caption = 'Posting Description'; DataClassification = CustomerContent; }
        field(15; "Sell-to Customer No."; Code[20]) { Caption = 'Sell-to Customer No.'; DataClassification = CustomerContent; TableRelation = Customer; }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }
}