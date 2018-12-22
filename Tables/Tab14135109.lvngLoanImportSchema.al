table 14135109 "lvngLoanImportSchema"
{
    Caption = 'Loan Import Schema';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; lvngDescription; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; lvngFieldSeparatorCharacter; Text[10])
        {
            Caption = 'Field Separator Character';
            DataClassification = CustomerContent;
        }
        field(12; "lvngFieldDelimiterCharacter"; Text[10])
        {
            Caption = 'Field Delimiter Character';
            DataClassification = CustomerContent;
        }
        field(13; lvngSkipLines; Integer)
        {
            Caption = 'Skip Lines';
            DataClassification = CustomerContent;
        }
        field(14; lvngLoanJournalBatchType; enum lvngLoanJournalBatchType)
        {
            Caption = 'Journal Batch Type';
            DataClassification = CustomerContent;
        }




    }

    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }

}