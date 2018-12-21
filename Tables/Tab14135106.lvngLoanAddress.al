table 14135106 "lvngLoanAddress"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Address';

    fields
    {
        field(1; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoan;
        }
        field(2; lvngAddressType; Enum lvngAddressType)
        {
            Caption = 'Address Type';
            DataClassification = CustomerContent;
        }
        field(10; lvngAddress; Text[50])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(11; lvngAddress2; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(12; lvngCity; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;

        }
        field(13; lvngState; Text[30])
        {
            Caption = 'State';
            DataClassification = CustomerContent;
        }

        field(14; lvngZIPCode; Code[20])
        {
            Caption = 'ZIP Code';
            DataClassification = CustomerContent;
        }



    }

    keys
    {
        key(PK; lvngLoanNo, lvngAddressType)
        {
            Clustered = true;
        }
    }

}