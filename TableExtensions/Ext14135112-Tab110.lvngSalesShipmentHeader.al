tableextension 14135112 lvngSalesShipmentHeader extends "Sales Shipment Header"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
    }
}