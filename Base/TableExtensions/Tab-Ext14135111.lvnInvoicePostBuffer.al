tableextension 14135111 "lvnInvoicePostBuffer" extends "Invoice Post. Buffer"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; }
        field(14135101; lvnDescription; Text[50]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(14135102; lvnServicingType; enum lvnServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135103; lvnReasonCode; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; }
        field(14135110; lvnComment; Text[250]) { Caption = 'Comment'; DataClassification = CustomerContent; }
    }
}
