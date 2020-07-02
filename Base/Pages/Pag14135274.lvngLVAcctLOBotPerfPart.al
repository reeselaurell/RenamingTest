page 14135274 lvngLVAcctLOBotPerfPart
{
    Caption = 'Bottom Performing Loan Officers';
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
                ShowCaption = false;

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

    var
        DateRange: Text;

    trigger OnOpenPage()
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        Headline: Record lvngLVAcctRCHeadline;
        Counter: Integer;
    begin
        LoanVisionSetup.Get();
        DateRange := Headline.GetLOInsightText();
        Reset();
        SetRange("Dimension Code", LoanVisionSetup."Loan Officer Dimension Code");
        SetCurrentKey("Net Change");
        Ascending(true);
        FindSet();
        repeat
            Mark(true);
            Counter += 1;
            Next();
        until Counter = 5;
        MarkedOnly(true);
    end;
}