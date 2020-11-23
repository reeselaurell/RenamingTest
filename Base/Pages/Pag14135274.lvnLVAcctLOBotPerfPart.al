page 14135274 "lvnLVAcctLOBotPerfPart"
{
    Caption = 'Bottom Performing Loan Officers';
    PageType = ListPart;
    SourceTable = lvnLVAcctRCHeadline;
    InsertAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field(DateRange; DateRange)
            {
                Caption = 'Date Range';
                ApplicationArea = All;
                Editable = false;

                trigger OnDrillDown()
                begin
                    Page.Run(Page::lvnAcctRCHeadlineSetup);
                end;
            }
            repeater(Group)
            {
                IndentationColumn = 0;

                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field("Net Change"; Rec."Net Change")
                {
                    Caption = 'Net Change';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        GLAccount: Record "G/L Account";
                        Headline: Record lvnLVAcctRCHeadline;
                    begin
                        GLAccount.Reset();
                        GLAccount.SetFilter("Date Filter", Headline.GetDateFilter(Rec."Dimension Code"));
                        Headline.SetGLAccountFilters(GLAccount, Rec."Dimension Code", Rec.Code);
                        if GLAccount.FindSet() then
                            Page.Run(Page::"Chart of Accounts", GLAccount);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowAll)
            {
                Caption = 'Show All';
                ApplicationArea = All;
                Image = ClearFilter;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetCurrentKey("Net Change");
                    Rec.SetRange("Dimension Code", LoanVisionSetup."Loan Officer Dimension Code");
                    Rec.Ascending(true);
                    CurrPage.Update();
                end;
            }
            action(ShowTopFiveAction)
            {
                Caption = 'Show Top Five';
                ApplicationArea = All;
                Image = UseFilters;

                trigger OnAction()
                begin
                    ShowTopFive();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Headline: Record lvnLVAcctRCHeadline;
    begin
        DateRange := Headline.GetLOInsightText();
        LoanVisionSetup.Get();
        ShowTopFive();
    end;

    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        DateRange: Text;

    local procedure ShowTopFive()
    var
        Counter: Integer;
    begin
        Rec.Reset();
        Rec.SetRange("Dimension Code", LoanVisionSetup."Loan Officer Dimension Code");
        Rec.SetCurrentKey("Net Change");
        Rec.Ascending(true);
        Rec.FindSet();
        repeat
            Rec.Mark(true);
            Counter += 1;
            Rec.Next();
        until Counter = 5;
        Rec.MarkedOnly(true);
    end;
}