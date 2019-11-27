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
            begin
                Loan.Get("Loan No.");
                Rec.TransferFields(Loan, false);
            end;
        }
        field(11; "G/L Account No."; Code[20]) { Caption = 'G/L Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"; }
        field(12; lvngDateClosed; Date) { Caption = 'Date Closed'; DataClassification = CustomerContent; }
        field(13; lvngApplicationDate; Date) { Caption = 'Application Date'; DataClassification = CustomerContent; }
        field(14; lvngBankAccountNo; Code[20]) { Caption = 'Bank Account No.'; DataClassification = CustomerContent; TableRelation = "Bank Account"; }
        field(15; lvngDateFunded; Date) { Caption = 'Date Funded'; DataClassification = CustomerContent; }
        field(16; lnvgDateSold; Date) { Caption = 'Date Sold'; DataClassification = CustomerContent; }
        field(21; lvngBorrowerName; Text[50]) { Caption = 'Borrower Name'; DataClassification = CustomerContent; }
        field(22; lvngWarehouseLineCode; Code[50]) { Caption = 'Warehouse Line Code'; DataClassification = CustomerContent; }
        field(25; lvngLoanAmount; Decimal) { Caption = 'Loan Amount'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Loan No.", "G/L Account No.") { Clustered = true; }
    }

    var
        Loan: Record lvngLoan;
}