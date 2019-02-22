page 14135152 "lvngServicingInvoice"
{
    Caption = 'Servicing Invoice';
    PageType = Document;
    SourceTable = lvngServiceHeader;

    layout
    {
        area(Content)
        {
            group(lvngGeneral)
            {
                Caption = 'General';
                field(lvngNo; lvngNo)
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerCustomerNo; lvngBorrowerCustomerNo)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }
                field(lvngPostingDate; lvngPostingDate)
                {
                    ApplicationArea = All;
                }
                field(lvngDueDate; lvngDueDate)
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; lvngReasonCode)
                {
                    ApplicationArea = All;
                }
                group(lvngDimensions)
                {
                    Caption = 'Dimensions';

                    field(lvngGlobalDimension1Code; lvngGlobalDimension1Code)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngGlobalDimension2Code; lvngGlobalDimension2Code)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension3Code; lvngShortcutDimension3Code)
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension4Code; lvngShortcutDimension4Code)
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension5Code; lvngShortcutDimension5Code)
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension6Code; lvngShortcutDimension6Code)
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension7Code; lvngShortcutDimension7Code)
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension8Code; lvngShortcutDimension8Code)
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(lvngBusinessUnitCode; lvngBusinessUnitCode)
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                }
            }

            part(lvngServicingInvoiceSubform; lvngServicingInvoiceSubform)
            {
                Caption = 'Lines';
                SubPageLink = lvngServicingDocumentType = field (lvngServicingDocumentType), lvngDocumentNo = field (lvngNo);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngPost)
            {
                Caption = 'Post';
                Image = Post;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Message('a');
                end;
            }
        }
    }
}