page 14135156 lvngEscrowFieldsMapping
{
    Caption = 'Escrow Fields Mapping';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngEscrowFieldsMapping;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Field No."; "Field No.") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Map-To G/L Account No."; "Map-To G/L Account No.") { ApplicationArea = All; }
                field("Switch Code"; "Switch Code") { ApplicationArea = All; }
Servic                field("Cost Center Option"; "Cost Center Option") { ApplicationArea = All; }
                field("Cost Center"; "Cost Center") { ApplicationArea = All; }
            }
        }
    }
}