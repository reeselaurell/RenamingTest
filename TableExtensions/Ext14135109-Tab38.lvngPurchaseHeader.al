tableextension 14135109 lvngPurchaseHeader extends "Purchase Header"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; lvngDocumentTotalCheck; Decimal) { Caption = 'Document Total (Check)'; DataClassification = CustomerContent; BlankZero = true; }
    }

}