report 14135120 lvngReclassLoanGLEntries
{
    Caption = 'Reclass Loan G/L Entries';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Journal)
                {
                    field(TemplateName; TemplateName) { Caption = 'Journal Template'; ApplicationArea = All; TableRelation = "Gen. Journal Template".Name; }
                    field(BatchName; BatchName)
                    {
                        Caption = 'Journal Batch';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            GenJnlBatch.Reset();
                            GenJnlBatch.SetRange("Journal Template Name", TemplateName);
                            if page.RunModal(0, GenJnlBatch) = Action::LookupOK then
                                BatchName := GenJnlBatch.Name;
                        end;
                    }
                }

                group(Details)
                {
                    field(PostingDate; PostingDate) { Caption = 'Posting Date'; ApplicationArea = All; }
                    field(DocumentNo; DocumentNo) { Caption = 'Document No.'; ApplicationArea = All; }
                    field(UseNumberSeries; UseNumberSeries) { Caption = 'Use Number Series'; ApplicationArea = All; }
                    field(BalAccountType; BalAccountType) { Caption = 'Bal. Account Type'; ApplicationArea = All; }
                    field(BalAccountNo; BalAccountNo)
                    {
                        Caption = 'Bal. Account No.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            BankAccount: Record "Bank Account";
                            GLAccount: Record "G/L Account";
                        begin
                            if BalAccountType = BalAccountType::"Bank Account" then
                                BankAccount.Get(BalAccountNo);
                            if BalAccountType = BalAccountType::"G/L Account" then
                                GLAccount.Get(BalAccountNo);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            BankAccount: Record "Bank Account";
                            GLAccount: Record "G/L Account";
                        begin
                            if BalAccountType = BalAccountType::"Bank Account" then
                                if Page.RunModal(0, BankAccount) = Action::LookupOK THEN
                                    BalAccountNo := BankAccount."No.";
                            if BalAccountType = BalAccountType::"G/L Account" then
                                if Page.RunModal(0, GLAccount) = Action::LookupOK then
                                    BalAccountNo := GLAccount."No.";
                        end;
                    }
                    field(ReasonCode; ReasonCode) { Caption = 'Reason Code'; ApplicationArea = All; TableRelation = "Reason Code".Code; }
                }
            }
        }
        trigger OnOpenPage()
        begin
            PostingDate := WorkDate();
        end;
    }

    var
        CompleteMsg: Label 'Complete';
        BlankDocNoErr: Label 'Document No. can''t be blank';
        BlankPostDateErr: Label 'Posting Date can''t be blank';
        TempSourceRecBuffer: Record lvngLoanReconciliationBuffer temporary;
        GenJnlBatch: Record "Gen. Journal Batch";
        TemplateName: Code[10];
        BatchName: Code[10];
        PostingDate: Date;
        DocumentNo: Code[20];
        UseNumberSeries: Boolean;
        BalAccountType: Option "Bank Account","G/L Account";
        BalAccountNo: Code[20];
        ReasonCode: Code[10];

    trigger OnPreReport()
    var
        GenJnlLine: Record "Gen. Journal Line";
        ReasonCodeRec: Record "Reason Code";
        LoanVisionSetup: Record lvngLoanVisionSetup;
        GenJnlTemplate: Record "Gen. Journal Template";
        GLAccount: Record "G/L Account";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LineNo: Integer;
    begin
        LoanVisionSetup.Get;
        ReasonCodeRec.Get(ReasonCode);
        GenJnlTemplate.Get(TemplateName);
        GenJnlBatch.Get(TemplateName, BatchName);
        if UseNumberSeries then
            GenJnlBatch.TestField("No. Series")
        else
            if DocumentNo = '' then
                Error(BlankDocNoErr);
        if PostingDate = 0D then
            Error(BlankPostDateErr);
        LineNo := 1000;
        TempSourceRecBuffer.Reset();
        TempSourceRecBuffer.FindSet();
        repeat
            Clear(GenJnlLine);
            GenJnlLine."Journal Template Name" := TemplateName;
            GenJnlLine."Journal Batch Name" := BatchName;
            GenJnlLine."Line No." := LineNo;
            LineNo += 1000;
            GenJnlLine.Insert(true);
            GLAccount.Get(TempSourceRecBuffer."G/L Account No.");
            if GLAccount.lvngLinkedBankAccountNo <> '' then begin
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.Validate("Account No.", GLAccount.lvngLinkedBankAccountNo);
            end else begin
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.Validate("Account No.", TempSourceRecBuffer."G/L Account No.");
            end;
            if UseNumberSeries then
                GenJnlLine.Validate("Document No.", NoSeriesManagement.GetNextNo(GenJnlBatch."No. Series", TODAY, TRUE))
            else
                GenJnlLine.Validate("Document No.", DocumentNo);
            GenJnlLine.Validate("Bal. Account Type", BalAccountType);
            GenJnlLine.Validate("Bal. Account No.", BalAccountNo);
            GenJnlLine.Validate("Posting Date", PostingDate);
            GenJnlLine.Validate(Amount, TempSourceRecBuffer.Difference);
            GenJnlLine.Validate(lvngLoanNo, TempSourceRecBuffer."Loan No.");
            GenJnlLine.Validate("Reason Code", ReasonCode);
            GenJnlLine.Modify(true);
        until TempSourceRecBuffer.Next() = 0;
    end;

    trigger OnPostReport()
    begin
        Message(CompleteMsg);
        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", TemplateName);
        Page.Run(0, GenJnlBatch);
    end;

    procedure SetEntries(var LoanRecBuffer: Record lvngLoanReconciliationBuffer)
    begin
        LoanRecBuffer.Reset();
        LoanRecBuffer.SetRange(Reclass, true);
        LoanRecBuffer.FindSet();
        repeat
            Clear(TempSourceRecBuffer);
            TempSourceRecBuffer := LoanRecBuffer;
            TempSourceRecBuffer.Insert();
        until LoanRecBuffer.Next() = 0;
        LoanRecBuffer.Reset();
    end;
}