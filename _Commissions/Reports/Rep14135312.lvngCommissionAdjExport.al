report 14135312 "lvngCommissionAdjExport"
{
    Caption = 'Commissions Adjustments Export';
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
        LoanVisionSetup.Get();
        lvngExcelBuffer.AddColumn(lblLoanOfficerCode, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblPayrollID, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblLoanOfficerName, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblCostCenterCode, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblDescription, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblManualEntry, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblIdentifierCode, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblLoanNo, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblAmount, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);

        lvngCommissionProfile.Reset();
        lvngCommissionProfile.FindSet();
        if GuiAllowed then begin
            lvngProcessingDialog.Open(lblProcessingDialog);
            lvngProcessingDialog.Update(2, lvngCommissionProfile.Count);
        end;
        repeat
            lvngCounter := lvngCounter + 1;
            lvngDimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", lvngCommissionProfile.lvngCode);
            if GuiAllowed then
                lvngProcessingDialog.Update(1, lvngCounter);
            lvngCommissionJournalLine.Reset();
            lvngCommissionJournalLine.SetRange(lvngProfileCode, lvngCommissionProfile.lvngCode);
            lvngCommissionJournalLine.SetFilter(lvngCommissionDate, lvngDateFilter);
            if lvngPeriodIdentifierFilter <> '' then
                lvngCommissionJournalLine.SetFilter(lvngPeriodIdentifierCode, lvngPeriodIdentifierFilter);
            lvngCommissionJournalLine.SetRange(lvngProfileLineType, lvngCommissionJournalLine.lvngProfileLineType::lvngPeriodLevel);
            if lvngCommissionJournalLine.FindSet() then begin
                repeat
                    lvngExcelBuffer.NewRow();
                    lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngDimensionValue.lvngAdditionalCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngName, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngCostCenterCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionJournalLine.lvngDescription, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(format(lvngCommissionJournalLine.lvngManualAdjustment), false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionJournalLine.lvngIdentifierCode, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionJournalLine.lvngLoanNo, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionJournalLine.lvngCommissionAmount, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Number);
                until lvngCommissionJournalLine.Next() = 0;
            end;
            lvngCommissionValueEntry.Reset();
            lvngCommissionValueEntry.SetRange(lvngProfileCode, lvngCommissionProfile.lvngCode);
            lvngCommissionValueEntry.SetFilter(lvngCommissionDate, lvngDateFilter);
            if lvngPeriodIdentifierFilter <> '' then
                lvngCommissionValueEntry.SetFilter(lvngPeriodIdentifierCode, lvngPeriodIdentifierFilter);
            lvngCommissionValueEntry.SetRange(lvngProfileLineType, lvngCommissionValueEntry.lvngProfileLineType::lvngPeriodLevel);
            if lvngCommissionValueEntry.FindSet() then begin
                repeat
                    lvngExcelBuffer.NewRow();
                    lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngDimensionValue.lvngAdditionalCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngName, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngCostCenterCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionValueEntry.lvngDescription, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(format(lvngCommissionValueEntry.lvngManualAdjustment), false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionValueEntry.lvngIdentifierCode, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionValueEntry.lvngLoanNo, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
                    lvngExcelBuffer.AddColumn(lvngCommissionValueEntry.lvngCommissionAmount, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Number);
                until lvngCommissionValueEntry.Next() = 0;
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
        LoanVisionSetup: Record lvngLoanVisionSetup;
        lvngPeriodIdentifier: Record lvngPeriodIdentifier;
        lvngCommissionProfile: Record lvngCommissionProfile;
        lvngDimensionValue: Record "Dimension Value";
        lvngExcelBuffer: Record "Excel Buffer" temporary;
        FilterHelperTriggers: Codeunit "Filter Helper Triggers";
        lvngProcessingDialog: Dialog;
        lvngCounter: Integer;
        lvngDateFilter: Text;
        lvngPeriodIdentifierFilter: Text;
        lblLoanOfficerCode: Label 'Loan Officer Code';
        lblLoanOfficerName: Label 'Loan Officer Name';
        lblPayrollID: Label 'Payroll ID';
        lblCostCenterCode: Label 'Cost Center Code';
        lblExcelSheetName: Label 'Export';
        lblDescription: Label 'Description';
        lblIdentifierCode: Label 'Identifier Code';
        lblLoanNo: Label 'Loan No.';
        lblManualEntry: Label 'Manual Entry';
        lblAmount: Label 'Amount';
        lblProcessingDialog: Label 'Processing #1######## of #2##########';
}