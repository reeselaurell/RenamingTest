xmlport 14135106 "lvnDimensionLoanChangeImport"
{
    Caption = 'Dimension Loan Change Import';
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(LoanBuffer; lvnLoanReportingBuffer)
            {
                UseTemporary = true;

                fieldelement(LoanNo; LoanBuffer."Loan No.")
                {
                }
            }
        }
    }

    trigger OnPostXmlPort()
    var
        DimensionChangeJnlEntry: Record lvnDimensionChangeJnlEntry;
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
            GLEntry.SetRange(lvnLoanNo, LoanBuffer."Loan No.");
            if GLEntry.FindSet() then
                repeat
                    Clear(DimensionChangeJnlEntry);
                    DimensionChangeJnlEntry."Change Set ID" := ChangeSetId;
                    DimensionChangeJnlEntry.TransferValuesFromRecord(GLEntry);
                    if DimensionChangeJnlEntry.Insert() then;
                until GLEntry.Next() = 0;
        until LoanBuffer.Next() = 0;
        Progress.Close();
    end;

    var
        ChangeSetId: Guid;
        ProgressLbl: Label '#1############## of #2###########', Comment = '#1 = Entry No.; #2 = Total Entries';

    procedure SetParams(pChangeSetID: Guid)
    begin
        ChangeSetId := pChangeSetID;
    end;
}