report 14135175 lvngEquityTransaction
{
    Caption = 'Equity Transactions';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135175.rdl';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = sorting("G/L Account No.", "Posting Date");
            RequestFilterFields = "G/L Account No.", "Posting Date", lvngEntryDate, "Source Type", "Source No.";

            column(CompanyName; CompanyInformation.Name) { }
            column(EntryNo; "Entry No.") { }
            column(PostingDate; "Posting Date") { }
            column(GLAccountNo; "G/L Account No.") { }
            column(DocumentNo; "Document No.") { }
            column(Description; Description) { }
            column(Amount; Amount) { }
            column(GLAccountName; "G/L Account Name") { }
            column(DateFilter; DateFilter) { }
            column(CompnayName; CompanyInformation.Name) { }
            column(ExtDocumentNo; "External Document No.") { }
            column(BalAccountNo; "Bal. Account No.") { }

            trigger OnAfterGetRecord()
            var
                Idx: Integer;
            begin
                Idx := StrPos("G/L Entry"."User ID", '\');
                if Idx <> 0 then
                    UserName := CopyStr("G/L Entry"."User ID", Idx + 1)
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