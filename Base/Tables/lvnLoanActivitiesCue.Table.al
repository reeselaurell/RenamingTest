table 14135164 "lvnLoanActivitiesCue"
{
    Caption = 'Loan Activities';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(10; "Funded Documents"; Integer)
        {
            Caption = 'Funded Documents';
            FieldClass = FlowField;
            CalcFormula = count(lvnLoanDocument where("Warehouse Line Code" = field("Warehouse Line Code Filter"), "Transaction Type" = const(Funded)));
            Editable = false;
        }
        field(11; "Sold Documents"; Integer)
        {
            Caption = 'Sold Documents';
            FieldClass = FlowField;
            CalcFormula = count(lvnLoanDocument where("Customer No." = field("Customer No. Filter"), "Transaction Type" = const(Sold)));
            Editable = false;
        }
        field(12; "Serviced Documents"; Integer)
        {
            Caption = 'Serviced Documents';
            FieldClass = FlowField;
            CalcFormula = count(lvnLoanDocument where("Transaction Type" = const(Serviced)));
            Editable = false;
        }
        field(100; "Warehouse Line Code Filter"; Code[50])
        {
            Caption = 'Warehouse Line Code Filter';
            FieldClass = FlowFilter;
            TableRelation = lvnWarehouseLine;
        }
        field(101; "Customer No. Filter"; Code[20])
        {
            Caption = 'Customer No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Customer;
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}