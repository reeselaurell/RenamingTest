table 14135212 lvngInvoiceErrorDetail
{
    Caption = 'Invoice Errors';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Document No."; Code[20]) { Caption = 'Document No.'; DataClassification = CustomerContent; }
        field(2; "Header Error"; Boolean) { Caption = 'Header'; DataClassification = CustomerContent; }
        field(3; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(4; "Error No."; Integer) { Caption = 'Error No'; DataClassification = CustomerContent; }
        field(10; "Error Text"; Text[250]) { Caption = 'Error Text'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Document No.", "Header Error", "Line No.", "Error No.") { Clustered = true; }
    }
}