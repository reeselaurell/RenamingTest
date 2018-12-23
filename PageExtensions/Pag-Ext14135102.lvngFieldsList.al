pageextension 14135102 "lvngFieldsList" extends "Field List" //MyTargetPageId
{
    layout
    {
        addbefore(FieldName)
        {
            field(lvngFieldNo; "No.")
            {
                Caption = 'Field No.';
                ApplicationArea = All;
            }
        }
        addafter(FieldName)
        {
            field(lvngFieldCaption; "Field Caption")
            {
                Caption = 'Field Caption';
                ApplicationArea = All;
            }
        }
        
    }
}