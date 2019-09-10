page 14135420 lvngBranchPerfSchemaMapping
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
                field("Schema Code"; "Schema Code") { ApplicationArea = All; }
                field("Layout Code"; "Layout Code") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Sequence; Sequence) { ApplicationArea = All; }
            }
        }
    }
}