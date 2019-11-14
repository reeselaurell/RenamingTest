page 14135304 "lvngCommissionSchedules"
{
    Caption = 'Commission Schedules';
    PageType = Worksheet;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngCommissionSchedule;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                Editable = not lvngPeriodPosted;
                field(lvngNo; lvngNo)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngPeriodIdentifier; lvngPeriodIdentifier)
                {
                    ApplicationArea = All;
                    Visible = lvngShowPeriodColumn;
                }
                field(lvngPeriodName; lvngPeriodName)
                {
                    ApplicationArea = All;
                }
                field(lvngPeriodStartDate; lvngPeriodStartDate)
                {
                    ApplicationArea = All;
                }
                field(lvngPeriodEndDate; lvngPeriodEndDate)
                {
                    ApplicationArea = All;
                }
                field(lvngTotalBaseAmount; lvngTotalBaseAmount)
                {
                    Caption = 'Total Base Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngTotalUnits; lvngTotalUnits)
                {
                    Caption = 'Total Units';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngCommissionAmount; lvngCommissionAmount)
                {
                    Caption = 'Total Commission Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngQuarterCalculation; lvngQuarterCalculation)
                {
                    ApplicationArea = All;
                }
                field(lvngQuarterStartDate; lvngQuarterStartDate)
                {
                    ApplicationArea = All;
                }
                field(lvngQuarterEndDate; lvngQuarterEndDate)
                {
                    ApplicationArea = All;
                }
                field(lvngPeriodPosted; lvngPeriodPosted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngCalculateCommissions)
            {
                ApplicationArea = All;
                Caption = 'Calculate Commissions';
                Image = CalculateInventory;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction();
                var
                    lvngCalculateCommissions: Report lvngCalculateCommissions;
                begin
                    lvngCalculateCommissions.SetParams(lvngNo);
                    lvngCalculateCommissions.Run();
                end;
            }

            action(CommissionPrintout)
            {
                ApplicationArea = All;
                Caption = 'Printout';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CommissionPrintout: Report lvngCommissionPrintout;
                begin
                    CommissionPrintout.SetParams(lvngNo);
                    CommissionPrintout.Run();
                end;
            }

            action(lvngCommissionJournalLines)
            {
                ApplicationArea = All;
                Caption = 'Journal Lines';
                Image = CalculateLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page lvngCommissionJournalLines;
                RunPageLink = lvngScheduleNo = field(lvngNo);
            }

            action(lvngShowExcludedLoans)
            {
                ApplicationArea = All;
                Caption = 'List Excluded Loans';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                RunObject = report lvngCommissionExcludedLoans;
            }
            action(lvngGrossCommissionExport)
            {
                ApplicationArea = All;
                Caption = 'Gross Commission Export';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                RunObject = report lvngGrossCommissionExport;
            }
            action(lvngCommissionAdjustmentsExport)
            {
                ApplicationArea = All;
                Caption = 'Commission Adjustments Export';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                RunObject = report lvngCommissionAdjExport;
            }
            action(lvngLOsWOClosings)
            {
                ApplicationArea = All;
                Caption = 'Loan Officers w/o Closings';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                RunObject = report lvngLOsWithoutClosings;
            }

            action(lvngNetCommissionsExport)
            {
                ApplicationArea = All;
                Caption = 'Net Commissions Export';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                RunObject = report lvngNetCommissionsExport;
            }
        }
    }

    var
        lvngCommissionJournalLine: Record lvngCommissionJournalLine;
        lvngCommissionSetup: Record lvngCommissionSetup;
        lvngLoanCommissionBuffer: Record lvngLoanCommissionBuffer temporary;
        lvngBufferLineNo: Integer;
        lvngCommissionAmount: Decimal;
        lvngTotalUnits: Integer;
        lvngTotalBaseAmount: Decimal;
        lvngShowPeriodColumn: Boolean;
        lvngCommissionSetupRetrieved: Boolean;


    trigger OnInit()
    begin
        GetCommissionsSetup();
        lvngShowPeriodColumn := lvngCommissionSetup.lvngUsePeriodIdentifiers;
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(lvngCommissionAmount);
        Clear(lvngTotalUnits);
        Clear(lvngTotalBaseAmount);
        Clear(lvngBufferLineNo);
        lvngLoanCommissionBuffer.reset;
        lvngLoanCommissionBuffer.DeleteAll();
        lvngCommissionJournalLine.reset;
        lvngCommissionJournalLine.SetRange(lvngScheduleNo, lvngNo);
        if lvngCommissionJournalLine.FindSet() then begin
            repeat
                lvngLoanCommissionBuffer.SetRange(lvngLoanNo, lvngCommissionJournalLine.lvngLoanNo);
                if lvngLoanCommissionBuffer.IsEmpty then begin
                    lvngTotalBaseAmount := lvngTotalBaseAmount + lvngCommissionJournalLine.lvngBaseAmount;
                    lvngTotalUnits := lvngTotalUnits + 1;
                end;
                lvngCommissionAmount := lvngCommissionAmount + lvngCommissionJournalLine.lvngCommissionAmount;
            until lvngCommissionJournalLine.Next() = 0;
        end;
    end;

    local procedure GetCommissionsSetup()
    begin
        if not lvngCommissionSetupRetrieved then begin
            lvngCommissionSetupRetrieved := true;
            lvngCommissionSetup.Get();
        end;
    end;
}