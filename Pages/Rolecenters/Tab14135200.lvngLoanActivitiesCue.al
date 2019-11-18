table 14135200 "lvngLoanActivitiesCue"
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

        field(10; lvngFundedDocuments; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count (lvngLoanDocument where("Warehouse Line Code" = field(lvngWarehouseLineCodeFilter), "Transaction Type" = const(Funded)));
            Editable = false;
        }
        field(11; lvngSoldDocuments; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count (lvngLoanDocument where("Customer No." = field(lvngCustomerNoFilter), "Transaction Type" = const(Sold)));
            Editable = false;
        }
        field(12; lvngServicedDocuments; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count (lvngLoanDocument where("Transaction Type" = const(Serviced)));
            Editable = false;
        }
        field(100; lvngWarehouseLineCodeFilter; Code[50])
        {
            Caption = 'Warehouse Line Code Filter';
            FieldClass = FlowFilter;
            TableRelation = lvngWarehouseLine;
        }
        field(101; lvngCustomerNoFilter; Code[20])
        {
            Caption = 'Customer No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Customer;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}