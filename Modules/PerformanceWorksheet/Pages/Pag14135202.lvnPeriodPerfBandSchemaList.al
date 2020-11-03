page 14135202 "lvnPeriodPerfBandSchemaList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnPeriodPerfBandSchema;
    Caption = 'Period Performance Band Schema List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SchemaLines)
            {
                ApplicationArea = All;
                Caption = 'Schema Lines';
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page lvnPeriodPerfBandSchemaLines;
                RunPageLink = "Schema Code" = field(Code);
            }
        }
    }
}