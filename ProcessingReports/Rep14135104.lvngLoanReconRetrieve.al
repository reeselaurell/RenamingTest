report 14135104 lvngLoanReconRetrieve
{
    Caption = 'Retrieve Loans for Reconciliation';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Loan; lvngLoan)
        {
            DataItemTableView = sorting("Date Funded");
            RequestFilterFields = "Date Funded", "Date Sold";
            RequestFilterHeading = 'Loan';

            trigger OnAfterGetRecord()
            begin
                Clear(TempLoanRecBuffer);
                TempLoanRecBuffer."Loan No." := "No.";
                TempLoanRecBuffer.Insert();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(Control1120067000; LoanLevelReportSchema.Code) { Caption = 'Loan Level Schema Code'; TableRelation = lvngLoanLevelReportSchema.Code; ApplicationArea = All; }
                }
            }
        }
    }

    var
        TempLoanRecBuffer: Record lvngLoanReconciliationBuffer temporary;
        LoanLevelReportSchema: Record lvngLoanLevelReportSchema;

    procedure GetLoans(var Loan: Record lvngLoan; var LoanLevelReportSchemaCode: Code[10])
    var
        mLoan: Record lvngLoan;
    begin
        TempLoanRecBuffer.Reset();
        TempLoanRecBuffer.FindSet();
        repeat
            Loan."No." := TempLoanRecBuffer."Loan No.";
            mLoan.Get(Loan."No.");
            Loan."Date Funded" := mLoan."Date Funded";
            Loan."Date Sold" := mLoan."Date Sold";
            Loan.Insert();
        until TempLoanRecBuffer.Next() = 0;
        LoanLevelReportSchemaCode := LoanLevelReportSchema.Code;
    end;
}