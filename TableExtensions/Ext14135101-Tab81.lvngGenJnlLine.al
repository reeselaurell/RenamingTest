tableextension 14135101 lvngGenJnlLine extends "Gen. Journal Line"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135108; "Servicing Type"; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135500; "Import ID"; Guid) { Caption = 'Import ID'; DataClassification = CustomerContent; }
    }
}