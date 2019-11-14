table 14135127 "lvngFileImportJnlLine"
{
    DataClassification = CustomerContent;
    Caption = 'Gen. Journal Import Schema Lines';

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Column No."; Integer) { DataClassification = CustomerContent; MinValue = 1; }
        field(10; "Import Field Type"; enum lvngGenJnlImportFieldType) { DataClassification = CustomerContent; }
        field(11; "Description Sequence"; Integer) { DataClassification = CustomerContent; }
        field(12; "Dimension Split"; Boolean) { DataClassification = CustomerContent; }
        field(13; "Dimension Split Character"; Text[10]) { DataClassification = CustomerContent; }
        field(14; "Split Dimension No."; Integer) { DataClassification = CustomerContent; MinValue = 0; MaxValue = 8; }
        field(15; "Purchase Import Field Type"; enum lvngPurchaseImportFieldType) { Caption = 'Import Field Type'; DataClassification = CustomerContent; }
        field(16; "Sales Import Field Type"; enum lvngSalesImportFieldType) { Caption = 'Import Field Type'; DataClassification = CustomerContent; }
        field(17; "Deposit Import Field Type"; Enum lvngDepositImportFieldType) { Caption = 'Import Field Type'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code, "Column No.") { Clustered = true; }
    }
}