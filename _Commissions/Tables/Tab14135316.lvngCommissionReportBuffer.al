table 14135316 "lvngCommissionReportBuffer"
{
    Caption = 'Commission Report Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngColumnNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Column No.';
        }
        field(10; lvngValue; text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Value';
        }
        field(11; lvngDataType; enum lvngLoanFieldValueType)
        {
            Caption = 'Data Type';
            DataClassification = CustomerContent;
        }
        field(12; lvngDescription; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(16; lvngExcelExportFormat; Text[50])
        {
            Caption = 'Excel Export Format';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngColumnNo)
        {
            Clustered = true;
        }
    }
}