page 14135259 "lvnSalesInvLineErrorDetails"
{
    Caption = 'Line Import Errors';
    PageType = ListPart;
    SourceTable = lvnInvoiceErrorDetail;
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


    procedure SetLineErrors(var pInvoiceErrorDetails: Record lvnInvoiceErrorDetail)
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