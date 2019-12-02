tableextension 14135126 "lvngReturnRcprHeader" extends "Return Receipt Header"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
    }

}