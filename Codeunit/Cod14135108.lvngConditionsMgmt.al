codeunit 14135108 lvngConditionsMgmt
{
    procedure GetConditionsMgmtConsumerId() Result: Guid
    begin
        Evaluate(Result, '321a0cba-a28f-42d5-9254-cb477c494dcd');
    end;

    [EventSubscriber(ObjectType::Page, Page::lvngExpressionList, 'FillBuffer', '', true, true)]
    procedure OnFillBuffer(ExpressionHeader: Record lvngExpressionHeader; ConsumerMetadata: Text; var ExpressionBuffer: Record lvngExpressionValueBuffer)
    begin
        if GetConditionsMgmtConsumerId() = ExpressionHeader."Consumer Id" then
            case ConsumerMetadata of
                'JOURNAL':
                    begin
                        FillJournalFields(ExpressionBuffer);
                    end;
                'LOAN':
                    begin
                        FillLoanFields(ExpressionBuffer);
                    end;
            end;
    end;

    local procedure FillLoanFields(var ExpressionValueBuffer: Record lvngExpressionValueBuffer)
    var
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        TableFields: Record Field;
        FieldSequenceNo: Integer;
    begin
        LoanFieldsConfiguration.Reset();
        if LoanFieldsConfiguration.FindSet() then
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                Clear(ExpressionValueBuffer);
                ExpressionValueBuffer.Number := FieldSequenceNo;
                ExpressionValueBuffer.Name := LoanFieldsConfiguration."Field Name";
                ExpressionValueBuffer.Type := format(LoanFieldsConfiguration."Value Type");
                ExpressionValueBuffer.Insert();
            until LoanFieldsConfiguration.Next() = 0;
        TableFields.Reset();
        TableFields.SetRange(TableNo, Database::lvngLoan);
        TableFields.FindSet();
        repeat
            FieldSequenceNo := FieldSequenceNo + 1;
            Clear(ExpressionValueBuffer);
            ExpressionValueBuffer.Number := FieldSequenceNo;
            ExpressionValueBuffer.Name := TableFields.FieldName;
            ExpressionValueBuffer.Type := TableFields."Type Name";
            ExpressionValueBuffer.Insert();
        until TableFields.Next() = 0;
    end;

    procedure FillLoanFieldValues(var ExpressionValueBuffer: Record lvngExpressionValueBuffer; var Loan: Record lvngLoan)
    var
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        LoanValue: Record lvngLoanValue;
        TableFields: Record Field;
        FieldSequenceNo: Integer;
        RecordReference: RecordRef;
        FieldReference: FieldRef;
    begin
        LoanFieldsConfiguration.Reset();
        if LoanFieldsConfiguration.FindSet() then
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                LoanValue.Reset();
                LoanValue.SetRange("Loan No.", Loan."No.");
                Clear(ExpressionValueBuffer);
                ExpressionValueBuffer.Number := FieldSequenceNo;
                ExpressionValueBuffer.Name := LoanFieldsConfiguration."Field Name";
                ExpressionValueBuffer.Type := format(LoanFieldsConfiguration."Value Type");
                if LoanValue.FindFirst() then
                    ExpressionValueBuffer.Value := LoanValue."Field Value"
                else
                    case LoanFieldsConfiguration."Value Type" of
                        LoanFieldsConfiguration."Value Type"::Boolean:
                            begin
                                ExpressionValueBuffer.Value := 'False';
                            end;
                        LoanFieldsConfiguration."Value Type"::Decimal:
                            begin
                                ExpressionValueBuffer.Value := '0.00';
                            end;
                        LoanFieldsConfiguration."Value Type"::Integer:
                            begin
                                ExpressionValueBuffer.Value := '0';
                            end;
                    end;
                ExpressionValueBuffer.Insert();
            until LoanFieldsConfiguration.Next() = 0;
        TableFields.Reset();
        TableFields.SetRange(TableNo, Database::lvngLoan);
        TableFields.FindSet();
        RecordReference.GetTable(Loan);
        repeat
            FieldSequenceNo := FieldSequenceNo + 1;
            Clear(ExpressionValueBuffer);
            ExpressionValueBuffer.Number := FieldSequenceNo;
            ExpressionValueBuffer.Name := TableFields.FieldName;
            FieldReference := RecordReference.Field(TableFields."No.");
            ExpressionValueBuffer.Value := DelChr(Format(FieldReference.Value(), 0, 9), '<>', ' ');
            ExpressionValueBuffer.Type := Format(FieldReference.Type());
            ExpressionValueBuffer.Insert();
        until TableFields.Next() = 0;
        RecordReference.Close();
    end;

    local procedure FillJournalFields(var ExpressionValueBuffer: Record lvngExpressionValueBuffer)
    var
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        TableFields: Record Field;
        FieldSequenceNo: Integer;
    begin
        LoanFieldsConfiguration.Reset();
        if LoanFieldsConfiguration.FindSet() then begin
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                Clear(ExpressionValueBuffer);
                ExpressionValueBuffer.Number := FieldSequenceNo;
                ExpressionValueBuffer.Name := LoanFieldsConfiguration."Field Name";
                ExpressionValueBuffer.Type := format(LoanFieldsConfiguration."Value Type");
                ExpressionValueBuffer.Insert();
            until LoanFieldsConfiguration.Next() = 0;
        end;
        TableFields.Reset();
        TableFields.SetRange(TableNo, Database::lvngLoanJournalLine);
        TableFields.SetFilter("No.", '>%1', 4);
        TableFields.FindSet();
        repeat
            FieldSequenceNo := FieldSequenceNo + 1;
            Clear(ExpressionValueBuffer);
            ExpressionValueBuffer.Number := FieldSequenceNo;
            ExpressionValueBuffer.Name := TableFields.FieldName;
            ExpressionValueBuffer.Type := TableFields."Type Name";
            ExpressionValueBuffer.Insert();
        until TableFields.Next() = 0;
    end;

    procedure FillJournalFieldValues(var ExpressionValueBuffer: Record lvngExpressionValueBuffer; var LoanJournalLine: Record lvngLoanJournalLine)
    var
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        LoanJournalValue: Record lvngLoanJournalValue;
        TableFields: Record Field;
        FieldSequenceNo: Integer;
        RecordReference: RecordRef;
        FieldReference: FieldRef;
    begin
        LoanFieldsConfiguration.Reset();
        if LoanFieldsConfiguration.FindSet() then
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                LoanJournalValue.Reset();
                LoanJournalValue.SetRange("Loan Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
                LoanJournalValue.SetRange("Line No.", LoanJournalLine."Line No.");
                LoanJournalValue.SetRange("Field No.", LoanFieldsConfiguration."Field No.");
                Clear(ExpressionValueBuffer);
                ExpressionValueBuffer.Number := FieldSequenceNo;
                ExpressionValueBuffer.Name := LoanFieldsConfiguration."Field Name";
                ExpressionValueBuffer.Type := format(LoanFieldsConfiguration."Value Type");
                if LoanJournalValue.FindFirst() then
                    ExpressionValueBuffer.Value := LoanJournalValue."Field Value"
                else
                    case LoanFieldsConfiguration."Value Type" of
                        LoanFieldsConfiguration."Value Type"::Boolean:
                            begin
                                ExpressionValueBuffer.Value := 'False';
                            end;
                        LoanFieldsConfiguration."Value Type"::Decimal:
                            begin
                                ExpressionValueBuffer.Value := '0.00';
                            end;
                        LoanFieldsConfiguration."Value Type"::Integer:
                            begin
                                ExpressionValueBuffer.Value := '0';
                            end;
                    end;
                ExpressionValueBuffer.Insert();
            until LoanFieldsConfiguration.Next() = 0;
        TableFields.Reset();
        TableFields.SetRange(TableNo, Database::lvngLoanJournalLine);
        TableFields.SetFilter("No.", '>%1', 4);
        TableFields.FindSet();
        RecordReference.GetTable(LoanJournalLine);
        repeat
            FieldSequenceNo := FieldSequenceNo + 1;
            Clear(ExpressionValueBuffer);
            ExpressionValueBuffer.Number := FieldSequenceNo;
            ExpressionValueBuffer.Name := TableFields.FieldName;
            FieldReference := RecordReference.Field(TableFields."No.");
            ExpressionValueBuffer.Value := DelChr(Format(FieldReference.Value(), 0, 9), '<>', ' ');
            ExpressionValueBuffer.Type := Format(FieldReference.Type());
            ExpressionValueBuffer.Insert();
        until TableFields.Next() = 0;
        RecordReference.Close();
    end;
}