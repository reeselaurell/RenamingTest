report 14135174 lvngLegalExpenses
{
    Caption = 'Legal Expenses';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135174.rdl';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = sorting("G/L Account No.", "Posting Date");
            RequestFilterFields = "G/L Account No.", "Posting Date", "Entry Date", "Source Type", "Source No.";

            column(EntryNo; "Entry No.") { }
            column(PostingDate; "Posting Date") { }
            column(DocumentType; "Document Type") { }
            column(ExtDocNo; "External Document No.") { }
            column(Description; Description) { }
            column(Amount; Amount) { }
            column(GLAccountName; "G/L Account Name") { }
            column(SourceName; "Source Name") { }
            column(DateFilter; DateFilter) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(BranchCode; BranchCode) { }

            trigger OnAfterGetRecord()
            begin
                BranchCode := '';
                if GLSetup."Shortcut Dimension 1 Code" = LoanVisionSetup."Cost Center Dimension Code" then
                    BranchCode := "Global Dimension 1 Code";
                if GLSetup."Shortcut Dimension 2 Code" = LoanVisionSetup."Cost Center Dimension Code" then
                    BranchCode := "Global Dimension 2 Code";
                if GLSetup."Shortcut Dimension 3 Code" = LoanVisionSetup."Cost Center Dimension Code" then
                    BranchCode := "Shortcut Dimension 3 Code";
                if GLSetup."Shortcut Dimension 4 Code" = LoanVisionSetup."Cost Center Dimension Code" then
                    BranchCode := "Shortcut Dimension 4 Code";
                if GLSetup."Shortcut Dimension 5 Code" = LoanVisionSetup."Cost Center Dimension Code" then
                    BranchCode := "Shortcut Dimension 5 Code";
                if GLSetup."Shortcut Dimension 6 Code" = LoanVisionSetup."Cost Center Dimension Code" then
                    BranchCode := "Shortcut Dimension 6 Code";
                if GLSetup."Shortcut Dimension 7 Code" = LoanVisionSetup."Cost Center Dimension Code" then
                    BranchCode := "Shortcut Dimension 7 Code";
                if GLSetup."Shortcut Dimension 8 Code" = LoanVisionSetup."Cost Center Dimension Code" then
                    BranchCode := "Shortcut Dimension 8 Code";
            end;
        }
    }

    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        GLSetup: Record "General Ledger Setup";
        CompanyInformation: Record "Company Information";
        DateFilter: Text;
        BranchCode: Code[20];

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        GLSetup.Get();
        LoanVisionSetup.Get();
        DateFilter := "G/L Entry".GetFilter("Posting Date");
    end;
}