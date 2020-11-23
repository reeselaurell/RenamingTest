report 14135314 "lvnNetCommissionsExport"
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
                group(Options)
                {
                    field(CommissionScheduleNoField; CommissionScheduleNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Commission Schedule';
                        TableRelation = lvnCommissionSchedule."No.";

                        trigger OnValidate()
                        begin
                            if CommissionSchedule.Get(CommissionScheduleNo) then begin
                                DateFilter := StrSubstNo(DateFilterLbl, CommissionSchedule."Period Start Date", CommissionSchedule."Period End Date");
                                PeriodIdentifierFilter := CommissionSchedule."Period Identifier Code";
                            end;
                        end;
                    }
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
        CommissionSetup.Get();
        LoanVisionSetup.Get();
        TempExcelBuffer.AddColumn(LoanOfficerCodeLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PayrollIDLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(LoanOfficerNameLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CostCenterCodeLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CommissionSetup."Commission Identifier Code", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        AmountStartPosition := TempExcelBuffer.xlRowID;
        CommissionIdentifier.Reset();
        CommissionIdentifier.SetFilter(Code, '<>%1', CommissionSetup."Commission Identifier Code");
        if CommissionIdentifier.FindSet() then
            repeat
                TempExcelBuffer.AddColumn(CommissionIdentifier.Code, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until CommissionIdentifier.Next() = 0;
        TempExcelBuffer.AddColumn(TotalLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        CommissionProfile.Reset();
        CommissionProfile.FindSet();
        if GuiAllowed() then begin
            ProcessingDialog.Open(ProcessingDialogMsg);
            ProcessingDialog.Update(2, CommissionProfile.Count());
        end;
        repeat
            Counter := Counter + 1;
            Clear(EntryExist);
            Clear(CalculatedAmount);
            if GuiAllowed() then
                ProcessingDialog.Update(1, Counter);
            CommissionJournalLine.Reset();
            CommissionJournalLine.SetCurrentKey("Profile Code", "Commission Date", "Period Identifier Code", "Profile Line Type", "Identifier Code");
            CommissionJournalLine.SetRange("Profile Code", CommissionProfile.Code);
            CommissionJournalLine.SetFilter("Commission Date", DateFilter);
            if PeriodIdentifierFilter <> '' then
                CommissionJournalLine.SetFilter("Period Identifier Code", PeriodIdentifierFilter);
            CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Loan Level");
            if not CommissionJournalLine.IsEmpty() then
                EntryExist := true;
            CommissionJournalLine.SetRange("Identifier Code", CommissionSetup."Commission Identifier Code");
            CommissionJournalLine.CalcSums("Commission Amount");
            CalculatedAmount := CommissionJournalLine."Commission Amount";
            CommissionValueEntry.Reset();
            CommissionValueEntry.SetRange("Profile Code", CommissionProfile.Code);
            CommissionValueEntry.SetFilter("Commission Date", DateFilter);
            if PeriodIdentifierFilter <> '' then
                CommissionValueEntry.SetFilter("Period Identifier Code", PeriodIdentifierFilter);
            CommissionValueEntry.SetRange("Profile Line Type", CommissionValueEntry."Profile Line Type"::"Loan Level");
            if not CommissionValueEntry.IsEmpty() then
                EntryExist := true;
            CommissionValueEntry.SetRange("Identifier Code", CommissionSetup."Commission Identifier Code");
            CommissionValueEntry.CalcSums("Commission Amount");
            CalculatedAmount := CalculatedAmount + CommissionValueEntry."Commission Amount";
            if EntryExist then begin
                TempExcelBuffer.NewRow();
                DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", CommissionProfile.Code);
                TempExcelBuffer.AddColumn(CommissionProfile.Code, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(DimensionValue.lvnAdditionalCode, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CommissionProfile.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CommissionProfile."Cost Center Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CalculatedAmount, false, '', false, false, false, NumberFormatLbl, TempExcelBuffer."Cell Type"::Number);
                CommissionIdentifier.Reset();
                CommissionIdentifier.SetFilter(Code, '<>%1', CommissionSetup."Commission Identifier Code");
                if CommissionIdentifier.FindSet() then
                    repeat
                        Clear(CalculatedAmount);
                        CommissionJournalLine.SetRange("Identifier Code", CommissionIdentifier.Code);
                        CommissionJournalLine.CalcSums("Commission Amount");
                        CalculatedAmount := CommissionJournalLine."Commission Amount";
                        CommissionValueEntry.SetRange("Identifier Code", CommissionSetup."Commission Identifier Code");
                        CommissionValueEntry.CalcSums("Commission Amount");
                        CalculatedAmount := CalculatedAmount + CommissionValueEntry."Commission Amount";
                        TempExcelBuffer.AddColumn(CalculatedAmount, false, '', false, false, false, NumberFormatLbl, TempExcelBuffer."Cell Type"::Number);
                    until CommissionIdentifier.Next() = 0;
                TempExcelBuffer.SetFormula(StrSubstNo(SumFormulaLbl, AmountStartPosition, TempExcelBuffer.xlRowID, TempExcelBuffer.xlColID, TempExcelBuffer.xlRowID));
                Formula := TempExcelBuffer.GetFormula();
                TempExcelBuffer.AddColumn(Formula, true, '', false, false, false, NumberFormatLbl, TempExcelBuffer."Cell Type"::Number);
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
        CommissionSetup: Record lvnCommissionSetup;
        LoanVisionSetup: Record lvnLoanVisionSetup;
        PeriodIdentifier: Record lvnPeriodIdentifier;
        CommissionIdentifier: Record lvnCommissionIdentifier;
        CommissionProfile: Record lvnCommissionProfile;
        DimensionValue: Record "Dimension Value";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CommissionSchedule: Record lvnCommissionSchedule;
        FilterTokens: Codeunit "Filter Tokens";
        ProcessingDialog: Dialog;
        Counter: Integer;
        CommissionScheduleNo: Integer;
        DateFilter: Text;
        PeriodIdentifierFilter: Text;
        Formula: Text;
        EntryExist: Boolean;
        CalculatedAmount: Decimal;
        AmountStartPosition: Text;
        LoanOfficerCodeLbl: Label 'Loan Officer Code';
        LoanOfficerNameLbl: Label 'Loan Officer Name';
        PayrollIDLbl: Label 'Payroll ID';
        CostCenterCodeLbl: Label 'Cost Center Code';
        ExcelSheetNameLbl: Label 'Export';
        DateFilterLbl: Label '%1..%2', Comment = '%1 = Period Start Date; %2 = Period End Date';
        TotalLbl: Label 'Total';
        SumFormulaLbl: Label 'SUM(%1%2:%3%4)', Comment = '%1 = Starting Amount Position; %2 = Row ID; %3 = Col ID; %4 = Row ID';
        NumberFormatLbl: Label '0.00';
        ProcessingDialogMsg: Label 'Processing #1######## of #2##########', Comment = '#1 = Entry No.; #2 = Total Entries';
}