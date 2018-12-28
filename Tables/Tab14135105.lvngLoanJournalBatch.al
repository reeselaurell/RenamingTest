table 14135105 lvngLoanJournalBatch
{
    DataClassification = CustomerContent;
    Caption = 'Loan Journal Batch';
    LookupPageId = lvngLoanJournalBatches;

    fields
    {
        field(1; lvngCode; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(10; lvngDescription; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(11; lvngLoanJournalType; enum lvngLoanJournalBatchType)
        {
            Caption = 'Journal Type';
            DataClassification = CustomerContent;
        }

        field(12; lvngDefaultReasonCode; Code[10])
        {
            Caption = 'Default Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }

        field(13; lvngDefProcessingSchemaCode; Code[20])
        {
            Caption = 'Default Processing Schema Code';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanProcessingSchema;
        }
        field(14; lvngDimensionImportRule; enum lvngDimensionImportRule)
        {
            Caption = 'Dimension Import Rule';
            DataClassification = CustomerContent;
        }
        field(15; lvngMapDimensionsUsingHierachy; Boolean)
        {
            Caption = 'Map Dimensions Using Hierarchy';
            DataClassification = CustomerContent;
        }
        field(16; lvngDimensionHierarchyDate; enum lvngLoanDateType)
        {
            Caption = 'Dimension Mapping Hierarchy Date';
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

