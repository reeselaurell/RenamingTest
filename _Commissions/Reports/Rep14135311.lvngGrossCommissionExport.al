report 14135311 "lvngGrossCommissionExport"
{
    Caption = 'Gross Commissions Export';
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
        lvngExcelBuffer.AddColumn(lblGrossCommissions, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblCommissionsPaid, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);
        lvngExcelBuffer.AddColumn(lblCommissionsDue, false, '', true, false, false, '', lvngExcelBuffer."Cell Type"::Text);

        lvngCommissionProfile.Reset();
        lvngCommissionProfile.FindSet();
        if GuiAllowed then begin
            lvngProcessingDialog.Open(lblProcessingDialog);
            lvngProcessingDialog.Update(2, lvngCommissionProfile.Count);
        end;
        repeat
            lvngCounter := lvngCounter + 1;
            if GuiAllowed then
                lvngProcessingDialog.Update(1, lvngCounter);
            lvngExcelBuffer.NewRow();
            Clear(lvngCommissionDue);
            Clear(lvngCommissionPaid);
            Clear(lvngGrossCommission);
            lvngCommissionJournalLine.Reset();
            lvngCommissionJournalLine.SetRange(lvngProfileCode, lvngCommissionProfile.lvngCode);
            lvngCommissionJournalLine.SetFilter(lvngCommissionDate, lvngDateFilter);
            if lvngPeriodIdentifierFilter <> '' then
                lvngCommissionJournalLine.SetFilter(lvngPeriodIdentifierCode, lvngPeriodIdentifierFilter);
            lvngCommissionJournalLine.SetRange(lvngProfileLineType, lvngCommissionJournalLine.lvngProfileLineType::lvngLoanLevel);
            if lvngCommissionJournalLine.FindSet() then begin
                repeat
                    lvngCommissionDue := lvngCommissionDue + lvngCommissionJournalLine.lvngCommissionAmount;
                until lvngCommissionJournalLine.Next() = 0;
            end;
            lvngCommissionValueEntry.Reset();
            lvngCommissionValueEntry.SetRange(lvngProfileCode, lvngCommissionProfile.lvngCode);
            lvngCommissionValueEntry.SetFilter(lvngCommissionDate, lvngDateFilter);
            if lvngPeriodIdentifierFilter <> '' then
                lvngCommissionValueEntry.SetFilter(lvngPeriodIdentifierCode, lvngPeriodIdentifierFilter);
            lvngCommissionValueEntry.SetRange(lvngProfileLineType, lvngCommissionValueEntry.lvngProfileLineType::lvngLoanLevel);
            if lvngCommissionValueEntry.FindSet() then begin
                repeat
                    lvngCommissionPaid := lvngCommissionPaid + lvngCommissionValueEntry.lvngCommissionAmount;
                until lvngCommissionValueEntry.Next() = 0;
            end;
            lvngGrossCommission := lvngCommissionDue + lvngCommissionPaid;
            lvngDimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", lvngCommissionProfile.lvngCode);

            lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
            lvngExcelBuffer.AddColumn(lvngDimensionValue.lvngAdditionalCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
            lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngName, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
            lvngExcelBuffer.AddColumn(lvngCommissionProfile.lvngCostCenterCode, false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Text);
            lvngExcelBuffer.AddColumn(Format(lvngGrossCommission), false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Number);
            lvngExcelBuffer.AddColumn(Format(lvngCommissionPaid), false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Number);
            lvngExcelBuffer.AddColumn(Format(lvngCommissionDue), false, '', false, false, false, '', lvngExcelBuffer."Cell Type"::Number);
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
        lvngCommissionDue: Decimal;
        lvngCommissionPaid: Decimal;
        lvngGrossCommission: Decimal;
        lvngCounter: Integer;
        lvngDateFilter: Text;
        lvngPeriodIdentifierFilter: Text;
        lblLoanOfficerCode: Label 'Loan Officer Code';
        lblLoanOfficerName: Label 'Loan Officer Name';
        lblPayrollID: Label 'Payroll ID';
        lblCostCenterCode: Label 'Cost Center Code';
        lblGrossCommissions: Label 'Gross Commissions';
        lblCommissionsDue: Label 'Commissions Due';
        lblCommissionsPaid: Label ' Commissions Paid';
        lblExcelSheetName: Label 'Export';
        lblProcessingDialog: Label 'Processing #1######## of #2##########';
}