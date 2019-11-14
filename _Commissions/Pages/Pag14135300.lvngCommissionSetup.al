page 14135300 "lvngCommissionSetup"
{

    PageType = Card;
    SourceTable = lvngCommissionSetup;
    Caption = 'Commission Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            group(General)
            {
                field(lvngUsePeriodIdentifiers; lvngUsePeriodIdentifiers)
                {
                    ApplicationArea = All;
                }
                field(lvngCommissionIdentifierCode; lvngCommissionIdentifierCode)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}
