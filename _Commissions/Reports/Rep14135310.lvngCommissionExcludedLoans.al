report 14135310 "lvngCommissionExcludedLoans"
{
    Caption = 'Commission Excluded Loans';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvngLoan; lvngLoan)
        {
            RequestFilterHeading = 'Loan';
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                lvngExcelBuffer.AddColumn(lvngLoan.FieldCaption("No."), false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                lvngCommissionReportTemplateLineTemp.Reset();
                lvngCommissionReportTemplateLineTemp.SetRange(lvngCode, lvngCommissionReportTemplate.lvngCode);
                lvngCommissionReportTemplateLineTemp.FindSet();
                repeat
                    lvngExcelBuffer.AddColumn(lvngCommissionReportTemplateLineTemp.lvngDescription, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                until lvngCommissionReportTemplateLineTemp.Next() = 0;
                if GuiAllowed then begin
                    lvngProgressDialog.Open(lblProcessingDialog);
                    lvngProgressDialog.Update(2, Count());
                end;
            end;

            trigger OnPostDataItem()
            begin
                lvngExcelBuffer.CreateNewBook(lblExcelSheetName);
                lvngExcelBuffer.WriteSheet(lblExcelSheetName, CompanyName, UserId);
                lvngExcelBuffer.CloseBook();
                lvngExcelBuffer.OpenExcel();
                if GuiAllowed then
                    lvngProgressDialog.Close();
            end;

            trigger OnAfterGetRecord()
            var
                lvngShowEntry: Boolean;
                lvngDecimalValue: Decimal;
            begin
                lvngCounter := lvngCounter + 1;
                if GuiAllowed then
                    lvngProgressDialog.Update(1, lvngCounter);
                if lvngCommissionSchedule.lvngPeriodPosted then begin
                    lvngCommissionValueEntry.Reset();
                    lvngCommissionValueEntry.SetRange(lvngScheduleNo, lvngCommissionSchedule.lvngNo);
                    lvngCommissionValueEntry.SetRange(lvngLoanNo, lvngLoan."No.");
                    if lvngCommissionValueEntry.IsEmpty() then
                        lvngShowEntry := true;
                end else begin
                    lvngCommissionJournalLine.Reset();
                    lvngCommissionJournalLine.SetRange(lvngScheduleNo, lvngCommissionSchedule.lvngNo);
                    lvngCommissionJournalLine.SetRange(lvngLoanNo, lvngLoan."No.");
                    if lvngCommissionJournalLine.IsEmpty() then
                        lvngShowEntry := true;
                end;
                if lvngShowEntry then begin
                    lvngRecordRef.GetTable(lvngLoan);
                    lvngCommissionReportBuffer.reset();
                    lvngCommissionReportBuffer.DeleteAll();
                    lvngCommissionReportTemplateLineTemp.reset;
                    lvngCommissionReportTemplateLineTemp.SetRange(lvngCode, lvngCommissionReportTemplate.lvngCode);
                    lvngCommissionReportTemplateLineTemp.SetFilter(lvngType, lblTypeFilter, lvngCommissionReportTemplateLineTemp.lvngType::lvngLoanCardField, lvngCommissionReportTemplateLineTemp.lvngType::lvngLoanValueField);
                    lvngCommissionReportTemplateLineTemp.FindSet();
                    repeat
                        Clear(lvngCommissionReportBuffer);
                        lvngCommissionReportBuffer.lvngColumnNo := lvngCommissionReportTemplateLineTemp.lvngColumnNo;
                        lvngCommissionReportBuffer.lvngValue := lblIntegerValue;
                        lvngCommissionReportBuffer.lvngDescription := lvngCommissionReportTemplateLineTemp.lvngDescription;
                        lvngCommissionReportBuffer.lvngDataType := lvngCommissionReportTemplateLineTemp.lvngDataType;
                        case lvngCommissionReportTemplateLineTemp.lvngType of
                            lvngCommissionReportTemplateLineTemp.lvngType::lvngLoanValueField:
                                begin
                                    if lvngLoanValue.Get("No.", lvngCommissionReportTemplateLineTemp.lvngFieldNo) then begin
                                        lvngCommissionReportBuffer.lvngValue := lvngLoanValue."Field Value";
                                    end;
                                end;
                            lvngCommissionReportTemplateLineTemp.lvngType::lvngLoanCardField:
                                begin
                                    lvngFieldRef := lvngRecordRef.Field(lvngCommissionReportTemplateLineTemp.lvngFieldNo);
                                    lvngCommissionReportBuffer.lvngValue := Format(lvngFieldRef.Value);
                                end;
                        end;
                        if lvngCommissionReportTemplateLineTemp.lvngDecimalRounding <> 0 then begin
                            if lvngCommissionReportbuffer.lvngDataType = lvngCommissionReportBuffer.lvngDataType::lvngDecimal then begin
                                if Evaluate(lvngDecimalValue, lvngCommissionReportBuffer.lvngValue) then begin
                                    lvngDecimalValue := round(lvngDecimalValue, lvngCommissionReportTemplateLineTemp.lvngDecimalRounding);
                                    lvngCommissionReportBuffer.lvngValue := Format(lvngDecimalValue);
                                end;
                            end;
                        end;
                        lvngCommissionReportBuffer.lvngExcelExportFormat := lvngCommissionReportTemplateLineTemp.lvngExcelExportFormat;
                        lvngCommissionReportBuffer.Insert();
                    until lvngCommissionReportTemplateLineTemp.Next() = 0;
                    lvngRecordRef.Close();
                    FillCalculationBuffer();
                    lvngCommissionReportTemplateLineTemp.SetRange(lvngType, lvngCommissionReportTemplateLineTemp.lvngType::lvngFormula);
                    if lvngCommissionReportTemplateLineTemp.FindSet() then begin
                        repeat
                            Clear(lvngCommissionReportBuffer);
                            lvngCommissionReportBuffer.lvngColumnNo := lvngCommissionReportTemplateLineTemp.lvngColumnNo;
                            lvngCommissionReportBuffer.lvngValue := '0';
                            lvngCommissionReportBuffer.lvngDataType := lvngCommissionReportTemplateLineTemp.lvngDataType;
                            lvngCommissionReportBuffer.lvngDescription := lvngCommissionReportTemplateLineTemp.lvngDescription;
                            lvngExpressionHeader.Get(lvngCommissionReportTemplateLineTemp.lvngFormulaCode, lvngCommissionSetup.GetCommissionReportId());
                            lvngCommissionReportBuffer.lvngValue := lvngExpressionEngine.CalculateFormula(lvngExpressionHeader, lvngExpressionValueBuffer);
                            if lvngCommissionReportTemplateLineTemp.lvngDecimalRounding <> 0 then begin
                                if lvngCommissionReportbuffer.lvngDataType = lvngCommissionReportBuffer.lvngDataType::lvngDecimal then begin
                                    if Evaluate(lvngDecimalValue, lvngCommissionReportBuffer.lvngValue) then begin
                                        lvngDecimalValue := round(lvngDecimalValue, lvngCommissionReportTemplateLineTemp.lvngDecimalRounding);
                                        lvngCommissionReportBuffer.lvngValue := Format(lvngDecimalValue);
                                    end;
                                end;
                            end;
                            lvngCommissionReportBuffer.lvngExcelExportFormat := lvngCommissionReportTemplateLineTemp.lvngExcelExportFormat;
                            lvngCommissionReportBuffer.Insert();
                        until lvngCommissionReportTemplateLineTemp.Next() = 0;
                    end;

                    lvngExcelBuffer.NewRow();
                    lvngExcelBuffer.AddColumn(lvngLoan."No.", false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngCommissionReportTemplateLineTemp.Reset();
                    lvngCommissionReportTemplateLineTemp.SetRange(lvngCode, lvngCommissionReportTemplate.lvngCode);
                    lvngCommissionReportTemplateLineTemp.FindSet();
                    repeat
                        lvngExcelBuffer."Cell Type" := lvngExcelBuffer."Cell Type"::Text;
                        case lvngCommissionReportTemplateLineTemp.lvngDataType of
                            lvngCommissionReportTemplateLineTemp.lvngDataType::lvngDate:
                                begin
                                    lvngExcelBuffer."Cell Type" := lvngExcelBuffer."Cell Type"::Date;
                                end;
                            lvngCommissionReportTemplateLineTemp.lvngDataType::lvngDecimal:
                                begin
                                    lvngExcelBuffer."Cell Type" := lvngExcelBuffer."Cell Type"::Number;
                                end;
                            lvngCommissionReportTemplateLineTemp.lvngDataType::lvngInteger:
                                begin
                                    lvngExcelBuffer."Cell Type" := lvngExcelBuffer."Cell Type"::Number;
                                end;
                        end;
                        if lvngCommissionReportBuffer.Get(lvngCommissionReportTemplateLineTemp.lvngColumnNo) then
                            lvngExcelBuffer.AddColumn(lvngCommissionReportBuffer.lvngValue, false, '', false, false, false, lvngCommissionReportTemplateLineTemp.lvngExcelExportFormat, lvngExcelBuffer."Cell Type") else
                            lvngExcelBuffer.AddColumn('', false, '', false, false, false, lvngCommissionReportTemplateLineTemp.lvngExcelExportFormat, lvngExcelBuffer."Cell Type");
                    until lvngCommissionReportTemplateLineTemp.Next() = 0;
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
                group(lvngOptions)
                {
                    Caption = 'Options';
                    field(lvngCommissionReportTemplateCode; lvngCommissionReportTemplateCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Report Template Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, lvngCommissionReportTemplate) = Action::LookupOK then begin
                                lvngCommissionReportTemplateCode := lvngCommissionReportTemplate.lvngCode;
                            end;
                        end;
                    }
                    field(lvngCommissionScheduleNo; lvngCommissionScheduleNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Commission Schedule';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, lvngCommissionSchedule) = Action::LookupOK then begin
                                lvngCommissionScheduleNo := lvngCommissionSchedule.lvngNo;
                            end;
                        end;
                    }
                }
            }
        }

    }

    trigger OnPreReport()
    begin
        lvngCommissionSetup.Get();
        InitializeConfigBuffer();
        lvngCommissionSchedule.Get(lvngCommissionScheduleNo);
        lvngCommissionReportTemplate.Get(lvngCommissionReportTemplateCode);
        lvngCommissionReportTemplateLine.Reset();
        lvngCommissionReportTemplateLine.SetRange(lvngCode, lvngCommissionReportTemplate.lvngCode);
        lvngCommissionReportTemplateLine.FindSet();
        repeat
            clear(lvngCommissionReportTemplateLineTemp);
            lvngCommissionReportTemplateLineTemp := lvngCommissionReportTemplateLine;
            lvngCommissionReportTemplateLineTemp.Insert();
        until lvngCommissionReportTemplateLine.Next() = 0;
    end;

    local procedure FillCalculationBuffer()
    var
        lvngLoanValue: Record lvngLoanValue;
        lvngTableFields: Record Field;
        lvngFieldSequenceNo: Integer;
        lvngRecordReference: RecordRef;
        lvngFieldReference: FieldRef;
    begin
        lvngExpressionValueBuffer.Reset();
        lvngExpressionValueBuffer.DeleteAll();
        lvngLoanFieldsConfigurationTemp.reset;
        if lvngLoanFieldsConfigurationTemp.FindSet() then begin
            repeat
                lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
                lvngLoanValue.reset;
                lvngLoanValue.SetRange("Loan No.", lvngLoan."No.");
                lvngLoanValue.SetRange("Field No.", lvngLoanFieldsConfigurationTemp."Field No.");
                Clear(lvngExpressionValueBuffer);
                lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp."Field Name";
                lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp."Value Type");
                if lvngLoanValue.FindFirst() then begin
                    lvngExpressionValueBuffer.Value := lvngLoanValue."Field Value";
                end else begin
                    case lvngLoanFieldsConfigurationTemp."Value Type" of
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngBoolean:
                            begin
                                lvngExpressionValueBuffer.Value := lblFalseValue;
                            end;
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngDecimal:
                            begin
                                lvngExpressionValueBuffer.Value := lblDecimalValue;
                            end;
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngInteger:
                            begin
                                lvngExpressionValueBuffer.Value := lblIntegerValue;
                            end;
                    end;
                end;
                lvngExpressionValueBuffer.Insert();
            until lvngLoanFieldsConfigurationTemp.Next() = 0;
        end;

        lvngTableFields.reset;
        lvngTableFields.SetRange(TableNo, Database::lvngLoan);
        lvngTableFields.FindSet();
        lvngRecordReference.GetTable(lvngLoan);
        repeat
            lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
            Clear(lvngExpressionValueBuffer);
            lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
            lvngExpressionValueBuffer.Name := lvngTableFields.FieldName;
            lvngFieldReference := lvngRecordReference.Field(lvngTableFields."No.");
            lvngExpressionValueBuffer.Value := Delchr(Format(lvngFieldReference.Value()), '<>', ' ');
            lvngExpressionValueBuffer.Type := format(lvngFieldReference.Type());
            lvngExpressionValueBuffer.Insert();
        until lvngTableFields.Next() = 0;
        lvngRecordReference.Close();

        lvngCommissionReportBuffer.Reset();
        if lvngCommissionReportBuffer.FindSet() then begin
            repeat
                lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
                Clear(lvngExpressionValueBuffer);
                lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
                lvngExpressionValueBuffer.Name := strsubstno(lblCol, lvngCommissionReportBuffer.lvngColumnNo);
                lvngExpressionValueBuffer.Value := lvngCommissionReportBuffer.lvngValue;
                lvngExpressionValueBuffer.Type := format(lvngCommissionReportBuffer.lvngDataType);
                lvngExpressionValueBuffer.Insert();

            until lvngCommissionReportBuffer.Next() = 0;
        end;
    end;

    local procedure InitializeConfigBuffer()
    begin
        if not lvngLoanFieldsConfigInitialized then begin
            lvngLoanFieldsConfigInitialized := true;
            lvngLoanFieldsConfiguration.reset;
            if lvngLoanFieldsConfiguration.FindSet() then begin
                repeat
                    Clear(lvngLoanFieldsConfigurationTemp);
                    lvngLoanFieldsConfigurationTemp := lvngLoanFieldsConfiguration;
                    lvngLoanFieldsConfigurationTemp.Insert();
                until lvngLoanFieldsConfiguration.Next() = 0;
            end;
        end;
    end;

    var
        lvngCommissionJournalLine: Record lvngCommissionJournalLine;
        lvngCommissionValueEntry: Record lvngCommissionValueEntry;
        lvngCommissionReportTemplate: Record lvngCommissionReportTemplate;
        lvngCommissionReportTemplateLine: Record lvngCommReportTemplateLine;
        lvngCommissionReportBuffer: Record lvngCommissionReportBuffer temporary;
        lvngCommissionReportTemplateLineTemp: Record lvngCommReportTemplateLine temporary;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        lvngExpressionHeader: Record lvngExpressionHeader;
        lvngCommissionSetup: Record lvngCommissionSetup;
        lvngCommissionSchedule: Record lvngCommissionSchedule;
        lvngExcelBuffer: Record "Excel Buffer" temporary;
        lvngLoanValue: Record lvngLoanValue;
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
        lvngRecordRef: RecordRef;
        lvngFieldRef: FieldRef;
        lvngProgressDialog: Dialog;
        lvngLoanFieldsConfigInitialized: Boolean;
        lvngCommissionReportTemplateCode: Code[20];
        lvngCommissionScheduleNo: Integer;
        lvngCounter: Integer;
        lblFalseValue: Label 'False';
        lblIntegerValue: Label '0';
        lblDecimalValue: Label '0.00';
        lblCol: label 'Col%1';
        lblExcelSheetName: Label 'Export';
        lblTypeFilter: Label '%1|%2';
        lblProcessingDialog: Label 'Processing #1########## of #2###########';
}