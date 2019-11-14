page 14135316 "lvngCommissionReportTemplates"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngCommissionReportTemplate;
    Caption = 'Commission Report Templates';

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
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
            action(lvngTemplateDetails)
            {
                Caption = 'Template Details';
                ApplicationArea = All;
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page lvngCommReportTemplateDetails;
                RunPageMode = Edit;
                RunPageLink = lvngCode = field(lvngCode);
            }
        }
    }


}