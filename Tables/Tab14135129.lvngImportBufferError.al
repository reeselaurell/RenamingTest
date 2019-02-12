table 14135129 "lvngImportBufferError"
{
    DataClassification = CustomerContent;
    Caption = 'Import Buffer Error';

    fields
    {
        field(1; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(2; lvngErrorNo; Integer)
        {
            Caption = 'Error No.';
            DataClassification = CustomerContent;
        }
        field(10; lvngDescription; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngLineNo, lvngErrorNo)
        {
            Clustered = true;
        }
    }

}