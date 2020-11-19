report 14135311 lvnGrossCommissionExport
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
                group(Options)
                {
                    field(DateFilterField; DateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Date Filter';

                        trigger OnValidate()
                        begin
                            FilterTokens.MakeDateFilter(DateFilter);
                        end;
                    }

                    field(PeriodIdentifierFilterField; PeriodIdentifierFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Period Identifier Filter';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, PeriodIdentifier) = Action::LookupOK then
                                PeriodIdentifierFilter := Text + PeriodIdentifier.Code;
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        LoanVisionSetup.Get();
        TempExcelBuffer.AddColumn(LoanOfficerCodeLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PayrollIDLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(LoanOfficerNameLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CostCenterCodeLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(GrossCommissionsLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CommissionsPaidLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CommissionsDueLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        CommissionProfile.Reset();
        CommissionProfile.FindSet();
        if GuiAllowed() then begin
            ProcessingDialog.Open(ProcessingDialogMsg);
            ProcessingDialog.Update(2, CommissionProfile.Count());
        end;
        repeat
            Counter := Counter + 1;
            if GuiAllowed() then
                ProcessingDialog.Update(1, Counter);
            TempExcelBuffer.NewRow();
            Clear(CommissionDue);
            Clear(CommissionPaid);
            Clear(GrossCommission);
            CommissionJournalLine.Reset();
            CommissionJournalLine.SetRange("Profile Code", CommissionProfile.Code);
            CommissionJournalLine.SetFilter("Commission Date", DateFilter);
            if PeriodIdentifierFilter <> '' then
                CommissionJournalLine.SetFilter("Period Identifier Code", PeriodIdentifierFilter);
            CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Loan Level");
            if CommissionJournalLine.FindSet() then
                repeat
                    CommissionDue := CommissionDue + CommissionJournalLine."Commission Amount";
                until CommissionJournalLine.Next() = 0;
            CommissionValueEntry.Reset();
            CommissionValueEntry.SetRange("Profile Code", CommissionProfile.Code);
            CommissionValueEntry.SetFilter("Commission Date", DateFilter);
            if PeriodIdentifierFilter <> '' then
                CommissionValueEntry.SetFilter("Period Identifier Code", PeriodIdentifierFilter);
            CommissionValueEntry.SetRange("Profile Line Type", CommissionValueEntry."Profile Line Type"::"Loan Level");
            if CommissionValueEntry.FindSet() then
                repeat
                    CommissionPaid := CommissionPaid + CommissionValueEntry."Commission Amount";
                until CommissionValueEntry.Next() = 0;
            GrossCommission := CommissionDue + CommissionPaid;
            DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", CommissionProfile.Code);
            TempExcelBuffer.AddColumn(CommissionProfile.Code, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(DimensionValue.lvnAdditionalCode, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(CommissionProfile.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(CommissionProfile."Cost Center Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(GrossCommission), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(CommissionPaid), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(CommissionDue), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        until CommissionProfile.Next() = 0;
        TempExcelBuffer.CreateNewBook(ExcelSheetNameLbl);
        TempExcelBuffer.WriteSheet(ExcelSheetNameLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();
        if GuiAllowed() then
            ProcessingDialog.Close();
    end;

    var
        CommissionJournalLine: Record lvnCommissionJournalLine;
        CommissionValueEntry: Record lvnCommissionValueEntry;
        LoanVisionSetup: Record lvnLoanVisionSetup;
        PeriodIdentifier: Record lvnPeriodIdentifier;
        CommissionProfile: Record lvnCommissionProfile;
        DimensionValue: Record "Dimension Value";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FilterTokens: Codeunit "Filter Tokens";
        ProcessingDialog: Dialog;
        CommissionDue: Decimal;
        CommissionPaid: Decimal;
        GrossCommission: Decimal;
        Counter: Integer;
        DateFilter: Text;
        PeriodIdentifierFilter: Text;
        LoanOfficerCodeLbl: Label 'Loan Officer Code';
        LoanOfficerNameLbl: Label 'Loan Officer Name';
        PayrollIDLbl: Label 'Payroll ID';
        CostCenterCodeLbl: Label 'Cost Center Code';
        GrossCommissionsLbl: Label 'Gross Commissions';
        CommissionsDueLbl: Label 'Commissions Due';
        CommissionsPaidLbl: Label ' Commissions Paid';
        ExcelSheetNameLbl: Label 'Export';
        ProcessingDialogMsg: Label 'Processing #1######## of #2##########';
}