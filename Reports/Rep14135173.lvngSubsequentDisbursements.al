report 14135173 lvngSubsequentDisbursements
{
    Caption = 'Subsequent Disbursements';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135173.rdl';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = sorting("G/L Account No.", "Posting Date");
            RequestFilterFields = "G/L Account No.", "Posting Date", "Entry Date", "Source Type", "Source No.";

            column(Amount; Amount) { }
            column(BalAccountType; "Bal. Account Type") { }
            column(Description; Description) { }
            column(DocumentNo; "Document No.") { }
            column(DocumentType; "Document Type") { }
            column(EntryNo; "Entry No.") { }
            column(GLAccountName; "G/L Account Name") { }
            column(PostingDate; "Posting Date") { }
            column(SourceNo; "Source No.") { }
            column(EntryDate; "Entry Date") { }
            column(DateFilter; DateFilter) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(UserName; UserName) { }

            trigger OnAfterGetRecord()
            begin
                if StrPos("G/L Entry"."User ID", '\') <> 0 then
                    UserName := CopyStr("G/L Entry"."User ID", StrPos("G/L Entry"."User ID", '\') + 1)
                else
                    UserName := "G/L Entry"."User ID";
            end;
        }
    }

    var
        CompanyInformation: Record "Company Information";
        UserName: Text;
        DateFilter: Text;

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        DateFilter := "G/L Entry".GetFilter("Posting Date");
    end;
}