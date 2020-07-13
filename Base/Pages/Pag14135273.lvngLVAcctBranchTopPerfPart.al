page 14135273 lvngLVAcctBranchTopPerfPart
{
    Caption = 'Top Performing Branches';
    PageType = ListPart;
    SourceTable = lvngLVAcctRCHeadline;
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
                    Page.Run(Page::lvngAcctRCHeadlineSetup);
                end;
            }
            repeater(Group)
            {
                IndentationColumn = 0;

                field(Name; Name) { Caption = 'Name'; ApplicationArea = All; }
                field("Net Change"; "Net Change")
                {
                    Caption = 'Net Change';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        GLAccount: Record "G/L Account";
                        Headline: Record lvngLVAcctRCHeadline;
                    begin
                        GLAccount.Reset();
                        GLAccount.SetFilter("Date Filter", Headline.GetDateFilter("Dimension Code"));
                        Headline.SetGLAccountFilters(GLAccount, "Dimension Code", Code);
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
                    Reset();
                    SetCurrentKey("Net Change");
                    SetRange("Dimension Code", LoanVisionSetup."Cost Center Dimension Code");
                    Ascending(false);
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

    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        DateRange: Text;

    trigger OnOpenPage()
    var
        Headline: Record lvngLVAcctRCHeadline;
    begin
        DateRange := Headline.GetBranchInsightText();
        LoanVisionSetup.Get();
        ShowTopFive();
    end;

    local procedure ShowTopFive()
    var
        Counter: Integer;
    begin
        Reset();
        SetRange("Dimension Code", LoanVisionSetup."Cost Center Dimension Code");
        SetCurrentKey("Net Change");
        Ascending(false);
        FindSet();
        repeat
            Mark(true);
            Counter += 1;
            Next();
        until Counter = 5;
        MarkedOnly(true);
    end;
}