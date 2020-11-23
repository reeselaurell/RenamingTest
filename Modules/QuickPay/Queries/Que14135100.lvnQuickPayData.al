query 14135100 "lvnQuickPayData"
{
    Caption = 'Quick Pay Data';
    OrderBy = ascending(VendorNo);

    elements
    {
        dataitem(Vendor_Ledger_Entry; "Vendor Ledger Entry")
        {
            DataItemTableFilter = Open = const(true), "Document Type" = const(Invoice);

            filter(DueDateFilter; "Due Date")
            {
            }
            filter(VendorNoFilter; "Vendor No.")
            {
            }
            filter(PaymentMethodFilter; "Payment Method Code")
            {
            }
            filter(VendorPostingGroupFilter; "Vendor Posting Group")
            {
            }
            filter(Dim1Filter; "Global Dimension 1 Code")
            {
            }
            filter(Dim2Filter; "Global Dimension 2 Code")
            {
            }
            filter(ReasonCodeFilter; "Reason Code")
            {
            }
            filter(UserIDFilter; "User ID")
            {
            }
            filter(EntryDateFilter; lvnEntryDate)
            {
            }
            filter(PostingDateFilter; "Posting Date")
            {
            }
            column(DueDate; "Due Date")
            {
            }
            column(VendorNo; "Vendor No.")
            {
            }
            column(RemainingAmount; "Remaining Amount")
            {
                ReverseSign = true;
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(VendorPostingGroup; "Vendor Posting Group")
            {
            }
            column(PaymentMethodCode; "Payment Method Code")
            {
            }
            column(DocumentGUID; lvnDocumentGuid)
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(Description; Description)
            {
            }
            column(DimensionSetID; "Dimension Set ID")
            {
            }
            column(LoanNo; lvnLoanNo)
            {
            }
            column(AppliesToID; "Applies-to ID")
            {
            }
        }
    }
}