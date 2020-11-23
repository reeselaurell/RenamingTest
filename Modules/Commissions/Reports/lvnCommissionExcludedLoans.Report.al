report 14135310 "lvnCommissionExcludedLoans"
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
                TempExcelBuffer.AddColumn(Loan.FieldCaption("No."), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempCommissionReportTemplateLine.Reset();
                TempCommissionReportTemplateLine.SetRange("Template Code", CommissionReportTemplate.Code);
                TempCommissionReportTemplateLine.FindSet();
                repeat
                    TempExcelBuffer.AddColumn(TempCommissionReportTemplateLine.Description, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                until TempCommissionReportTemplateLine.Next() = 0;
                if GuiAllowed() then begin
                    ProgressDialog.Open(ProcessingDialogMsg);
                    ProgressDialog.Update(2, Count());
                end;
            end;

            trigger OnPostDataItem()
            begin
                TempExcelBuffer.CreateNewBook(ExcelSheetNameLbl);
                TempExcelBuffer.WriteSheet(ExcelSheetNameLbl, CompanyName, UserId);
                TempExcelBuffer.CloseBook();
                TempExcelBuffer.OpenExcel();
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
                    TempCommissionReportBuffer.Reset();
                    TempCommissionReportBuffer.DeleteAll();
                    TempCommissionReportTemplateLine.Reset();
                    TempCommissionReportTemplateLine.SetRange("Template Code", CommissionReportTemplate.Code);
                    TempCommissionReportTemplateLine.SetFilter("Template Line Type", TypeFilterLbl, TempCommissionReportTemplateLine."Template Line Type"::"Loan Card Field", TempCommissionReportTemplateLine."Template Line Type"::"Loan Value Field");
                    TempCommissionReportTemplateLine.FindSet();
                    repeat
                        Clear(TempCommissionReportBuffer);
                        TempCommissionReportBuffer."Column No." := TempCommissionReportTemplateLine."Column No.";
                        TempCommissionReportBuffer.Value := IntegerValueLbl;
                        TempCommissionReportBuffer.Description := TempCommissionReportTemplateLine.Description;
                        TempCommissionReportBuffer."Value Data Type" := TempCommissionReportTemplateLine."Value Data Type";
                        case TempCommissionReportTemplateLine."Template Line Type" of
                            TempCommissionReportTemplateLine."Template Line Type"::"Loan Value Field":
                                if LoanValue.Get("No.", TempCommissionReportTemplateLine."Field No.") then
                                    TempCommissionReportBuffer.Value := LoanValue."Field Value";
                            TempCommissionReportTemplateLine."Template Line Type"::"Loan Card Field":
                                begin
                                    FieldReferece := RecordReference.Field(TempCommissionReportTemplateLine."Field No.");
                                    TempCommissionReportBuffer.Value := Format(FieldReferece.Value);
                                end;
                        end;
                        if TempCommissionReportTemplateLine."Decimal Rounding" <> 0 then
                            if TempCommissionReportBuffer."Value Data Type" = TempCommissionReportBuffer."Value Data Type"::Decimal then
                                if Evaluate(DecimalValue, TempCommissionReportBuffer.Value) then begin
                                    DecimalValue := Round(DecimalValue, TempCommissionReportTemplateLine."Decimal Rounding");
                                    TempCommissionReportBuffer.Value := Format(DecimalValue);
                                end;
                        TempCommissionReportBuffer."Excel Export Format" := TempCommissionReportTemplateLine."Excel Export Format";
                        TempCommissionReportBuffer.Insert();
                    until TempCommissionReportTemplateLine.Next() = 0;
                    RecordReference.Close();
                    FillCalculationBuffer();
                    TempCommissionReportTemplateLine.SetRange("Template Line Type", TempCommissionReportTemplateLine."Template Line Type"::Formula);
                    if TempCommissionReportTemplateLine.FindSet() then
                        repeat
                            Clear(TempCommissionReportBuffer);
                            TempCommissionReportBuffer."Column No." := TempCommissionReportTemplateLine."Column No.";
                            TempCommissionReportBuffer.Value := IntegerValueLbl;
                            TempCommissionReportBuffer."Value Data Type" := TempCommissionReportTemplateLine."Value Data Type";
                            TempCommissionReportBuffer.Description := TempCommissionReportTemplateLine.Description;
                            ExpressionHeader.Get(TempCommissionReportTemplateLine."Formula Code", CommissionHelper.GetCommissionReportConsumerId());
                            TempCommissionReportBuffer.Value := ExpressionEngine.CalculateFormula(ExpressionHeader, TempExpressionValueBuffer);
                            if TempCommissionReportTemplateLine."Decimal Rounding" <> 0 then
                                if TempCommissionReportBuffer."Value Data Type" = TempCommissionReportBuffer."Value Data Type"::Decimal then
                                    if Evaluate(DecimalValue, TempCommissionReportBuffer.Value) then begin
                                        DecimalValue := Round(DecimalValue, TempCommissionReportTemplateLine."Decimal Rounding");
                                        TempCommissionReportBuffer.Value := Format(DecimalValue);
                                    end;
                            TempCommissionReportBuffer."Excel Export Format" := TempCommissionReportTemplateLine."Excel Export Format";
                            TempCommissionReportBuffer.Insert();
                        until TempCommissionReportTemplateLine.Next() = 0;
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(Loan."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempCommissionReportTemplateLine.Reset();
                    TempCommissionReportTemplateLine.SetRange("Template Code", CommissionReportTemplate.Code);
                    TempCommissionReportTemplateLine.FindSet();
                    repeat
                        TempExcelBuffer."Cell Type" := TempExcelBuffer."Cell Type"::Text;
                        case TempCommissionReportTemplateLine."Value Data Type" of
                            TempCommissionReportTemplateLine."Value Data Type"::Date:
                                TempExcelBuffer."Cell Type" := TempExcelBuffer."Cell Type"::Date;
                            TempCommissionReportTemplateLine."Value Data Type"::Decimal,
                            TempCommissionReportTemplateLine."Value Data Type"::Integer:
                                TempExcelBuffer."Cell Type" := TempExcelBuffer."Cell Type"::Number;
                        end;
                        if TempCommissionReportBuffer.Get(TempCommissionReportTemplateLine."Column No.") then
                            TempExcelBuffer.AddColumn(TempCommissionReportBuffer.Value, false, '', false, false, false, TempCommissionReportTemplateLine."Excel Export Format", TempExcelBuffer."Cell Type")
                        else
                            TempExcelBuffer.AddColumn('', false, '', false, false, false, TempCommissionReportTemplateLine."Excel Export Format", TempExcelBuffer."Cell Type");
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
                    field(CommissionReportTemplateCodeField; CommissionReportTemplateCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Report Template Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, CommissionReportTemplate) = Action::LookupOK then
                                CommissionReportTemplateCode := CommissionReportTemplate.Code;
                        end;
                    }
                    field(CommissionScheduleNoField; CommissionScheduleNo)
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
        TempCommissionReportBuffer: Record lvnCommissionReportBuffer temporary;
        TempCommissionReportTemplateLine: Record lvnCommReportTemplateLine temporary;
        TempLoanFieldsConfiguration: Record lvnLoanFieldsConfiguration temporary;
        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
        TempExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
        ExpressionHeader: Record lvnExpressionHeader;
        CommissionSchedule: Record lvnCommissionSchedule;
        TempExcelBuffer: Record "Excel Buffer" temporary;
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
        ColLbl: Label 'Col%1', Comment = '%1 = Column No.';
        ExcelSheetNameLbl: Label 'Export';
        TypeFilterLbl: Label '%1|%2', Comment = '%1 = Template Line Type::Loan Card Field; %2 = Template Line Type::Loan Value Field';
        ProcessingDialogMsg: Label 'Processing #1########## of #2###########', Comment = '#1 = Entry No.; #2 = Total Entries';

    local procedure FillCalculationBuffer()
    var
        LoanValue: Record lvnLoanValue;
        TableFields: Record Field;
        RecordReference: RecordRef;
        FieldSequenceNo: Integer;
        FieldReference: FieldRef;
    begin
        TempExpressionValueBuffer.Reset();
        TempExpressionValueBuffer.DeleteAll();
        TempLoanFieldsConfiguration.Reset();
        if TempLoanFieldsConfiguration.FindSet() then
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                LoanValue.Reset();
                LoanValue.SetRange("Loan No.", Loan."No.");
                LoanValue.SetRange("Field No.", TempLoanFieldsConfiguration."Field No.");
                Clear(TempExpressionValueBuffer);
                TempExpressionValueBuffer.Number := FieldSequenceNo;
                TempExpressionValueBuffer.Name := TempLoanFieldsConfiguration."Field Name";
                TempExpressionValueBuffer.Type := Format(TempLoanFieldsConfiguration."Value Type");
                if LoanValue.FindFirst() then
                    TempExpressionValueBuffer.Value := LoanValue."Field Value"
                else
                    case TempLoanFieldsConfiguration."Value Type" of
                        TempLoanFieldsConfiguration."Value Type"::Boolean:
                            TempExpressionValueBuffer.Value := FalseValueLbl;
                        TempLoanFieldsConfiguration."Value Type"::Decimal:
                            TempExpressionValueBuffer.Value := DecimalValueLbl;
                        TempLoanFieldsConfiguration."Value Type"::Integer:
                            TempExpressionValueBuffer.Value := IntegerValueLbl;
                    end;
                TempExpressionValueBuffer.Insert();
            until TempLoanFieldsConfiguration.Next() = 0;

        TableFields.Reset();
        TableFields.SetRange(TableNo, Database::lvnLoan);
        TableFields.FindSet();
        RecordReference.GetTable(Loan);
        repeat
            FieldSequenceNo := FieldSequenceNo + 1;
            Clear(TempExpressionValueBuffer);
            TempExpressionValueBuffer.Number := FieldSequenceNo;
            TempExpressionValueBuffer.Name := TableFields.FieldName;
            FieldReference := RecordReference.Field(TableFields."No.");
            TempExpressionValueBuffer.Value := DelChr(Format(FieldReference.Value()), '<>', ' ');
            TempExpressionValueBuffer.Type := Format(FieldReference.Type());
            TempExpressionValueBuffer.Insert();
        until TableFields.Next() = 0;
        RecordReference.Close();

        TempCommissionReportBuffer.Reset();
        if TempCommissionReportBuffer.FindSet() then
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                Clear(TempExpressionValueBuffer);
                TempExpressionValueBuffer.Number := FieldSequenceNo;
                TempExpressionValueBuffer.Name := StrSubstNo(ColLbl, TempCommissionReportBuffer."Column No.");
                TempExpressionValueBuffer.Value := TempCommissionReportBuffer.Value;
                TempExpressionValueBuffer.Type := Format(TempCommissionReportBuffer."Value Data Type");
                TempExpressionValueBuffer.Insert();
            until TempCommissionReportBuffer.Next() = 0;
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