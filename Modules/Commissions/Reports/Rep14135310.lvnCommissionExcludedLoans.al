report 14135310 lvnCommissionExcludedLoans
{
    Caption = 'Commission Excluded Loans';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Loan; lvnLoan)
        {
            RequestFilterHeading = 'Loan';
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                ExcelBuffer.AddColumn(Loan.FieldCaption("No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                TempCommissionReportTemplateLine.Reset();
                TempCommissionReportTemplateLine.SetRange("Template Code", CommissionReportTemplate.Code);
                TempCommissionReportTemplateLine.FindSet();
                repeat
                    ExcelBuffer.AddColumn(TempCommissionReportTemplateLine.Description, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                until TempCommissionReportTemplateLine.Next() = 0;
                if GuiAllowed() then begin
                    ProgressDialog.Open(ProcessingDialogMsg);
                    ProgressDialog.Update(2, Count());
                end;
            end;

            trigger OnPostDataItem()
            begin
                ExcelBuffer.CreateNewBook(ExcelSheetNameLbl);
                ExcelBuffer.WriteSheet(ExcelSheetNameLbl, CompanyName, UserId);
                ExcelBuffer.CloseBook();
                ExcelBuffer.OpenExcel();
                if GuiAllowed() then
                    ProgressDialog.Close();
            end;

            trigger OnAfterGetRecord()
            var
                ShowEntry: Boolean;
                DecimalValue: Decimal;
            begin
                Counter := Counter + 1;
                if GuiAllowed then
                    ProgressDialog.Update(1, Counter);
                if CommissionSchedule."Period Posted" then begin
                    CommissionValueEntry.Reset();
                    CommissionValueEntry.SetRange("Schedule No.", CommissionSchedule."No.");
                    CommissionValueEntry.SetRange("Loan No.", Loan."No.");
                    if CommissionValueEntry.IsEmpty() then
                        ShowEntry := true;
                end else begin
                    CommissionJournalLine.Reset();
                    CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
                    CommissionJournalLine.SetRange("Loan No.", Loan."No.");
                    if CommissionJournalLine.IsEmpty() then
                        ShowEntry := true;
                end;
                if ShowEntry then begin
                    RecordReference.GetTable(Loan);
                    CommissionReportBuffer.Reset();
                    CommissionReportBuffer.DeleteAll();
                    TempCommissionReportTemplateLine.Reset;
                    TempCommissionReportTemplateLine.SetRange("Template Code", CommissionReportTemplate.Code);
                    TempCommissionReportTemplateLine.SetFilter("Template Line Type", TypeFilterLbl, TempCommissionReportTemplateLine."Template Line Type"::"Loan Card Field", TempCommissionReportTemplateLine."Template Line Type"::"Loan Value Field");
                    TempCommissionReportTemplateLine.FindSet();
                    repeat
                        Clear(CommissionReportBuffer);
                        CommissionReportBuffer."Column No." := TempCommissionReportTemplateLine."Column No.";
                        CommissionReportBuffer.Value := IntegerValueLbl;
                        CommissionReportBuffer.Description := TempCommissionReportTemplateLine.Description;
                        CommissionReportBuffer."Value Data Type" := TempCommissionReportTemplateLine."Value Data Type";
                        case TempCommissionReportTemplateLine."Template Line Type" of
                            TempCommissionReportTemplateLine."Template Line Type"::"Loan Value Field":
                                begin
                                    if LoanValue.Get("No.", TempCommissionReportTemplateLine."Field No.") then begin
                                        CommissionReportBuffer.Value := LoanValue."Field Value";
                                    end;
                                end;
                            TempCommissionReportTemplateLine."Template Line Type"::"Loan Card Field":
                                begin
                                    FieldReferece := RecordReference.Field(TempCommissionReportTemplateLine."Field No.");
                                    CommissionReportBuffer.Value := Format(FieldReferece.Value);
                                end;
                        end;
                        if TempCommissionReportTemplateLine."Decimal Rounding" <> 0 then
                            if CommissionReportbuffer."Value Data Type" = CommissionReportBuffer."Value Data Type"::Decimal then
                                if Evaluate(DecimalValue, CommissionReportBuffer.Value) then begin
                                    DecimalValue := Round(DecimalValue, TempCommissionReportTemplateLine."Decimal Rounding");
                                    CommissionReportBuffer.Value := Format(DecimalValue);
                                end;
                        CommissionReportBuffer."Excel Export Format" := TempCommissionReportTemplateLine."Excel Export Format";
                        CommissionReportBuffer.Insert();
                    until TempCommissionReportTemplateLine.Next() = 0;
                    RecordReference.Close();
                    FillCalculationBuffer();
                    TempCommissionReportTemplateLine.SetRange("Template Line Type", TempCommissionReportTemplateLine."Template Line Type"::Formula);
                    if TempCommissionReportTemplateLine.FindSet() then begin
                        repeat
                            Clear(CommissionReportBuffer);
                            CommissionReportBuffer."Column No." := TempCommissionReportTemplateLine."Column No.";
                            CommissionReportBuffer.Value := IntegerValueLbl;
                            CommissionReportBuffer."Value Data Type" := TempCommissionReportTemplateLine."Value Data Type";
                            CommissionReportBuffer.Description := TempCommissionReportTemplateLine.Description;
                            ExpressionHeader.Get(TempCommissionReportTemplateLine."Formula Code", CommissionHelper.GetCommissionReportConsumerId());
                            CommissionReportBuffer.Value := ExpressionEngine.CalculateFormula(ExpressionHeader, ExpressionValueBuffer);
                            if TempCommissionReportTemplateLine."Decimal Rounding" <> 0 then
                                if CommissionReportbuffer."Value Data Type" = CommissionReportBuffer."Value Data Type"::Decimal then
                                    if Evaluate(DecimalValue, CommissionReportBuffer.Value) then begin
                                        DecimalValue := Round(DecimalValue, TempCommissionReportTemplateLine."Decimal Rounding");
                                        CommissionReportBuffer.Value := Format(DecimalValue);
                                    end;
                            CommissionReportBuffer."Excel Export Format" := TempCommissionReportTemplateLine."Excel Export Format";
                            CommissionReportBuffer.Insert();
                        until TempCommissionReportTemplateLine.Next() = 0;
                    end;

                    ExcelBuffer.NewRow();
                    ExcelBuffer.AddColumn(Loan."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    TempCommissionReportTemplateLine.Reset();
                    TempCommissionReportTemplateLine.SetRange("Template Code", CommissionReportTemplate.Code);
                    TempCommissionReportTemplateLine.FindSet();
                    repeat
                        ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Text;
                        case TempCommissionReportTemplateLine."Value Data Type" of
                            TempCommissionReportTemplateLine."Value Data Type"::Date:
                                ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Date;
                            TempCommissionReportTemplateLine."Value Data Type"::Decimal,
                            TempCommissionReportTemplateLine."Value Data Type"::Integer:
                                ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Number;
                        end;
                        if CommissionReportBuffer.Get(TempCommissionReportTemplateLine."Column No.") then
                            ExcelBuffer.AddColumn(CommissionReportBuffer.Value, false, '', false, false, false, TempCommissionReportTemplateLine."Excel Export Format", ExcelBuffer."Cell Type")
                        else
                            ExcelBuffer.AddColumn('', false, '', false, false, false, TempCommissionReportTemplateLine."Excel Export Format", ExcelBuffer."Cell Type");
                    until TempCommissionReportTemplateLine.Next() = 0;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(CommissionReportTemplateCode; CommissionReportTemplateCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Report Template Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, CommissionReportTemplate) = Action::LookupOK then
                                CommissionReportTemplateCode := CommissionReportTemplate.Code;
                        end;
                    }
                    field(CommissionScheduleNo; CommissionScheduleNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Commission Schedule';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, CommissionSchedule) = Action::LookupOK then
                                CommissionScheduleNo := CommissionSchedule."No.";
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        InitializeConfigBuffer();
        CommissionSchedule.Get(CommissionScheduleNo);
        CommissionReportTemplate.Get(CommissionReportTemplateCode);
        CommissionReportTemplateLine.Reset();
        CommissionReportTemplateLine.SetRange("Template Code", CommissionReportTemplate.Code);
        CommissionReportTemplateLine.FindSet();
        repeat
            Clear(TempCommissionReportTemplateLine);
            TempCommissionReportTemplateLine := CommissionReportTemplateLine;
            TempCommissionReportTemplateLine.Insert();
        until CommissionReportTemplateLine.Next() = 0;
    end;

    var
        CommissionJournalLine: Record lvnCommissionJournalLine;
        CommissionValueEntry: Record lvnCommissionValueEntry;
        CommissionReportTemplate: Record lvnCommissionReportTemplate;
        CommissionReportTemplateLine: Record lvnCommReportTemplateLine;
        CommissionReportBuffer: Record lvnCommissionReportBuffer temporary;
        TempCommissionReportTemplateLine: Record lvnCommReportTemplateLine temporary;
        TempLoanFieldsConfiguration: Record lvnLoanFieldsConfiguration temporary;
        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
        ExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
        ExpressionHeader: Record lvnExpressionHeader;
        CommissionSchedule: Record lvnCommissionSchedule;
        ExcelBuffer: Record "Excel Buffer" temporary;
        LoanValue: Record lvnLoanValue;
        CommissionHelper: Codeunit lvnCommissionCalcHelper;
        ExpressionEngine: Codeunit lvnExpressionEngine;
        RecordReference: RecordRef;
        FieldReferece: FieldRef;
        ProgressDialog: Dialog;
        LoanFieldsConfigInitialized: Boolean;
        CommissionReportTemplateCode: Code[20];
        CommissionScheduleNo: Integer;
        Counter: Integer;
        FalseValueLbl: Label 'False';
        IntegerValueLbl: Label '0';
        DecimalValueLbl: Label '0.00';
        ColLbl: Label 'Col%1';
        ExcelSheetNameLbl: Label 'Export';
        TypeFilterLbl: Label '%1|%2';
        ProcessingDialogMsg: Label 'Processing #1########## of #2###########';

    local procedure FillCalculationBuffer()
    var
        LoanValue: Record lvnLoanValue;
        TableFields: Record Field;
        FieldSequenceNo: Integer;
        RecordReference: RecordRef;
        FieldReference: FieldRef;
    begin
        ExpressionValueBuffer.Reset();
        ExpressionValueBuffer.DeleteAll();
        TempLoanFieldsConfiguration.Reset;
        if TempLoanFieldsConfiguration.FindSet() then
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                LoanValue.Reset();
                LoanValue.SetRange("Loan No.", Loan."No.");
                LoanValue.SetRange("Field No.", TempLoanFieldsConfiguration."Field No.");
                Clear(ExpressionValueBuffer);
                ExpressionValueBuffer.Number := FieldSequenceNo;
                ExpressionValueBuffer.Name := TempLoanFieldsConfiguration."Field Name";
                ExpressionValueBuffer.Type := Format(TempLoanFieldsConfiguration."Value Type");
                if LoanValue.FindFirst() then
                    ExpressionValueBuffer.Value := LoanValue."Field Value"
                else
                    case TempLoanFieldsConfiguration."Value Type" of
                        TempLoanFieldsConfiguration."Value Type"::Boolean:
                            ExpressionValueBuffer.Value := FalseValueLbl;
                        TempLoanFieldsConfiguration."Value Type"::Decimal:
                            ExpressionValueBuffer.Value := DecimalValueLbl;
                        TempLoanFieldsConfiguration."Value Type"::Integer:
                            ExpressionValueBuffer.Value := IntegerValueLbl;
                    end;
                ExpressionValueBuffer.Insert();
            until TempLoanFieldsConfiguration.Next() = 0;

        TableFields.Reset();
        TableFields.SetRange(TableNo, Database::lvnLoan);
        TableFields.FindSet();
        RecordReference.GetTable(Loan);
        repeat
            FieldSequenceNo := FieldSequenceNo + 1;
            Clear(ExpressionValueBuffer);
            ExpressionValueBuffer.Number := FieldSequenceNo;
            ExpressionValueBuffer.Name := TableFields.FieldName;
            FieldReference := RecordReference.Field(TableFields."No.");
            ExpressionValueBuffer.Value := DelChr(Format(FieldReference.Value()), '<>', ' ');
            ExpressionValueBuffer.Type := Format(FieldReference.Type());
            ExpressionValueBuffer.Insert();
        until TableFields.Next() = 0;
        RecordReference.Close();

        CommissionReportBuffer.Reset();
        if CommissionReportBuffer.FindSet() then
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                Clear(ExpressionValueBuffer);
                ExpressionValueBuffer.Number := FieldSequenceNo;
                ExpressionValueBuffer.Name := StrSubstNo(ColLbl, CommissionReportBuffer."Column No.");
                ExpressionValueBuffer.Value := CommissionReportBuffer.Value;
                ExpressionValueBuffer.Type := Format(CommissionReportBuffer."Value Data Type");
                ExpressionValueBuffer.Insert();
            until CommissionReportBuffer.Next() = 0;
    end;

    local procedure InitializeConfigBuffer()
    begin
        if not LoanFieldsConfigInitialized then begin
            LoanFieldsConfigInitialized := true;
            LoanFieldsConfiguration.Reset();
            if LoanFieldsConfiguration.FindSet() then
                repeat
                    Clear(TempLoanFieldsConfiguration);
                    TempLoanFieldsConfiguration := LoanFieldsConfiguration;
                    TempLoanFieldsConfiguration.Insert();
                until LoanFieldsConfiguration.Next() = 0;
        end;
    end;
}