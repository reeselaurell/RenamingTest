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
                field(lvngNo; "No.")
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerCustomerNo; "Borrower Customer No.")
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(lvngPostingDate; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field(lvngDueDate; "Due Date")
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; "Reason Code")
                {
                    ApplicationArea = All;
                }
                group(lvngDimensions)
                {
                    Caption = 'Dimensions';

                    field(lvngGlobalDimension1Code; "Global Dimension 1 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible1;
                    }
                    field(lvngGlobalDimension2Code; "Global Dimension 2 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible2;
                    }
                    field(lvngShortcutDimension3Code; "Shortcut Dimension 3 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible3;
                    }
                    field(lvngShortcutDimension4Code; "Shortcut Dimension 4 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible4;
                    }
                    field(lvngShortcutDimension5Code; "Shortcut Dimension 5 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible5;
                    }
                    field(lvngShortcutDimension6Code; "Shortcut Dimension 6 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible6;
                    }
                    field(lvngShortcutDimension7Code; "Shortcut Dimension 7 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible7;
                    }
                    field(lvngShortcutDimension8Code; "Shortcut Dimension 8 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible8;
                    }
                    field(lvngBusinessUnitCode; "Business Unit Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                }
            }

            part(lvngServicingInvoiceSubform; lvngServicingInvoiceSubform)
            {
                Caption = 'Lines';
                SubPageLink = "Servicing Document Type" = field("Servicing Document Type"), "Document No." = field("No.");
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

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

    var
        DimensionManagement: Codeunit DimensionManagement;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;
}