table 14135132 "lvnServicingWorksheet"
{
    Caption = 'Servicing Worksheet';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
            TableRelation = lvnLoan;

            trigger OnValidate()
            begin
                CalculateAmounts();
                ServicingManagement.ValidateServicingLine(Rec);
            end;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnLoan."Borrower Customer No." where("No." = field("Loan No.")));
        }
        field(11; "Date Funded"; Date)
        {
            Caption = 'Date Funded';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnLoan."Date Funded" where("No." = field("Loan No.")));
        }
        field(12; "Date Sold"; Date)
        {
            Caption = 'Date Sold';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnLoan."Date Sold" where("No." = field("Loan No.")));
        }
        field(13; "First Payment Due"; Date)
        {
            Caption = 'First Payment Due';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnLoan."First Payment Due" where("No." = field("Loan No.")));
        }
        field(14; "First Payment Due To Investor"; Date)
        {
            Caption = 'First Payment Due to Investor';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnLoan."First Payment Due To Investor" where("No." = field("Loan No.")));
        }
        field(15; "Next Payment Date"; Date)
        {
            Caption = 'Next Payment Date';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnLoan."Next Payment Date" where("No." = field("Loan No.")));
        }
        field(16; "Borrower Name"; Text[100])
        {
            Caption = 'Borrower Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnLoan."Search Name" where("No." = field("Loan No.")));
        }
        field(20; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
            DataClassification = CustomerContent;
        }
        field(21; "Principal Amount"; Decimal)
        {
            Caption = 'Principal Amount';
            DataClassification = CustomerContent;
        }
        field(22; "Escrow Amount"; Decimal)
        {
            Caption = 'Escrow Amount';
            DataClassification = CustomerContent;
        }
        field(30; "Last Servicing Period"; Boolean)
        {
            Caption = 'Last Servicing Period';
            DataClassification = CustomerContent;
        }
        field(31; "Payable to Investor"; Boolean)
        {
            Caption = 'Payable to Investor';
            DataClassification = CustomerContent;
        }
        field(100; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Loan No.") { Clustered = true; }
    }

    var
        LoanServicingSetup: Record lvnLoanServicingSetup;
        ServicingManagement: Codeunit lvnServicingManagement;
        LoanServicingSetupRetrieved: Boolean;

    procedure CalculateAmounts()
    var
        Loan: Record lvnLoan;
    begin
        Loan.Get("Loan No.");
        ServicingManagement.GetPrincipalAndInterest(Loan, Loan."Next Payment Date", "Principal Amount", "Interest Amount");
        "Escrow Amount" := ServicingManagement.GetTotalEscrowAmounts(Loan);
    end;

    // local procedure GetLoanServicingSetup()
    // begin
    //     if not LoanServicingSetupRetrieved then begin
    //         LoanServicingSetupRetrieved := true;
    //         LoanServicingSetup.Get();
    //     end;
    // end;
}