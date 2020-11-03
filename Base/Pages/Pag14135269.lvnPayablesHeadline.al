page 14135269 "lvnPayablesHeadline"
{
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    Caption = 'Payables Headline';

    layout
    {
        area(Content)
        {
            group("Payables Headline")
            {
                Editable = false;

                field(WelcomeMsg; LoanVisionLbl) { ApplicationArea = All; }

                field(InvoicesDueToday; InvoicesDueTxt)
                {
                    Caption = 'Invoices Due Today';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        PurchInvHdr: Record "Purch. Inv. Header";
                    begin
                        PurchInvHdr.Reset();
                        PurchInvHdr.SetRange("Due Date", CalcDate('CD'));
                        if PurchInvHdr.FindSet() then
                            Page.Run(Page::"Posted Purchase Invoices", PurchInvHdr);
                    end;
                }
                field(OverdueApprovals; OverdueApprovalsTxt)
                {
                    Caption = 'Overdue Approvals';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Overdue Approval Entries");
                    end;
                }
            }
        }
    }

    var
        LoanVisionLbl: Label '<qualifier>Welcome</qualifier><payload>Welcome to Loan Vision</payload>';
        InvoicesDueTxt: Text;
        OverdueApprovalsTxt: Text;

    trigger OnOpenPage()
    var
        EntriesCount: Integer;
    begin
        InvoicesDueTxt := StrSubstNo('The Total Invoice Amount Due Today is $%1', InvoicesDueTodayAmount());
        EntriesCount := OverdueApprovalsCount();
        if EntriesCount = 1 then
            OverdueApprovalsTxt := StrSubstNo('There is %1 overdue Approval Entry', EntriesCount)
        else
            OverdueApprovalsTxt := StrSubstNo('There are %1 overdue Approval Entries', EntriesCount);
    end;

    local procedure InvoicesDueTodayAmount(): Decimal
    var
        PurchInvHdr: Record "Purch. Inv. Header";
        TtlAmount: Decimal;
    begin
        PurchInvHdr.Reset();
        PurchInvHdr.SetRange("Due Date", CalcDate('CD'));
        if PurchInvHdr.FindSet() then
            repeat
                PurchInvHdr.CalcFields(Amount);
                TtlAmount += PurchInvHdr.Amount;
            until PurchInvHdr.Next() = 0;
        exit(TtlAmount);
    end;

    local procedure OverdueApprovalsCount(): Integer
    var
        OverdueApprovalEntry: Record "Overdue Approval Entry";
    begin
        OverdueApprovalEntry.Reset();
        exit(OverdueApprovalEntry.Count());
    end;

}