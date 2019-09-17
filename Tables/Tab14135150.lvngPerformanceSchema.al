table 14135150 "lvngPerformanceSchema"
{
    Caption = 'Performance Schema';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; lvngPerformanceSchemaType; enum lvngPerformanceSchemaType)
        {
            Caption = 'Schema Type';
            DataClassification = CustomerContent;
        }
        field(11; lvngDescription; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(12; lvngBasedOnDimensionCode; Code[20])
        {
            Caption = 'Based On Dimension';
            DataClassification = CustomerContent;
            TableRelation = Dimension.Code;
        }
        field(13; lvngSubColumns; Integer)
        {
            Caption = 'Sub-Columns Count';
            ValuesAllowed = 1, 2, 3;
            InitValue = 1;
            DataClassification = CustomerContent;
        }

        field(20; lvngLoanLevelSubColumn1Caption; Text[50])
        {
            Caption = 'Loan Level Sub-Column 1 Caption';
            DataClassification = CustomerContent;
            InitValue = 'Volume';
        }
        field(21; lvngLoanLevelSubColumn2Caption; Text[50])
        {
            Caption = 'Loan Level Sub-Column 2 Caption';
            DataClassification = CustomerContent;
            InitValue = 'Loans';
        }
        field(22; lvngLoanLevelSubColumn3Caption; Text[50])
        {
            Caption = 'Loan Level Sub-Column 3 Caption';
            DataClassification = CustomerContent;
            InitValue = '%';
        }
        field(23; lvngGLSubColumn1Caption; Text[50])
        {
            Caption = 'G/L Level Sub-Column 1 Caption';
            DataClassification = CustomerContent;
            InitValue = 'Amount';
        }
        field(24; lvngGLLevelSubColumn2Caption; Text[50])
        {
            Caption = 'G/L Level Sub-Column 2 Caption';
            DataClassification = CustomerContent;
            InitValue = 'Avg.';
        }
        field(25; lvngGLLevelSubColumn3Caption; Text[50])
        {
            Caption = 'G/L Level Sub-Column 3 Caption';
            DataClassification = CustomerContent;
            InitValue = 'Bps';
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