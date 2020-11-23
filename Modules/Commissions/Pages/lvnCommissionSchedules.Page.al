page 14135304 "lvnCommissionSchedules"
{
    Caption = 'Commission Schedules';
    PageType = Worksheet;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnCommissionSchedule;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                Editable = not Rec."Period Posted";

                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(PeriodIdentifierCode; Rec."Period Identifier Code")
                {
                    ApplicationArea = All;
                    Visible = ShowPeriodColumn;
                }
                field(PeriodName; Rec."Period Name")
                {
                    ApplicationArea = All;
                }
                field(PeriodStartDate; Rec."Period Start Date")
                {
                    ApplicationArea = All;
                }
                field(PeriodEndDate; Rec."Period End Date")
                {
                    ApplicationArea = All;
                }
                field(TotalBaseAmount; TotalBaseAmount)
                {
                    Caption = 'Total Base Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(TotalUnits; TotalUnits)
                {
                    Caption = 'Total Units';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CommissionAmount; CommissionAmount)
                {
                    Caption = 'Total Commission Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(MonthEndCalculation; Rec."Month End Calculation")
                {
                    ApplicationArea = All;
                }
                field(QuarterCalculation; Rec."Quarter Calculation")
                {
                    ApplicationArea = All;
                }
                field(QuarterStartDate; Rec."Quarter Start Date")
                {
                    ApplicationArea = All;
                }
                field(QuarterEndDate; Rec."Quarter End Date")
                {
                    ApplicationArea = All;
                }
                field(PeriodPosted; Rec."Period Posted")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CalculateCommissions)
            {
                ApplicationArea = All;
                Caption = 'Calculate Commissions';
                Image = CalculateInventory;

                trigger OnAction()
                var
                    CalculateCommissions: Report lvnCalculateCommissions;
                begin
                    CalculateCommissions.SetParams(Rec."No.");
                    CalculateCommissions.Run();
                end;
            }
            action(ImportAdjustments)
            {
                ApplicationArea = All;
                Caption = 'Import Adjustments';
                Image = Import;
                Visible = not Rec."Period Posted";
                RunObject = xmlport lvnCommissionAdjImport;
            }
            action(CommissionPrintout)
            {
                ApplicationArea = All;
                Caption = 'Printout';
                Image = PrintDocument;

                trigger OnAction()
                var
                    CommissionPrintout: Report lvnCommissionPrintout;
                begin
                    CommissionPrintout.SetParams(Rec."No.");
                    CommissionPrintout.Run();
                end;
            }
            action(CommissionPrintoutExport)
            {
                ApplicationArea = All;
                Caption = 'Export Printout';
                Image = Export;
                RunObject = report lvnCommissionPrintoutExport;
            }
            action(JournalView)
            {
                ApplicationArea = All;
                Caption = 'Journal View';
                Image = ConsumptionJournal;

                trigger OnAction()
                var
                    CommissionJournalView: Page lvnCommissionJournalView;
                begin
                    CommissionJournalView.SetParams(Rec."No.");
                    CommissionJournalView.Run();
                end;
            }
            action(CommissionJournalLines)
            {
                ApplicationArea = All;
                Caption = 'Journal Lines';
                Image = CalculateLines;
                RunObject = page lvnCommissionJournalLines;
                RunPageLink = "Schedule No." = field("No.");
            }
            action(ShowExcludedLoans)
            {
                ApplicationArea = All;
                Caption = 'List Excluded Loans';
                Image = ExportToExcel;
                RunObject = report lvnCommissionExcludedLoans;
            }
            action(GrossCommissionExport)
            {
                ApplicationArea = All;
                Caption = 'Gross Commission Export';
                Image = ExportToExcel;
                RunObject = report lvnGrossCommissionExport;
            }
            action(CommissionAdjustmentsExport)
            {
                ApplicationArea = All;
                Caption = 'Commission Adjustments Export';
                Image = ExportToExcel;
                RunObject = report lvnCommissionAdjExport;
            }
            action(LOsWOClosings)
            {
                ApplicationArea = All;
                Caption = 'Loan Officers w/o Closings';
                Image = ExportToExcel;
                RunObject = report lvnLOsWithoutClosings;
            }
            action(NetCommissionsExport)
            {
                ApplicationArea = All;
                Caption = 'Net Commissions Export';
                Image = ExportToExcel;
                RunObject = report lvnNetCommissionsExport;
            }
        }
    }

    trigger OnInit()
    begin
        CommissionSetup.Get();
        ShowPeriodColumn := CommissionSetup."Use Period Identifiers";
    end;

    trigger OnAfterGetRecord()
    var
        CommissionJournalLine: Record lvnCommissionJournalLine;
        CommissionValueEntry: Record lvnCommissionValueEntry;
        LoanLookup: Dictionary of [Text, Boolean];
    begin
        CommissionAmount := 0;
        TotalUnits := 0;
        TotalBaseAmount := 0;
        Clear(LoanLookup);
        if not Rec."Period Posted" then begin
            CommissionJournalLine.Reset();
            CommissionJournalLine.SetRange("Schedule No.", Rec."No.");
            if CommissionJournalLine.FindSet() then
                repeat
                    if CommissionJournalLine."Profile Line Type" = CommissionJournalLine."Profile Line Type"::"Loan Level" then
                        if not LoanLookup.ContainsKey(CommissionJournalLine."Loan No.") then begin
                            TotalBaseAmount += CommissionJournalLine."Base Amount";
                            TotalUnits += 1;
                            LoanLookup.Add(CommissionJournalLine."Loan No.", true);
                        end;
                    CommissionAmount += CommissionJournalLine."Commission Amount";
                until CommissionJournalLine.Next() = 0;
        end else begin
            CommissionValueEntry.Reset();
            CommissionValueEntry.SetRange("Schedule No.", Rec."No.");
            if CommissionValueEntry.FindSet() then
                repeat
                    if CommissionValueEntry."Profile Line Type" = CommissionValueEntry."Profile Line Type"::"Loan Level" then
                        if not LoanLookup.ContainsKey(CommissionValueEntry."Loan No.") then begin
                            TotalBaseAmount += CommissionValueEntry."Base Amount";
                            TotalUnits += 1;
                            LoanLookup.Add(CommissionValueEntry."Loan No.", true);
                        end;
                    CommissionAmount += CommissionValueEntry."Commission Amount";
                until CommissionValueEntry.Next() = 0;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CommissionAmount := 0;
        TotalUnits := 0;
        TotalBaseAmount := 0;
    end;

    var
        CommissionSetup: Record lvnCommissionSetup;
        CommissionAmount: Decimal;
        TotalUnits: Integer;
        TotalBaseAmount: Decimal;
        ShowPeriodColumn: Boolean;
}