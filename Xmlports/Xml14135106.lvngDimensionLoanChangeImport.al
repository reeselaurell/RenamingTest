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
        ChangeSetId: Guid;

    trigger OnPostXmlPort()
    var
        DimensionChangeJnlEntry: Record lvngDimensionChangeJnlEntry;
        GLEntry: Record "G/L Entry";
        Progress: Dialog;
        index: Integer;
    begin
        LoanBuffer.Reset();
        LoanBuffer.FindSet();
        Progress.Open('#1############## of #2###########');
        Progress.Update(2, LoanBuffer.Count);
        repeat
            index += 1;
            Progress.Update(1, index);
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