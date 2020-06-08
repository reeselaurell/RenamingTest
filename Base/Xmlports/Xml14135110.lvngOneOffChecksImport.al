xmlport 14135110 lvngOneOffChecksImport
{
    Caption = 'One Off Checks Import';
    Direction = Import;
    Format = VariableText;
    FieldSeparator = '<TAB>';

    schema
    {
        textelement(Root)
        {
            tableelement(TempImportBuffer; lvngOneOffCheckImportBuffer)
            {
                SourceTableView = sorting("Entry No.");
                UseTemporary = true;

                fieldelement(GLAccountNo; TempImportBuffer."G/L Account No.") { }
                fieldelement(Name; TempImportBuffer.Name) { }
                fieldelement(Amount; TempImportBuffer.Amount) { }
                fieldelement(LoanNo; TempImportBuffer."Loan No.") { }
                textelement(Address)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        TempImportBuffer.Address := CopyStr(Address, 1, MaxStrLen(TempImportBuffer.Address));
                        TempImportBuffer."Address 2" := CopyStr(Address, 50, MaxStrLen(TempImportBuffer."Address 2"));
                    end;
                }
                fieldelement(City; TempImportBuffer.City) { }
                fieldelement(County; TempImportBuffer.County) { }
                fieldelement(ZIPCode; TempImportBuffer."Post Code") { }

                trigger OnBeforeInsertRecord()
                begin
                    EntryNo += 1;
                    TempImportBuffer."Entry No." := EntryNo;
                end;
            }
        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Group)
                {
                    field(BankAccountNo; BankAccountNo) { Caption = 'Bank Account No.'; ApplicationArea = All; TableRelation = "Bank Account"."No."; }
                    field(CheckType; CheckType) { Caption = 'Bank Payment Type'; ApplicationArea = All; }
                    field(ReasonCode; ReasonCode) { Caption = 'Reason Code'; ApplicationArea = All; TableRelation = "Reason Code".Code; }
                    field(PostingDate; PostingDate) { Caption = 'Posting Date'; ApplicationArea = All; }
                }
            }
        }
    }

    var
        GenJnlBatch: Record "Gen. Journal Batch";
        EntryNo: Integer;
        PostingDate: Date;
        ReasonCode: Code[10];
        BankAccountNo: Code[20];
        CheckType: Enum lvngBankPaymentType;

    trigger OnPostXmlPort()
    var
        GenJnlLine: Record "Gen. Journal Line";
        CheckDetailsBuffer: Record lvngCheckDetailsBuffer;
        TempOneOffCheckBuffer: Record lvngOneOffCheckImportBuffer temporary;
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        TempImportBuffer.Reset();
        TempImportBuffer.FindSet();
        repeat
            TempOneOffCheckBuffer.Reset();
            TempOneOffCheckBuffer.SetRange("Loan No.", TempImportBuffer."Loan No.");
            TempOneOffCheckBuffer.SetRange(Name, TempImportBuffer.Name);
            TempOneOffCheckBuffer.SetRange("G/L Account No.", TempImportBuffer."G/L Account No.");
            if TempOneOffCheckBuffer.FindFirst() then begin
                TempOneOffCheckBuffer.Amount := TempOneOffCheckBuffer.Amount + TempImportBuffer.Amount;
                TempOneOffCheckBuffer.Modify();
            end else begin
                Clear(TempOneOffCheckBuffer);
                TempOneOffCheckBuffer := TempImportBuffer;
                TempOneOffCheckBuffer.Insert();
            end;
        until TempImportBuffer.Next() = 0;
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJnlBatch."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch.Name);
        if GenJnlLine.FindLast() then
            EntryNo := GenJnlLine."Line No.";
        EntryNo := EntryNo + 1000;
        TempOneOffCheckBuffer.Reset();
        TempOneOffCheckBuffer.FindSet();
        repeat
            Clear(GenJnlLine);
            GenJnlLine.Validate("Journal Template Name", GenJnlBatch."Journal Template Name");
            GenJnlLine.Validate("Journal Batch Name", GenJnlBatch.Name);
            GenJnlLine."Line No." := EntryNo;
            EntryNo := EntryNo + 1000;
            GenJnlLine.Insert(true);
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.Validate("Account No.", TempOneOffCheckBuffer."G/L Account No.");
            GenJnlLine.Validate("Posting Date", PostingDate);
            GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.Validate("Document No.", NoSeriesManagement.GetNextNo(GenJnlBatch."No. Series", TODAY, TRUE));
            GenJnlLine.Validate("External Document No.", ReasonCode + TempOneOffCheckBuffer."Loan No.");
            GenJnlLine.Validate(lvngLoanNo, TempOneOffCheckBuffer."Loan No.");
            GenJnlLine.Validate(lvngImportID, CreateGuid());
            Clear(CheckDetailsBuffer);
            CheckDetailsBuffer."Primary Key" := GenJnlLine.lvngImportID;
            CheckDetailsBuffer.Address := TempOneOffCheckBuffer.Address;
            CheckDetailsBuffer."Address 2" := TempOneOffCheckBuffer."Address 2";
            CheckDetailsBuffer.City := TempOneOffCheckBuffer.City;
            CheckDetailsBuffer.County := TempOneOffCheckBuffer.County;
            CheckDetailsBuffer."Post Code" := TempOneOffCheckBuffer."Post Code";
            CheckDetailsBuffer.Name := TempOneOffCheckBuffer.Name;
            CheckDetailsBuffer."Check Description" := CopyStr(TempOneOffCheckBuffer.Name + '|' + TempOneOffCheckBuffer."Loan No.", 1, MaxStrLen(CheckDetailsBuffer."Check Description"));
            CheckDetailsBuffer.Insert();
            GenJnlLine.Description := CopyStr(TempOneOffCheckBuffer.Name, 1, 50);
            GenJnlLine.Validate(Amount, TempOneOffCheckBuffer.Amount);
            GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
            GenJnlLine.Validate("Bal. Account No.", BankAccountNo);
            GenJnlLine.Validate("Bank Payment Type", CheckType);
            if ReasonCode <> '' then
                GenJnlLine.Validate("Reason Code", ReasonCode);
            GenJnlLine.Modify(true);
        until TempOneOffCheckBuffer.Next() = 0;
    end;

    procedure SetParams(JournalTemplate: Code[20]; JournalBatch: Code[20])
    begin
        GenJnlBatch.Get(JournalTemplate, JournalBatch);
        GenJnlBatch.TestField("No. Series");
    end;
}