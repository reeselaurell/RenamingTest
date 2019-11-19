report 14135175 "lvngEquityTransaction"
{
    Caption = 'Equity Transactions';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135175.rdl';

    dataset
    {
        dataitem(lvngGLEntry; "G/L Entry")
        {
            DataItemTableView = sorting("G/L Account No.", "Posting Date");
            RequestFilterFields = "G/L Account No.", "Posting Date", "Entry Date", "Source Type", "Source No.";
            column(EntryNo; "Entry No.")
            {

            }
            column(PostingDate; "Posting Date")
            {

            }
            column(GLAccountNo; "G/L Account No.")
            {

            }
            column(DocumentNo; "Document No.")
            {

            }
            column(Description; Description)
            {

            }
            column(Amount; Amount)
            {

            }
            column(GLAccountName; "G/L Account Name")
            {

            }
            column(DateFilter; DateFilter)
            {

            }
            column(CompnayName; CompanyInformation.Name)
            {

            }
            column(ExtDocumentNo; "External Document No.")
            {

            }
            column(BalAccountNo; "Bal. Account No.")
            {

            }
            trigger OnAfterGetRecord()
            begin
                if StrPos(lvngGLEntry."User ID", '\') <> 0 then
                    UserName := CopyStr(lvngGLEntry."User ID", StrPos(lvngGLEntry."User ID", '\') + 1)
                else
                    UserName := lvngGLEntry."User ID";
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

    }

    var
        CompanyInformation: Record "Company Information";
        UserName: Text;
        DateFilter: Text;

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        DateFilter := lvngGLEntry.GetFilter("Posting Date");
    end;


}