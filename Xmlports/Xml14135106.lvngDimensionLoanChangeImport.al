xmlport 14135106 lvngDimensionLoanChangeImport
{
    Caption = 'Dimension Loan Change Import';
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(LoanBuffer; lvngLoanReportingBuffer)
            {
                UseTemporary = true;

                fieldelement(LoanNo; LoanBuffer."Loan No.") { }
            }
        }
    }

    var
        ProgressLbl: Label '#1############## of #2###########';
        ChangeSetId: Guid;

    trigger OnPostXmlPort()
    var
        DimensionChangeJnlEntry: Record lvngDimensionChangeJnlEntry;
        GLEntry: Record "G/L Entry";
        Progress: Dialog;
        Index: Integer;
    begin
        LoanBuffer.Reset();
        LoanBuffer.FindSet();
        Progress.Open(ProgressLbl);
        Progress.Update(2, LoanBuffer.Count);
        repeat
            Index += 1;
            Progress.Update(1, Index);
            GLEntry.Reset();
            GLEntry.SetRange(lvngLoanNo, LoanBuffer."Loan No.");
            if GLEntry.FindSet() then begin
                repeat
                    Clear(DimensionChangeJnlEntry);
                    DimensionChangeJnlEntry."Change Set ID" := ChangeSetId;
                    DimensionChangeJnlEntry.TransferValuesFromRecord(GLEntry);
                    if DimensionChangeJnlEntry.Insert() then;
                until GLEntry.Next() = 0;
            end;
        until LoanBuffer.Next() = 0;
        Progress.Close();
    end;

    procedure SetParams(pChangeSetID: Guid)
    begin
        ChangeSetId := pChangeSetID;
    end;
}