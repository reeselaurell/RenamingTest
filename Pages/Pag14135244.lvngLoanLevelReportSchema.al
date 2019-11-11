page 14135244 lvngLoanLevelReportSchema
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngLoanLevelReportSchema;
    Caption = 'Loan Funding Schema List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Skip Zero Balance Lines"; "Skip Zero Balance Lines") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SchemaDetails)
            {
                ApplicationArea = All;
                Caption = 'Schema Details';
                Image = SetupColumns;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;
                RunObject = page lvngLoanLevelReportSchemaLines;
                RunPageView = sorting("Report Code", "Column No.");
                RunPageLink = "Report Code" = field(Code);
            }
        }
    }
}