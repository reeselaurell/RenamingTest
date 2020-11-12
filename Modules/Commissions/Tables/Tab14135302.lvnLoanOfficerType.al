table 14135302 lvnLoanOfficerType
{
    DataClassification = CustomerContent;
    Caption = 'Loan Officer Type';
    LookupPageId = lvnLoanOfficerTypes;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(11; "Collect Loans"; Boolean)
        {
            Caption = 'Collect Loans';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Name) { }
    }
}