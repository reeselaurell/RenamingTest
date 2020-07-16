page 14135261 lvngPayablesFinanceActivites
{
    PageType = CardPart;
    Caption = 'Finance Activities';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Group)
            {
                ShowCaption = false;

                field(OpenInvoices; OpenInvoicesCount())
                {
                    Caption = 'Open Invoices Today';
                    ApplicationArea = All;
                    ToolTip = 'Today''s Open Purchase Invoices Count';

                    trigger OnDrillDown()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        GetActSetup();
                        PurchHeader.Reset();
                        if ActSetup."Filter by User" <> '' then
                            PurchHeader.SetRange("Assigned User ID", UserName);
                        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
                        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
                        PurchHeader.SetRange("Document Date", CalcDate('CD'));
                        if PurchHeader.FindSet() then
                            Page.Run(Page::"Purchase Invoices", PurchHeader);
                    end;
                }

                field(OpenCrMemos; OpenCrMemoCount())
                {
                    Caption = 'Open Cr. Memos Today';
                    ApplicationArea = All;
                    ToolTip = 'Today''s Open Purchase Cr. Memos Count';

                    trigger OnDrillDown()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        GetActSetup();
                        PurchHeader.Reset();
                        if ActSetup."Filter by User" <> '' then
                            PurchHeader.SetRange("Assigned User ID", UserName);
                        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::"Credit Memo");
                        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
                        PurchHeader.SetRange("Document Date", CalcDate('CD'));
                        if PurchHeader.FindSet() then
                            Page.Run(Page::"Purchase Invoices", PurchHeader);
                    end;
                }

                field(PostedInvoices; PostedInvoicesCount())
                {
                    Caption = 'Posted Invoices Today';
                    ApplicationArea = All;
                    ToolTip = 'Purchase Invoices Posted Today Count';

                    trigger OnDrillDown()
                    var
                        PurchInvHdr: Record "Purch. Inv. Header";
                    begin
                        GetActSetup();
                        PurchInvHdr.Reset();
                        if ActSetup."Filter by User" <> '' then
                            PurchInvHdr.SetRange("User ID", UserName);
                        PurchInvHdr.SetRange("Posting Date", CalcDate('CD'));
                        if PurchInvHdr.FindSet() then
                            Page.Run(Page::"Posted Purchase Invoices", PurchInvHdr);
                    end;
                }

                field(PostedCrMemo; PostedCrMemoCount())
                {
                    Caption = 'Posted Cr. Memos Today';
                    ApplicationArea = All;
                    ToolTip = 'Purchase Cr. Memos Posted Today Count';

                    trigger OnDrillDown()
                    var
                        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                    begin
                        GetActSetup();
                        PurchCrMemoHdr.Reset();
                        if ActSetup."Filter by User" <> '' then
                            PurchCrMemoHdr.SetRange("User ID", UserName);
                        PurchCrMemoHdr.SetRange("Posting Date", CalcDate('CD'));
                        if PurchCrMemoHdr.FindSet() then
                            Page.Run(Page::"Posted Purchase Invoices", PurchCrMemoHdr);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActivitiesSetup)
            {
                Caption = 'Activities Setup';
                ApplicationArea = All;
                Image = SetupList;
                RunObject = page lvngPayablesFinActSetup;
            }
        }
    }

    var
        ActSetup: Record lvngPayablesFinActSetup;
        UserName: Code[50];

    local procedure OpenInvoicesCount(): Integer
    var
        PurchHeader: Record "Purchase Header";
        Today: Date;
    begin
        GetActSetup();
        PurchHeader.Reset();
        if ActSetup."Filter by User" <> '' then
            PurchHeader.SetRange("Assigned User ID", UserName);
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
        Today := CalcDate('CD');
        PurchHeader.SetRange("Document Date", Today);
        exit(PurchHeader.Count());
    end;

    local procedure OpenCrMemoCount(): Integer
    var
        PurchHeader: Record "Purchase Header";
    begin
        GetActSetup();
        PurchHeader.Reset();
        if ActSetup."Filter by User" <> '' then
            PurchHeader.SetRange("Assigned User ID", UserName);
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::"Credit Memo");
        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
        PurchHeader.SetRange("Document Date", CalcDate('CD'));
        exit(PurchHeader.Count());
    end;

    local procedure PostedInvoicesCount(): Integer
    var
        PurchInvHdr: Record "Purch. Inv. Header";
    begin
        PurchInvHdr.Reset();
        PurchInvHdr.SetRange("Posting Date", CalcDate('CD'));
        exit(PurchInvHdr.Count());
    end;

    local procedure PostedCrMemoCount(): Integer
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        PurchCrMemoHdr.Reset();
        PurchCrMemoHdr.SetRange("Posting Date", CalcDate('CD'));
        exit(PurchCrMemoHdr.Count());
    end;

    local procedure GetActSetup()
    var
        User: Record User;
    begin
        if ActSetup.Get() then begin
            if ActSetup."Filter by User" <> '' then
                if User.Get(ActSetup."Filter by User") then
                    UserName := User."User Name"
        end;
    end;
}