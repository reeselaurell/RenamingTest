page 14135258 lvngSalesInvHeaderErrorDetails
{
    Caption = 'Header Import Errors';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngInvoiceErrorDetail;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Error Text"; "Error Text") { ApplicationArea = All; }
            }
        }
    }
}