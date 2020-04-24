page 14135165 lvngLoanLevelReporting
{
    Caption = 'Loan Level Reporting';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = lvngLoanReportingBuffer;
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan No."; "Loan No.") { ApplicationArea = All; }
                field("Alternative Loan No."; "Alternative Loan No.") { ApplicationArea = All; }
                field("Search Name"; "Search Name") { ApplicationArea = All; Width = 50; }
                field("Loan Amount"; "Loan Amount") { ApplicationArea = All; }
                field("Application Date"; "Application Date") { Visible = false; ApplicationArea = All; }
                field("Date Closed"; "Date Closed") { Visible = false; ApplicationArea = All; }
                field("Date Funded"; "Date Funded") { ApplicationArea = All; }
                field("Date Sold"; "Date Sold") { ApplicationArea = All; }
                field("Business Unit Code"; "Business Unit Code") { Visible = false; ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportFromFile)
            {
                Caption = 'Import Loans From File';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ImportLoanNumbers: XmlPort lvngImportLoanNumbers;
                begin
                    Clear(ImportLoanNumbers);
                    ImportLoanNumbers.Run();
                    ImportLoanNumbers.RetrieveData(Rec);
                end;
            }
            action(RetrieveFromLoanTable)
            {
                Caption = 'Get Filtered Loans';
                ApplicationArea = All;
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GetFilteredLoans: Report lvngGetFilteredLoans;
                begin
                    Clear(GetFilteredLoans);
                    GetFilteredLoans.RunModal();
                    GetFilteredLoans.RetrieveData(Rec);
                end;
            }
            action(RetrieveLoansWithActivity)
            {
                Caption = 'Get Loans with Activity';
                ApplicationArea = All;
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GetLoansWithActivity: Report lvngGetLoansWithActivity;
                begin
                    Clear(GetLoansWithActivity);
                    GetLoansWithActivity.RunModal();
                    GetLoansWithActivity.RetrieveData(Rec);
                end;
            }

            action(ClearLoans)
            {
                Caption = 'Clear List';
                ApplicationArea = All;
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    DeleteAll();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        DimensionManagement: Codeunit DimensionManagement;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;
}