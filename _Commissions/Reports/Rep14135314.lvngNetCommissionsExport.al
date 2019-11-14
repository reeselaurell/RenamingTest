report 14135314 "lvngNetCommissionsExport"
{
    Caption = 'Net Commissions Export';
    ProcessingOnly = true;

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

                    field(lvngCommissionScheduleNo; lvngCommissionScheduleNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Commission Schedule';
                        TableRelation = lvngCommissionSchedule.lvngNo;

                        trigger OnValidate()
                        begin
                            if lvngCommissionSchedule.Get(lvngCommissionScheduleNo) then begin
                                lvngDateFilter := StrSubstNo(lblDateFilter, lvngCommissionSchedule.lvngPeriodStartDate, lvngCommissionSchedule.lvngPeriodEndDate);
                                lvngPeriodIdentifierFilter := lvngCommissionSchedule.lvngPeriodIdentifier;
                            end;
                        end;
                    }
                    field(lvngDateFilter; lvngDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Date Filter';

                        trigger OnValidate()
                        begin
                            FilterHelperTriggers.MakeDateFilter(lvngDateFilter);
                        end;
                    }

                    field(lvngPeriodIdentifierFilter; lvngPeriodIdentifierFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Period Identifier Filter';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, lvngPeriodIdentifier) = Action::LookupOK then begin
                                lvngPeriodIdentifierFilter := Text + lvngPeriodIdentifier.lvngCode;
                            end;
                        end;
                    }
                }
            }
        }

    }

    trigger OnPreReport()
    begin
        CommissionSetup.Get();
        LoanVisionSetup.Get();
        lvngExcelBuffer.AddColumn(lblLoanOfficerCode, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblPayrollID, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblLoanOfficerName, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblCostCenterCode, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(CommissionSetup.lvngCommissionIdentifierCode, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngAmountStartPosition := lvngExcelBuffer.xlRowID;
        lvngCommissionIdentifier.Reset();
        lvngCommissionIdentifier.SetFilter(lvngCode, '<>%1', CommissionSetup.lvngCommissionIdentifierCode);
        if lvngCommissionIdentifier.FindSet() then begin
            repeat
                lvngExcelBuffer.AddColumn(lvngCommissionIdentifier.lvngCode, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
            until lvngCommissionIdentifier.Next() = 0;
        end;
        lvngExcelBuffer.AddColumn(lblTotal, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);

        lvngCommissionProfile.Reset();
        lvngCommissionProfile.FindSet();
        if GuiAllowed then begin
            lvngProcessingDialog.Open(lblProcessingDialog);
            lvngProcessingDialog.Update(2, lvngCommissionProfile.Count);
        end;
        repeat
            lvngCounter := lvngCounter + 1;
            Clear(lvngEntryExist);
            Clear(lvngCalculatedAmount);
            if GuiAllowed then
                lvngProcessingDialog.Update(1, lvngCounter);
            lvngCommissionJournalLine.Reset();
            lvngCommissionJournalLine.SetCurrentKey(lvngProfileCode, lvngCommissionDate, lvngPeriodIdentifierCode, lvngProfileLineType, lvngIdentifierCode);
            lvngCommissionJournalLine.SetRange(lvngProfileCode, lvngCommissionProfile.lvngCode);
            lvngCommissionJournalLine.SetFilter(lvngCommissionDate, lvngDateFilter);
            if lvngPeriodIdentifierFilter <> '' then
                lvngCommissionJournalLine.SetFilter(lvngPeriodIdentifierCode, lvngPeriodIdentifierFilter);
            lvngCommissionJournalLine.SetRange(lvngProfileLineType, lvngCommissionJournalLine.lvngProfileLineType::lvngLoanLevel);
            if not lvngCommissionJournalLine.IsEmpty() then
                lvngEntryExist := true;
            lvngCommissionJournalLine.SetRange(lvngIdentifierCode, CommissionSetup.lvngCommissionIdentifierCode);
            lvngCommissionJournalLine.CalcSums(lvngCommissionAmount);
            lvngCalculatedAmount := lvngCommissionJournalLine.lvngCommissionAmount;
            lvngCommissionValueEntry.Reset();
            lvngCommissionValueEntry.SetRange(lvngProfileCode, lvngCommissionProfile.lvngCode);
            lvngCommissionValueEntry.SetFilter(lvngCommissionDate, lvngDateFilter);
            if lvngPeriodIdentifierFilter <> '' then
                lvngCommissionValueEntry.SetFilter(lvngPeriodIdentifierCode, lvngPeriodIdentifierFilter);
            lvngCommissionValueEntry.SetRange(lvngProfileLineType, lvngCommissionValueEntry.lvngProfileLineType::lvngLoanLevel);
            if not lvngCommissionValueEntry.IsEmpty() then
                lvngEntryExist := true;
            lvngCommissionValueEntry.SetRange(lvngIdentifierCode, CommissionSetup.lvngCommissionIdentifierCode);
            lvngCommissionValueEntry.CalcSums(lvngCommissionAmount);
            lvngCalculatedAmount := lvngCalculatedAmount + lvngCommissionValueEntry.lvngCommissionAmount;
            if lvngEntryExist then begin
                lvngExcelBuffer.NewRow();
                lvngDimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", lvngCommissionProfile.lvngCode);
                lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                lvngExcelBuffer.AddColumn(lvngDimensionValue.lvngAdditionalCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngName, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngCostCenterCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                lvngExcelBuffer.AddColumn(lvngCalculatedAmount, false, '', false, false, false, lblNumberFormat, lvngExcelBuffer."Cell Type"::Number);
                lvngCommissionIdentifier.reset;
                lvngCommissionIdentifier.SetFilter(lvngCode, '<>%1', CommissionSetup.lvngCommissionIdentifierCode);
                if lvngCommissionIdentifier.FindSet() then begin
                    repeat
                        Clear(lvngCalculatedAmount);
                        lvngCommissionJournalLine.SetRange(lvngIdentifierCode, lvngCommissionIdentifier.lvngCode);
                        lvngCommissionJournalLine.CalcSums(lvngCommissionAmount);
                        lvngCalculatedAmount := lvngCommissionJournalLine.lvngCommissionAmount;
                        lvngCommissionValueEntry.SetRange(lvngIdentifierCode, CommissionSetup.lvngCommissionIdentifierCode);
                        lvngCommissionValueEntry.CalcSums(lvngCommissionAmount);
                        lvngCalculatedAmount := lvngCalculatedAmount + lvngCommissionValueEntry.lvngCommissionAmount;
                        lvngExcelBuffer.AddColumn(lvngCalculatedAmount, false, '', false, false, false, lblNumberFormat, lvngExcelBuffer."Cell Type"::Number);
                    until lvngCommissionIdentifier.Next() = 0;
                end;
                lvngExcelBuffer.SetFormula(StrSubstNo(lblSumFormula, lvngAmountStartPosition, lvngExcelBuffer.xlRowID, lvngExcelBuffer.xlColID, lvngExcelBuffer.xlRowID));
                lvngFormula := lvngExcelBuffer.GetFormula();
                lvngExcelBuffer.AddColumn(lvngFormula, true, '', false, false, false, lblNumberFormat, lvngExcelBuffer."Cell Type"::Number);
            end;
        until lvngCommissionProfile.Next() = 0;

        lvngExcelBuffer.CreateNewBook(lblExcelSheetName);
        lvngExcelBuffer.WriteSheet(lblExcelSheetName, CompanyName, UserId);
        lvngExcelBuffer.CloseBook();
        lvngExcelBuffer.OpenExcel();
        if GuiAllowed then
            lvngProcessingDialog.Close();

    end;


    var
        lvngCommissionJournalLine: Record lvngCommissionJournalLine;
        lvngCommissionValueEntry: Record lvngCommissionValueEntry;
        CommissionSetup: Record lvngCommissionSetup;
        LoanVisionSetup: Record lvngLoanVisionSetup;
        lvngPeriodIdentifier: Record lvngPeriodIdentifier;
        lvngCommissionIdentifier: Record lvngCommissionIdentifier;
        lvngCommissionProfile: Record lvngCommissionProfile;
        lvngDimensionValue: Record "Dimension Value";
        lvngExcelBuffer: Record "Excel Buffer" temporary;
        lvngCommissionSchedule: Record lvngCommissionSchedule;
        FilterHelperTriggers: Codeunit "Filter Helper Triggers";
        lvngProcessingDialog: Dialog;
        lvngCounter: Integer;
        lvngCommissionScheduleNo: Integer;
        lvngDateFilter: Text;
        lvngPeriodIdentifierFilter: Text;
        lvngFormula: Text;
        lvngEntryExist: Boolean;
        lvngCalculatedAmount: Decimal;
        lvngAmountStartPosition: Text;
        lblLoanOfficerCode: Label 'Loan Officer Code';
        lblLoanOfficerName: Label 'Loan Officer Name';
        lblPayrollID: Label 'Payroll ID';
        lblCostCenterCode: Label 'Cost Center Code';
        lblExcelSheetName: Label 'Export';
        lblDateFilter: Label '%1..%2';
        lblTotal: Label 'Total';
        lblSumFormula: Label 'SUM(%1%2:%3%4)';
        lblNumberFormat: Label '0.00';
        lblProcessingDialog: Label 'Processing #1######## of #2##########';
}