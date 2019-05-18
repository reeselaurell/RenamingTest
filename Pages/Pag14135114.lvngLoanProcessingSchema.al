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
                field(lvngDocumentTypeOption; lvngDocumentTypeOption)
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
                field(lvngDimension1Rule; lvngDimension1Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngDimension2Rule; lvngDimension2Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDimension3Rule; lvngDimension3Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension4Rule; lvngDimension4Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension5Rule; lvngDimension5Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension6Rule; lvngDimension6Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension7Rule; lvngDimension7Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension8Rule; lvngDimension8Rule)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngBusinessUnitRule; lvngBusinessUnitRule)
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension1Code; lvngGlobalDimension1Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngGlobalDimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngShortcutDimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngShortcutDimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngShortcutDimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngShortcutDimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngShortcutDimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngShortcutDimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngBusinessUnitCode; lvngBusinessUnitCode)
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

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

    var
        DimensionManagement: Codeunit DimensionManagement;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;
}