table 14135105 lvngLoanJournalBatch
{
    DataClassification = CustomerContent;
    Caption = 'Loan Journal Batch';
    LookupPageId = lvngLoanJournalBatches;

    fields
    {
        field(1; Code; Code[10]) { Caption = 'Code'; DataClassification = CustomerContent; NotBlank = true; }
        field(10; Description; Text[250]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Loan Journal Type"; enum lvngLoanJournalBatchType) { Caption = 'Journal Type'; DataClassification = CustomerContent; }
        field(12; "Default Reason Code"; Code[10]) { Caption = 'Default Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(13; "Def. Processing Schema Code"; Code[20]) { Caption = 'Default Processing Schema Code'; DataClassification = CustomerContent; TableRelation = lvngLoanProcessingSchema; }
        field(14; "Dimension Import Rule"; enum lvngDimensionImportRule) { Caption = 'Dimension Import Rule'; DataClassification = CustomerContent; }
        field(15; "Map Dimensions Using Hierachy"; Boolean) { Caption = 'Map Dimensions Using Hierachy'; DataClassification = CustomerContent; }
        field(16; "Dimension Hierarchy Date"; enum lvngLoanDateType) { Caption = 'Dimension Mapping Hierarchy Date'; DataClassification = CustomerContent; }
        field(17; "Default Title Customer No."; Code[20]) { Caption = 'Default Title Customer No.'; DataClassification = CustomerContent; TableRelation = Customer."No."; }
        field(18; "Default Investor Customer No."; Code[20]) { Caption = 'Default Investor Customer No.'; DataClassification = CustomerContent; TableRelation = Customer."No."; }
        field(50; "Loan Card Update Option"; Enum lvngLoanCardUpdateOption) { Caption = 'Loan Card Update Option'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

}

