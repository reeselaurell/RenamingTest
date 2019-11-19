report 14135173 "lvngSubsequentDisbursements"
{
    Caption = 'Subsequent Disbursements';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135173.rdl';
    dataset
    {
        dataitem(lvngGLEntry; "G/L Entry")
        {
            DataItemTableView = sorting("G/L Account No.", "Posting Date");
            RequestFilterFields = "G/L Account No.", "Posting Date", "Entry Date", "Source Type", "Source No.";
            column(Amount; Amount)
            {

            }
            column(BalAccountType; "Bal. Account Type")
            {

            }
            column(Description; Description)
            {

            }
            column(DocumentNo; "Document No.")
            {

            }
            column(DocumentType; "Document Type")
            {

            }
            column(EntryNo; "Entry No.")
            {

            }
            column(GLAccountName; "G/L Account Name")
            {

            }
            column(PostingDate; "Posting Date")
            {

            }
            column(SourceNo; "Source No.")
            {

            }
            column(EntryDate; "Entry Date")
            {

            }
            column(DateFilter; DateFilter)
            {

            }
            column(CompanyName; CompanyInformation.Name)
            {

            }
            column(UserName; UserName)
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

    Trigger OnPreReport()
    begin
        CompanyInformation.Get();
        DateFilter := lvngGLEntry.GetFilter("Posting Date");
    end;
}