page 14135157 "lvngEscrowFieldsMapping"
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
            repeater(lvngRepeater)
            {
                field(lvngFieldNo; "Field No.")
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; Description)
                {
                    ApplicationArea = All;
                }
                field(lvngMapToGLAccountNo; "Map-To G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field(lvngSwitchCode; "Switch Code")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}