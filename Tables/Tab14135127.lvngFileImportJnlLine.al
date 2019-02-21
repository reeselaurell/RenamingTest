table 14135127 "lvngFileImportJnlLine"
{
    DataClassification = CustomerContent;
    Caption = 'Gen. Journal Import Schema Lines';

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; lvngColumnNo; Integer)
        {
            Caption = 'Column No.';
            DataClassification = CustomerContent;
            MinValue = 1;
        }
        field(10; lvngImportFieldType; enum lvngGenJnlImportFieldType)
        {
            Caption = 'Import Field Type';
            DataClassification = CustomerContent;
        }
        field(11; lvngDescriptionSequence; Integer)
        {
            Caption = 'Description Sequence';
            DataClassification = CustomerContent;
        }
        field(12; lvngDimensionSplit; Boolean)
        {
            Caption = 'Dimension Split';
            DataClassification = CustomerContent;
        }
        field(13; lvngDimensionSplitCharacter; Text[10])
        {
            Caption = 'Dimension Split Character';
            DataClassification = CustomerContent;
        }
        field(14; lvngSplitDimensionNo; Integer)
        {
            Caption = 'Split Dimension No.';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 8;
        }
        field(15; lvngPurchaseImportFieldType; enum lvngPurchaseImportFieldType)
        {
            Caption = 'Import Field Type';
            DataClassification = CustomerContent;
        }
        field(16; lvngSalesImportFieldType; enum lvngSalesImportFieldType)
        {
            Caption = 'Import Field Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngCode, lvngColumnNo)
        {
            Clustered = true;
        }
    }

}