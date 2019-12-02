tableextension 14135108 lvngSalesLine extends "Sales Line"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; lvngServicingType; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135102; lvngReasonCode; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code".Code; }
    }
}