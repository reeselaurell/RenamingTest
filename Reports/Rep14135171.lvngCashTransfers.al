report 14135171 lvngCashTransfers
{
    Caption = 'Cash Transfers';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135171.rdl';

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = sorting("Bank Account No.", "Posting Date") where(Positive = const(true), "Bal. Account Type" = const("Bank Account"));

            column(PostingDate; "Posting Date") { }
            column(FromBankAccountName; FromBankAccountName) { }
            column(FromBankAccountNo; FromBankAccountNo) { }
            column(Description; Description) { }
            column(ToBankAccountName; ToBankAccountName) { }
            column(ToBankAccountNo; ToBankAccountNo) { }
            column(Amount; Amount) { }
            column(DateFilter; GetFilter("Posting Date")) { }
            column(CompanyName; CompanyInformation.Name) { }

            trigger OnAfterGetRecord()
            begin
                FromBankAccountName := '';
                FromBankAccountNo := '';
                ToBankAccountName := '';
                ToBankAccountNo := '';
                BankAccount.Get("Bank Account No.");
                FromBankAccountName := BankAccount.Name;
                FromBankAccountNo := '*****' + CopyStr(BankAccount."Bank Account No.", StrLen(BankAccount."Bank Account No.") - 3);
                BankAccount.Get("Bank Account Ledger Entry"."Bal. Account No.");
                ToBankAccountName := BankAccount.Name;
                ToBankAccountNo := '*****' + CopyStr(BankAccount."Bank Account No.", StrLen(BankAccount."Bank Account No.") - 3);
            end;
        }
    }

    var
        CompanyInformation: Record "Company Information";
        BankAccount: Record "Bank Account";
        FromBankAccountName: Text;
        FromBankAccountNo: Text;
        ToBankAccountName: Text;
        ToBankAccountNo: Text;

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
    end;
}