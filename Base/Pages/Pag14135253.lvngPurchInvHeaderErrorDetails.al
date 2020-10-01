page 14135253 lvngPurchInvHeaderErrorDetails
{
    Caption = 'Header Import Errors';
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
}