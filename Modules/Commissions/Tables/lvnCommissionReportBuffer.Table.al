table 14135316 "lvnCommissionReportBuffer"
{
    Caption = 'Commission Report Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Column No."; Integer)
        {
            Caption = 'Column No.';
            DataClassification = CustomerContent;
        }
        field(10; Value; text[250])
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
        field(11; "Value Data Type"; enum lvnLoanFieldValueType)
        {
            Caption = 'Value Data Type';
            DataClassification = CustomerContent;
        }
        field(12; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(16; "Excel Export Format"; Text[50])
        {
            Caption = 'Excel Export Format';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Column No.") { Clustered = true; }
    }
}