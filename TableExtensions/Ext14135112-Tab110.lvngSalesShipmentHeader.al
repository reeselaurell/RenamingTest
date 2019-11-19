tableextension 14135112 lvngSalesShipmentHeader extends "Sales Shipment Header"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
    }
}