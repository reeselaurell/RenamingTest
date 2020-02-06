page 14135185 lvngForm1098Loans
{
    Caption = 'Form 1098 Loans';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngForm1098Entry;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan No."; "Loan No.") { ApplicationArea = All; Caption = 'Loan No.'; }
                field("Borrower Name"; "Borrower Name") { ApplicationArea = All; Caption = 'Borrower Name'; }
                field("Borrower SSN"; "Borrower SSN") { ApplicationArea = All; Caption = 'Borrower SSN'; }
                field("Co-Borrower Name"; "Co-Borrower Name") { ApplicationArea = All; Caption = 'Co-Borrower Name'; }
                field("Co-Borrower SSN"; "Co-Borrower SSN") { ApplicationArea = All; Caption = 'Co-Borrower SSN'; }
                field("Borrower Mailing Address"; "Borrower Mailing Address") { ApplicationArea = All; Caption = 'Borrower Mailing Address'; }
                field("Borrower Mailing City"; "Borrower Mailing City") { ApplicationArea = All; Caption = 'Borrower Mailing City'; }
                field("Borrower State"; "Borrower State") { ApplicationArea = All; Caption = 'Borrower State'; }
                field("Borrower ZIP Code"; "Borrower ZIP Code") { ApplicationArea = All; Caption = 'Borrower ZIP Code'; }
                field("Borrower E-Mail"; "Borrower E-Mail") { ApplicationArea = All; Caption = 'Borrower E-Mail'; }
                field("Box 1"; "Box 1")
                {
                    ApplicationArea = All;
                    Caption = 'Box 1';
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        BoxAssistEdit(1);
                    end;
                }
                field("Box 2"; "Box 2")
                {
                    ApplicationArea = All;
                    Caption = 'Box 2';
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        BoxAssistEdit(2);
                    end;
                }
                field("Box 3"; "Box 3") { ApplicationArea = All; Caption = 'Box 3'; }
                field("Box 4"; "Box 4")
                {
                    ApplicationArea = All;
                    Caption = 'Box 4';
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        BoxAssistEdit(4);
                    end;
                }
                field("Box 5"; "Box 5")
                {
                    ApplicationArea = All;
                    Caption = 'Box 5';
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        BoxAssistEdit(5);
                    end;
                }
                field("Box 6"; "Box 6")
                {
                    ApplicationArea = All;
                    Caption = 'Box 6';
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        BoxAssistEdit(6);
                    end;
                }
                field("Box 7"; "Box 7") { ApplicationArea = All; Caption = 'Box 7'; }
                field("Box 8"; "Box 8") { ApplicationArea = All; Caption = 'Box 8'; }
                field("Box 9"; "Box 9") { ApplicationArea = All; Caption = 'Box 9'; }
                field("Box 10"; "Box 10")
                {
                    ApplicationArea = All;
                    Caption = 'Box 10';
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        BoxAssistEdit(10);
                    end;
                }
                field("Not Eligible"; "Not Eligible") { ApplicationArea = All; Caption = 'Not Eligible'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CollectLoans)
            {
                ApplicationArea = All;
                Caption = 'Collect Period Loans';
                Image = GetEntries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = report lvngGenerate1098LoanEntries;
            }

            action(CalculateAmounts)
            {
                ApplicationArea = All;
                Caption = 'Calculate Amounts';
                Image = Calculate;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = report lvngCalculate1098Values;
            }

            action(ExportPrintout)
            {
                ApplicationArea = All;
                Caption = 'Export for Printout';
                Image = ExportFile;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = xmlport lvngForm1098Export;
            }

            action(ExportIRS)
            {
                ApplicationArea = All;
                Caption = 'Export IRS Data';
                Image = Export;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = report Form1098MagneticMedia;
            }

            action(PrintForm)
            {
                ApplicationArea = All;
                Caption = 'Print 1098 Form';
                Image = Print;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = report lvngForm1098Print;
            }
        }
        area(Navigation)
        {
            action(LoanCard)
            {
                ApplicationArea = All;
                Caption = 'Loan Card';
                Image = Loaners;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page lvngLoanCard;
                RunPageView = sorting("No.");
                RunPageLink = "No." = field("Loan No.");
            }

            action(LedgerEntries)
            {
                ApplicationArea = All;
                Caption = 'General Ledger Entries';
                Image = GeneralLedger;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page "General Ledger Entries";
                RunPageView = sorting(lvngLoanNo);
                RunPageLink = lvngLoanNo = field("Loan No.");
            }
        }
    }

    local procedure BoxAssistEdit(BoxNo: Integer)
    var
        Form1098Details: Record lvngForm1098Details;
    begin
        Form1098Details.Reset();
        Form1098Details.SetRange("Loan No.", "Loan No.");
        Form1098Details.SetRange("Box No.", BoxNo);
        Page.Run(0, Form1098Details);
    end;
}