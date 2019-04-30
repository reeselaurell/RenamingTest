table 14135136 "lvngGLEntryBuffer"
{
    Caption = 'G/L Entry Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngEntryNo; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }

        field(4; lvngPostingDate; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }

        field(17; lvngAmount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(PK; lvngEntryNo)
        {
            Clustered = true;
        }
    }
}