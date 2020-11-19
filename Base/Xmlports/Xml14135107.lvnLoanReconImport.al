xmlport 14135107 "lvnLoanReconImport"
{
    Direction = Import;
    Format = VariableText;
    FieldSeparator = '<TAB>';

    schema
    {
        textelement(Root)
        {
            tableelement(LoanReconBuffer; lvnLoanReconciliationBuffer)
            {
                SourceTableView = sorting("Loan No.", "G/L Account No.");
                UseTemporary = true;

                fieldelement(LoanNo; LoanReconBuffer."Loan No.")
                {
                }
                fieldelement(FileAmount; LoanReconBuffer."File Amount")
                {
                }
                fieldelement(GLAccount; LoanReconBuffer."G/L Account No.")
                {
                }
            }
            tableelement(Filters; "G/L Entry")
            {
                SourceTableView = sorting("G/L Account No.", "Posting Date");
                RequestFilterFields = "G/L Account No.", "Posting Date", "Reason Code";
                UseTemporary = true;
                MinOccurs = Zero;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field(FlipSignField; FlipSign) { ApplicationArea = All; Caption = 'Flip Sign'; }
                    field(GLAccountSourceField; GLAccountSource) { ApplicationArea = All; Caption = 'G/L Account Source'; }
                }
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        LoanLevelReportSchema.Get(LoanLevelReportSchema.Code);
    end;

    var
        LoanLevelReportSchema: Record lvnLoanLevelReportSchema;
        FlipSign: Boolean;
        GLAccountSource: Option "File","Filter";

    procedure GetData(var LoanReconciliationBuffer: Record lvnLoanReconciliationBuffer)
    var
        GLEntry: Record "G/L Entry";
        FlipSign: Boolean;
    begin
        if GLAccountSource = GLAccountSource::File then begin
            LoanReconBuffer.Reset();
            LoanReconBuffer.FindSet();
            repeat
                Clear(LoanReconciliationBuffer);
                if FlipSign then begin
                    LoanReconBuffer."File Amount" := -LoanReconBuffer."File Amount";
                    LoanReconBuffer.Modify();
                end;
                LoanReconciliationBuffer.TransferFields(LoanReconBuffer);
                LoanReconciliationBuffer.Validate("Loan No.");
                LoanReconciliationBuffer.Insert();
                GLEntry.Reset();
                GLEntry.SetCurrentKey("G/L Account No.", "Reason Code", lvnLoanNo);
                GLEntry.CopyFilters(GLEntry);
                GLEntry.SetRange(lvnLoanNo, LoanReconciliationBuffer."Loan No.");
                GLEntry.SetRange("G/L Account No.", LoanReconciliationBuffer."G/L Account No.");
                LoanReconciliationBuffer."Debit Amount" := 0;
                LoanReconciliationBuffer."Credit Amount" := 0;
                LoanReconciliationBuffer.Amount := 0;
                LoanReconciliationBuffer.Difference := 0;
                LoanReconciliationBuffer.Unbalanced := false;
                if GLEntry.FindSet() then
                    repeat
                        LoanReconciliationBuffer."Credit Amount" := LoanReconciliationBuffer."Credit Amount" + GLEntry."Credit Amount";
                        LoanReconciliationBuffer."Debit Amount" := LoanReconciliationBuffer."Debit Amount" + GLEntry."Debit Amount";
                        LoanReconciliationBuffer.Amount := LoanReconciliationBuffer.Amount + GLEntry.Amount;
                    until GLEntry.Next() = 0;
                LoanReconciliationBuffer.Difference := LoanReconciliationBuffer."File Amount" - LoanReconciliationBuffer.Amount;
                if LoanReconciliationBuffer.Difference <> 0 then
                    LoanReconciliationBuffer.Unbalanced := true;
                LoanReconciliationBuffer.Modify();
            until LoanReconBuffer.Next() = 0;
        end else begin
            GLEntry.Reset();
            GLEntry.CopyFilters(GLEntry);
            LoanReconBuffer.Reset();
            LoanReconBuffer.FindSet();
            repeat
                GLEntry.SetRange(lvnLoanNo, LoanReconBuffer."Loan No.");
                if GLEntry.FindSet() then
                    repeat
                        LoanReconciliationBuffer.Reset();
                        LoanReconciliationBuffer.SetRange("Loan No.", LoanReconBuffer."Loan No.");
                        LoanReconciliationBuffer.SetRange("G/L Account No.", GLEntry."G/L Account No.");
                        if not LoanReconciliationBuffer.FindFirst() then begin
                            Clear(LoanReconciliationBuffer);
                            LoanReconciliationBuffer := LoanReconBuffer;
                            LoanReconciliationBuffer."G/L Account No." := GLEntry."G/L Account No.";
                            LoanReconciliationBuffer.Validate("Loan No.");
                            LoanReconciliationBuffer.Insert();
                        end;
                        LoanReconciliationBuffer."Credit Amount" := LoanReconciliationBuffer."Credit Amount" + GLEntry."Credit Amount";
                        LoanReconciliationBuffer."Debit Amount" := LoanReconciliationBuffer."Debit Amount" + GLEntry."Debit Amount";
                        LoanReconciliationBuffer.Amount := LoanReconciliationBuffer.Amount + GLEntry.Amount;
                        LoanReconciliationBuffer.Modify();
                    until GLEntry.Next() = 0;
            until LoanReconBuffer.Next() = 0;
        end;
    end;

    procedure GetFilters(var GLFilters: Record "G/L Entry")
    begin
        GLFilters.CopyFilters(GLFilters);
    end;
}