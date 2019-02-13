tableextension 14135103 "lvngGLAccount" extends "G/L Account" //MyTargetTableId
{
    fields
    {
        field(14135100; lvngReportingAccountName; Text[50])
        {
            Caption = 'Reporting Account Name';
            DataClassification = CustomerContent;
        }
        field(14135101; lvngReportingAccountType; enum lvngReportingAccountType)
        {
            Caption = 'Reporting Account Type';
            DataClassification = CustomerContent;
        }
        field(14135102; lvngLoanNoMandatory; Boolean)
        {
            Caption = 'Loan No. Mandatory';
            DataClassification = CustomerContent;
        }
        field(14135103; lvngLinkedBankAccountNo; Code[20])
        {
            Caption = 'Linked Bank Account No.';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account"."No.";
        }

    }

}