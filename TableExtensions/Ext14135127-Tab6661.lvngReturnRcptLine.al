tableextension 14135127 lvngReturnRcptLine extends "Return Receipt Line"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; lvngServicingType; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
    }
}