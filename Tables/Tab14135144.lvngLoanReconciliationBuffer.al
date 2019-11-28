table 14135144 lvngLoanReconciliationBuffer
{
    Caption = 'Loan Reconciliation Buffer';
    DataClassification = CustomerContent;


    fields
    {
        field(1; "Loan No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = lvngLoan."No.";

            trigger OnValidate()
            var
                Loan: Record lvngLoan;
            begin
                Loan.Get("Loan No.");
                Rec.TransferFields(Loan, false);
            end;
        }
        field(5; "G/L Account No."; Code[20]) { Caption = 'G/L Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"; }
        field(20; "Application Date"; Date) { Caption = 'Application Date'; DataClassification = CustomerContent; }
        field(21; "Date Closed"; Date) { Caption = 'Date Closed'; DataClassification = CustomerContent; }
        field(22; "Date Funded"; Date) { Caption = 'Date Funded'; DataClassification = CustomerContent; }
        field(23; "Date Sold"; Date) { Caption = 'Date Sold'; DataClassification = CustomerContent; }
        field(25; "Loan Amount"; Decimal) { Caption = 'Loan Amount'; DataClassification = CustomerContent; }
        field(27; "Warehouse Line Code"; Code[50]) { Caption = 'Warehouse Line Code'; DataClassification = CustomerContent; }
        field(50000; "BankAccount No."; Code[20]) { Caption = 'Bank Account No.'; DataClassification = CustomerContent; TableRelation = "Bank Account"; }
        field(50001; "Borrower Name"; Text[50]) { Caption = 'Borrower Name'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Loan No.", "G/L Account No.") { Clustered = true; }
    }
}