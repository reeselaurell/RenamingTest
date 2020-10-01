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
                field("Field No."; Rec."Field No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Map-To G/L Account No."; Rec."Map-To G/L Account No.") { ApplicationArea = All; }
                field("Switch Code"; Rec."Switch Code") { ApplicationArea = All; }
                field("Cost Center Option"; Rec."Cost Center Option") { ApplicationArea = All; }
                field("Cost Center"; Rec."Cost Center") { ApplicationArea = All; }
            }
        }
    }
}