report 14135154 lvngOpenVendorLedgerEntries
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Open Vendor Ledger Entries';
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135154.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Vendor Posting Group";

            column(VendorNo; "No.") { }
            column(VendorName; Name) { }
            column(Balance; Balance) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(VendorPostingGroup; "Vendor Posting Group") { }

            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = field("No.");
                RequestFilterFields = "Posting Date", "Reason Code";

                column(PostingDate; "Posting Date") { }
                column(DocumentNo; "Document No.") { }
                column(ExternalDocumentNo; "External Document No.") { }
                column(Description; Description) { }
                column(LoanNo; lvngLoanNo) { }
                column(Amount; Amount) { }
                column(RemainingAmount; "Remaining Amount") { }
                column(DocumentType; "Document Type") { }
                column(ReasonCode; "Reason Code") { }

                trigger OnPreDataItem()
                begin
                    SetRange(Open, true);
                end;
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
    end;
}