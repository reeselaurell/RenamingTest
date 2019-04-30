table 14135132 "lvngServicingWorksheet"
{
    Caption = 'Servicing Worksheet';
    DataClassification = CustomerContent;


    fields
    {
        field(1; lvngLoanNo; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
            TableRelation = lvngLoan;

            trigger OnValidate()
            begin
                CalculateAmounts();
            end;
        }

        field(10; lvngCustomerNo; Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan.lvngBorrowerCustomerNo where (lvngLoanNo = field (lvngLoanNo)));

        }
        field(11; lvngDateFunded; Date)
        {
            Caption = 'Date Funded';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan.lvngDateFunded where (lvngLoanNo = field (lvngLoanNo)));
        }
        field(12; lvngDateSold; Date)
        {
            Caption = 'Date Sold';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan.lvngDateSold where (lvngLoanNo = field (lvngLoanNo)));
        }
        field(13; lvngFirstPaymentDue; Date)
        {
            Caption = 'First Payment Due';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan.lvngFirstPaymentDue where (lvngLoanNo = field (lvngLoanNo)));
        }
        field(14; lvngFirstPaymentDueToInvestor; Date)
        {
            Caption = 'First Payment Due to Investor';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan.lvngFirstPaymentDueToInvestor where (lvngLoanNo = field (lvngLoanNo)));
        }
        field(15; lvngNextPaymentDate; Date)
        {
            Caption = 'Next Payment Date';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan.lvngNextPaymentDate where (lvngLoanNo = field (lvngLoanNo)));
        }
        field(16; lvngBorrowerName; Text[100])
        {
            Caption = 'Borrower Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan.lvngSearchName where (lvngLoanNo = field (lvngLoanNo)));
        }
        field(20; lvngInterestAmount; Decimal)
        {
            Caption = 'Interest Amount';
            DataClassification = CustomerContent;
        }
        field(21; lvngPrincipalAmount; Decimal)
        {
            Caption = 'Principal Amount';
            DataClassification = CustomerContent;
        }
        field(22; lvngEscrowAmount; Decimal)
        {
            Caption = 'Escrow Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngLoanNo)
        {
            Clustered = true;
        }
    }

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

    local procedure CalculateAmounts()
    var
        lvngLoan: Record lvngLoan;
        lvngServicingManagement: Codeunit lvngServicingManagement;

    begin
        lvngLoan.Get(lvngLoanNo);
        lvngServicingManagement.lvngGetPrincipalAndInterest(lvngLoan, lvngLoan.lvngNextPaymentDate, lvngPrincipalAmount, lvngInterestAmount);
        lvngEscrowAmount := lvngServicingManagement.lvngGetTotalEscrowAmounts(lvngLoan);

    end;

}