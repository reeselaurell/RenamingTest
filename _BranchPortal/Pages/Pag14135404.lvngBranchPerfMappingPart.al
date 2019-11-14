page 14135404 lvngBranchPerfMappingPart
{
    PageType = ListPart;
    SourceTable = lvngBranchPerfSchemaMapping;
    Caption = 'Branch Performance Schema Mapping';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Row Schema Code"; "Row Schema Code") { ApplicationArea = All; }
                field("Band Schema Code"; "Band Schema Code") { ApplicationArea = All; }
                field(Sequence; Sequence) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
            }
        }
    }
}