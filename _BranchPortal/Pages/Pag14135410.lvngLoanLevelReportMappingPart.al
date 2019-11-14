page 14135410 lvngLoanLevelReportMappingPart
{
    PageType = ListPart;
    Caption = 'Loan Funding Schema Mapping';
    SourceTable = lvngLoanLevelSchemaMapping;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Schema Code"; "Schema Code") { ApplicationArea = All; }
                field(Sequence; Sequence) { ApplicationArea = All; }
                field("Base Date"; "Base Date") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
            }
        }
    }
}