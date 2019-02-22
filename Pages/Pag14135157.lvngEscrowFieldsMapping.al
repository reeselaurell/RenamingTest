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
                field(lvngFieldNo; lvngFieldNo)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngMapToGLAccountNo; lvngMapToGLAccountNo)
                {
                    ApplicationArea = All;
                }
                field(lvngSwitchCode; lvngSwitchCode)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}