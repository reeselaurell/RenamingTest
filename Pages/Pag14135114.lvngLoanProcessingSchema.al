page 14135114 "lvngLoanProcessingSchema"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoanProcessingSchema;
    Caption = 'Processing Schemas';

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
                field(lvngNoSeries; lvngNoSeries)
                {
                    ApplicationArea = All;
                }

                field(lvngGlobalSchema; lvngGlobalSchema)
                {
                    ApplicationArea = All;
                }
                field(lvngUseGlobalSchemaCode; lvngUseGlobalSchemaCode)
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
            action(lvngProcessingLines)
            {
                ApplicationArea = All;
                Caption = 'Processing Schema Lines';
                Image = LineDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page lvngLoanProcessingSchemaLines;
                RunPageLink = lvngProcessingCode = field (lvngCode);
            }
        }
    }
}