table 14135121 "lvngLoanFundedDocument"
{
    Caption = 'Loan Funded Document';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngDocumentNo; code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(10; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoan;
        }
        field(11; lvngCustomerNo; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(12; lvngVoid; Boolean)
        {
            Caption = 'Void';
            DataClassification = CustomerContent;
        }
        field(10000; lvngBorrowerSearchName; Code[50])
        {
            Caption = 'Borrower Search Name';
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan.lvngSearchName where (lvngLoanNo = field (lvngLoanNo)));
            Editable = false;
        }


    }

    keys
    {
        key(PK; lvngDocumentNo)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}