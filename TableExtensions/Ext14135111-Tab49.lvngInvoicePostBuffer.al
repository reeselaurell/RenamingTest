tableextension 14135111 lvngInvoicePostBuffer extends "Invoice Post. Buffer"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; }
        field(14135101; Description; Text[50]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(14135102; "Servicing Type"; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135103; "Reason Code"; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; }
    }
}