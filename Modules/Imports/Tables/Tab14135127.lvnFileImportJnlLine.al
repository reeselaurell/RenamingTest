table 14135127 "lvnFileImportJnlLine"
{
    DataClassification = CustomerContent;
    Caption = 'Gen. Journal Import Schema Lines';

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(2; "Column No."; Integer) { Caption = 'Column No.'; DataClassification = CustomerContent; MinValue = 1; }
        field(10; "Import Field Type"; enum lvnGenJnlImportFieldType) { Caption = 'Import Field Type'; DataClassification = CustomerContent; }
        field(11; "Description Sequence"; Integer) { Caption = 'Description Sequence'; DataClassification = CustomerContent; }
        field(12; "Dimension Split"; Boolean) { Caption = 'Dimension Split'; DataClassification = CustomerContent; }
        field(13; "Dimension Split Character"; Text[10]) { Caption = 'Dimension Split Character'; DataClassification = CustomerContent; }
        field(14; "Split Dimension No."; Integer) { Caption = 'Split Dimension No.'; DataClassification = CustomerContent; MinValue = 0; MaxValue = 8; }
        field(15; "Purchase Import Field Type"; enum lvnPurchaseImportFieldType) { Caption = 'Import Field Type'; DataClassification = CustomerContent; }
        field(16; "Sales Import Field Type"; enum lvnSalesImportFieldType) { Caption = 'Import Field Type'; DataClassification = CustomerContent; }
        field(17; "Deposit Import Field Type"; Enum lvnDepositImportFieldType) { Caption = 'Import Field Type'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code, "Column No.") { Clustered = true; }
    }
}