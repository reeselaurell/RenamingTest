page 14135262 "lvnPayablesApprovalActivities"
{
    PageType = CardPart;
    Caption = 'Approval Activities';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Group)
            {
                ShowCaption = false;

                field(InvoicesDueToday; InvoicesDueTodayCount())
                {
                    Caption = 'Invoices Due Today';
                    ApplicationArea = All;
                    ToolTip = 'Purchase Invoices Due Today Count';

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
                field(InvoicesPendingApproval; InvoicesPendingApprovalCount())
                {
                    Caption = 'Pending Approval';
                    ApplicationArea = All;
                    Visible = ApprovalsIDExists;
                    ToolTip = 'Purchase Invoices Pending Approval Count';

                    trigger OnDrillDown()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.Reset();
                        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
                        PurchHeader.SetRange(Status, PurchHeader.Status::"Pending Approval");
                        if PurchHeader.FindSet() then
                            Page.Run(Page::"Purchase Invoices", PurchHeader);
                    end;
                }
                field(ApprovedNotPosted; ApprovedNotPostedCount())
                {
                    Caption = 'Approved not Posted';
                    ApplicationArea = All;
                    Visible = ApprovalsIDExists;
                    ToolTip = 'Purchase Invoices Approved, but not Posted Count';

                    trigger OnDrillDown()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.Reset();
                        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
                        PurchHeader.SetRange(Status, PurchHeader.Status::Released);
                        if PurchHeader.FindSet() then
                            Page.Run(Page::"Purchase Invoices", PurchHeader);
                    end;
                }
                field(BlockedVendors; BlockedVendorsCount())
                {
                    Caption = 'Blocked Vendors';
                    ApplicationArea = All;
                    ToolTip = 'Blocked Vendors Count';

                    trigger OnDrillDown()
                    var
                        Vendor: Record Vendor;
                    begin
                        Vendor.Reset();
                        Vendor.SetRange(Blocked, Vendor.Blocked::All);
                        if Vendor.FindSet() then
                            Page.Run(Page::"Vendor List", Vendor);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CheckApprovals();
    end;

    var
        ApprovalsIDExists: Boolean;

    local procedure InvoicesDueTodayCount(): Integer
    var
        PurchInvHdr: Record "Purch. Inv. Header";
    begin
        PurchInvHdr.Reset();
        PurchInvHdr.SetRange("Due Date", CalcDate('CD'));
        exit(PurchInvHdr.Count());
    end;

    local procedure CheckApprovals()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset();
        UserSetup.SetRange("Approver ID", UserId);
        ApprovalsIDExists := UserSetup.FindFirst();
    end;

    local procedure ApprovedNotPostedCount(): Integer
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SetRange(Status, PurchHeader.Status::Released);
        exit(PurchHeader.Count());
    end;

    local procedure InvoicesPendingApprovalCount(): Integer
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SetRange(Status, PurchHeader.Status::"Pending Approval");
        exit(PurchHeader.Count());
    end;

    local procedure BlockedVendorsCount(): Integer
    var
        Vendor: Record Vendor;
    begin
        Vendor.Reset();
        Vendor.SetRange(Blocked, Vendor.Blocked::All);
        exit(Vendor.Count());
    end;
}