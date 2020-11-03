table 14135129 "lvnImportBufferError"
{
    DataClassification = CustomerContent;
    Caption = 'Import Buffer Error';

    fields
    {
        field(1; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(2; "Error No."; Integer) { Caption = 'Error No.'; DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { Caption = 'Description'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Line No.", "Error No.") { Clustered = true; }
    }

}