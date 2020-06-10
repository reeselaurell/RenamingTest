page 14135254 lvngPurchInvLineErrorDetails
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
                field("Error Text"; "Error Text") { ApplicationArea = All; }
            }
        }
    }
}