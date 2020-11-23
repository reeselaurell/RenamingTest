page 14135316 "lvnCommissionReportTemplates"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnCommissionReportTemplate;
    Caption = 'Commission Report Templates';

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TemplateDetails)
            {
                Caption = 'Template Details';
                ApplicationArea = All;
                Image = ViewDetails;
                RunObject = page lvnCommReportTemplateDetails;
                RunPageMode = Edit;
                RunPageLink = "Template Code" = field(Code);
            }
        }
    }
}