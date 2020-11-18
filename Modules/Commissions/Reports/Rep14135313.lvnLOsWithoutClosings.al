report 14135313 lvnLOsWithoutClosings
{
    Caption = 'Loan Officers w/o Closings';
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
        TempExcelBuffer.AddColumn(LoanOfficerCodeLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PayrollIDLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(LoanOfficerNameLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CostCenterCodeLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

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
            Clear(LoansExist);
            CommissionJournalLine.Reset();
            CommissionJournalLine.SetRange("Profile Code", CommissionProfile.Code);
            CommissionJournalLine.SetFilter("Commission Date", DateFilter);
            if PeriodIdentifierFilter <> '' then
                CommissionJournalLine.SetFilter("Period Identifier Code", PeriodIdentifierFilter);
            CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Loan Level");
            if not CommissionJournalLine.IsEmpty() then
                LoansExist := true;
            if not LoansExist then begin
                CommissionValueEntry.Reset();
                CommissionValueEntry.SetRange("Profile Code", CommissionProfile.Code);
                CommissionValueEntry.SetFilter("Commission Date", DateFilter);
                if PeriodIdentifierFilter <> '' then
                    CommissionValueEntry.SetFilter("Period Identifier Code", PeriodIdentifierFilter);
                CommissionValueEntry.SetRange("Profile Line Type", CommissionValueEntry."Profile Line Type"::"Loan Level");
                if not CommissionValueEntry.IsEmpty() then
                    LoansExist := true;
            end;
            if not LoansExist then begin
                DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", CommissionProfile.Code);
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(CommissionProfile.Code, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(DimensionValue.lvnAdditionalCode, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CommissionProfile.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CommissionProfile."Cost Center Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            end;
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
        Counter: Integer;
        DateFilter: Text;
        PeriodIdentifierFilter: Text;
        LoansExist: Boolean;
        LoanOfficerCodeLbl: Label 'Loan Officer Code';
        LoanOfficerNameLbl: Label 'Loan Officer Name';
        PayrollIDLbl: Label 'Payroll ID';
        CostCenterCodeLbl: Label 'Cost Center Code';
        ExcelSheetNameLbl: Label 'Export';
        ProcessingDialogMsg: Label 'Processing #1######## of #2##########';
}