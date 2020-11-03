page 14135223 "lvnLoanLevelReportSchema"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnLoanLevelReportSchema;
    Caption = 'Loan Funding Schema List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Skip Zero Balance Lines"; Rec."Skip Zero Balance Lines") { ApplicationArea = All; }
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
                RunObject = page lvnLoanLevelReportSchemaLines;
                RunPageView = sorting("Report Code", "Column No.");
                RunPageLink = "Report Code" = field(Code);
            }
        }
    }
}