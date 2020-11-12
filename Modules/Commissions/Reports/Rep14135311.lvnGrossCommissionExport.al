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
                    field(DateFilter; DateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Date Filter';

                        trigger OnValidate()
                        begin
                            FilterTokens.MakeDateFilter(DateFilter);
                        end;
                    }

                    field(PeriodIdentifierFilter; PeriodIdentifierFilter)
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
        ExcelBuffer.AddColumn(LoanOfficerCodeLbl, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PayrollIDLbl, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(LoanOfficerNameLbl, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CostCenterCodeLbl, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GrossCommissionsLbl, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CommissionsPaidLbl, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CommissionsDueLbl, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

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
            ExcelBuffer.NewRow();
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
            ExcelBuffer.AddColumn(CommissionProfile.Code, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(DimensionValue.lvnAdditionalCode, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CommissionProfile.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CommissionProfile."Cost Center Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(Format(GrossCommission), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(Format(CommissionPaid), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(Format(CommissionDue), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        until CommissionProfile.Next() = 0;
        ExcelBuffer.CreateNewBook(ExcelSheetNameLbl);
        ExcelBuffer.WriteSheet(ExcelSheetNameLbl, CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.OpenExcel();
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
        ExcelBuffer: Record "Excel Buffer" temporary;
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