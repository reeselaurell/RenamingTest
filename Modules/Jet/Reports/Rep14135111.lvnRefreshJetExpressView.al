report 14135111 "lvnRefreshJetExpressView"
{
    Caption = 'Refresh Jet Express View';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(ViewCode; ViewCode) { Caption = 'View Code'; ApplicationArea = All; TableRelation = lvnLoanNormalizedViewSetup; }
            }
        }
    }

    trigger OnPreReport()
    var
        JetExpressViewMgmt: Codeunit lvnJetExpressViewMgmt;
        ConfirmContinueMsg: Label 'This procedure will erase previously generated Analysis entries. Do you want to continue?';
    begin
        if Confirm(ConfirmContinueMsg, false) then
            JetExpressViewMgmt.RefreshJetExpressView(ViewCode);
    end;

    var
        ViewCode: Code[20];

    procedure SetView(RefreshViewCode: Code[20])
    begin
        ViewCode := RefreshViewCode;
    end;
}