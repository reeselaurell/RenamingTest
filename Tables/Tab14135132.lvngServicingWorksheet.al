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
                lvngServicingManagement.ValidateServicingLine(Rec);
            end;
        }

        field(10; lvngCustomerNo; Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan."Borrower Customer No" where("No." = field(lvngLoanNo)));

        }
        field(11; lvngDateFunded; Date)
        {
            Caption = 'Date Funded';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan."Date Funded" where("No." = field(lvngLoanNo)));
        }
        field(12; lvngDateSold; Date)
        {
            Caption = 'Date Sold';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan."Date Sold" where("No." = field(lvngLoanNo)));
        }
        field(13; lvngFirstPaymentDue; Date)
        {
            Caption = 'First Payment Due';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan."First Payment Due" where("No." = field(lvngLoanNo)));
        }
        field(14; lvngFirstPaymentDueToInvestor; Date)
        {
            Caption = 'First Payment Due to Investor';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan."First Payment Due To Investor" where("No." = field(lvngLoanNo)));
        }
        field(15; lvngNextPaymentDate; Date)
        {
            Caption = 'Next Payment Date';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan."Next Payment Date" where("No." = field(lvngLoanNo)));
        }
        field(16; lvngBorrowerName; Text[100])
        {
            Caption = 'Borrower Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan."Search Name" where("No." = field(lvngLoanNo)));
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

        field(100; lvngErrorMessage; Text[250])
        {
            Caption = 'Error Message';
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

    procedure CalculateAmounts()
    var
        lvngLoan: Record lvngLoan;
    begin
        lvngLoan.Get(lvngLoanNo);
        lvngServicingManagement.GetPrincipalAndInterest(lvngLoan, lvngLoan."Next Payment Date", lvngPrincipalAmount, lvngInterestAmount);
        lvngEscrowAmount := lvngServicingManagement.GetTotalEscrowAmounts(lvngLoan);
    end;

    local procedure GetLoanServicingSetup()
    begin
        if not lvngLoanServicingSetupRetrieved then begin
            lvngLoanServicingSetupRetrieved := true;
            lvngLoanServicingSetup.Get();
        end;
    end;

    var
        lvngLoanServicingSetup: Record lvngLoanServicingSetup;
        lvngServicingManagement: Codeunit lvngServicingManagement;
        lvngLoanServicingSetupRetrieved: Boolean;

}