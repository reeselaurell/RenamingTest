page 14135258 "lvnSalesInvHeaderErrorDetails"
{
    Caption = 'Header Import Errors';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnInvoiceErrorDetail;
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

    procedure SetHeaderErrors(var pInvoiceErrorDetails: Record lvnInvoiceErrorDetail)
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