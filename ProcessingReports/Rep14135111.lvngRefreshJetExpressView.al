report 14135111 lvngRefreshJetExpressView
{
    Caption = 'Refresh Jet Express View';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(ViewCode; ViewCode) { Caption = 'View Code'; ApplicationArea = All; TableRelation = lvngLoanNormalizedViewSetup; }
            }
        }
    }

    var
        ViewCode: Code[20];

    trigger OnPreReport()
    var
        ConfirmContinueMsg: Label 'This procedure will erase previously generated Analysis entries. Do you want to continue?';
        JetExpressViewMgmt: Codeunit lvngJetExpressViewMgmt;
    begin
        if Confirm(ConfirmContinueMsg, false) then
            JetExpressViewMgmt.RefreshJetExpressView(ViewCode);
    end;

    procedure SetView(RefreshViewCode: Code[20])
    begin
        ViewCode := RefreshViewCode;
    end;
}