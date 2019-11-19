tableextension 14135115 lvngSalesInvoiceLine extends "Sales Invoice Line"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; "Servicing Type"; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135102; "Reason Code"; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code".Code; }
    }
}