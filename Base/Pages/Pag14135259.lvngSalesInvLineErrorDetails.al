page 14135259 lvngSalesInvLineErrorDetails
{
    Caption = 'Line Import Errors';
    PageType = ListPart;
    SourceTable = lvngInvoiceErrorDetail;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Error Text"; Rec."Error Text") { ApplicationArea = All; }
            }
        }
    }


    procedure SetLineErrors(var pInvoiceErrorDetails: Record lvngInvoiceErrorDetail)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        if pInvoiceErrorDetails.FindSet() then
            repeat
                Rec := pInvoiceErrorDetails;
                Rec.Insert();
            until pInvoiceErrorDetails.Next() = 0;
        if Rec.FindSet() then;
    end;
}