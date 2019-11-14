table 14135302 "lvngLoanOfficerType"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Officer Type';
    LookupPageId = lvngLoanOfficerTypes;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(10; lvngName; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;

        }
        field(11; lvngCollectLoans; Boolean)
        {
            Caption = 'Collect Loans';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; lvngCode, lvngName) { }
    }

}