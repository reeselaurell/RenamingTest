page 14135206 lvngReverseSalesDocuments
{
    Caption = 'Reverse Sales Documents';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Sales Header";
    SourceTableTemporary = true;
    InsertAllowed = false;
    Permissions = TableData "G/L Entry" = rm, TableData "Cust. Ledger Entry" = rm, TableData "Sales Invoice Header" = rm, TableData "Sales Invoice Line" = rm, TableData "Sales Cr.Memo Header" = rm, TableData "Sales Cr.Memo Line" = rm;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type") { ApplicationArea = All; Editable = false; }
                field("No."; "No.") { ApplicationArea = All; Editable = false; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; Editable = false; }
                field(NewPostingDate; "Shipment Date")
                {
                    ApplicationArea = All;
                    Caption = 'New Posting Date';

                    trigger OnValidate()
                    begin
                        "Shipment Date" := "Shipment Date";
                    end;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.") { ApplicationArea = All; Editable = false; }
                field("Bill-to Customer No."; "Bill-to Customer No.") { ApplicationArea = All; Editable = false; }
                field("Bill-to Name"; "Bill-to Name") { ApplicationArea = All; Editable = false; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; Editable = false; }
                //Borrower Name
                field(ReverseTransaction; Correction) { ApplicationArea = All; Caption = 'Reverse Transaction'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetInvoices)
            {
                Caption = 'Get Invoices to Reverse';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = GetSourceDoc;

                trigger OnAction()
                var
                    FPBuilder: FilterPageBuilder;
                begin
                    Clear(SalesInvHeader);
                    FPBuilder.AddRecord(InvoiceDocTxt, SalesInvHeader);
                    FPBuilder.AddFieldNo(InvoiceDocTxt, 2);
                    FPBuilder.AddFieldNo(InvoiceDocTxt, 3);
                    FPBuilder.AddFieldNo(InvoiceDocTxt, 20);
                    FPBuilder.AddFieldNo(InvoiceDocTxt, 73);
                    FPBuilder.AddFieldNo(InvoiceDocTxt, 100);
                    FPBuilder.AddFieldNo(InvoiceDocTxt, 14135100);
                    // FPBuilder.AddFieldNo(InvoiceDocTxt, 14135102);
                    // FPBuilder.AddFieldNo(InvoiceDocTxt, 14135104);
                    if FPBuilder.RunModal() then begin
                        SalesInvHeader.Reset();
                        SalesInvHeader.SetView(FPBuilder.GetView(InvoiceDocTxt, false));
                        if SalesInvHeader.FindSet() then
                            repeat
                                Clear(Rec);
                                Rec.TransferFields(SalesInvHeader, false);
                                Rec."Document Type" := Rec."Document Type"::Invoice;
                                Rec."No." := SalesInvHeader."No.";
                                Rec."Shipment Date" := Rec."Posting Date";
                                if Rec.Insert() then;
                            until SalesInvHeader.Next() = 0;
                    end;
                end;
            }

            action(GetCreditMemos)
            {
                Caption = 'Get Credit Memos to Reverse';
                ApplicationArea = All;
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FPBuilder: FilterPageBuilder;
                begin
                    Clear(SalesCrMemoHeader);
                    FPBuilder.AddRecord(CrMemoDocTxt, SalesCrMemoHeader);
                    FPBuilder.AddFieldNo(CrMemoDocTxt, 2);
                    FPBuilder.AddFieldNo(CrMemoDocTxt, 3);
                    FPBuilder.AddFieldNo(CrMemoDocTxt, 20);
                    FPBuilder.AddFieldNo(CrMemoDocTxt, 73);
                    FPBuilder.AddFieldNo(CrMemoDocTxt, 100);
                    FPBuilder.AddFieldNo(CrMemoDocTxt, 14135100);
                    // FPBuilder.AddFieldNo(CrMemoDocTxt, 14135102);
                    // FPBuilder.AddFieldNo(CrMemoDocTxt, 14135104);
                    if FPBuilder.RunModal() then begin
                        SalesCrMemoHeader.Reset();
                        SalesCrMemoHeader.SetView(FPBuilder.GetView(CrMemoDocTxt, false));
                        if SalesCrMemoHeader.FindSet() then
                            repeat
                                Clear(Rec);
                                Rec.TransferFields(SalesCrMemoHeader, false);
                                Rec."Document Type" := Rec."Document Type"::"Credit Memo";
                                Rec."No." := SalesCrMemoHeader."No.";
                                Rec."Shipment Date" := Rec."Posting Date";
                                if Rec.Insert() then;
                            until SalesCrMemoHeader.Next() = 0;
                    end;
                end;
            }

            action(ReverseDocuments)
            {
                Caption = 'Reverse Selected Documents';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = PostBatch;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    CopyDocumentMgt: Codeunit "Copy Document Mgt.";
                    RecordsCount: Integer;
                    Progress: Dialog;
                    LoanNoLength: Integer;
                    LastSymbolOfLoanNo: Text;
                begin
                    Reset();
                    SetRange(Correction, true);
                    RecordsCount := 0;
                    if Count() > 10 then begin
                        GetLoanVisionSetup();
                        if not LoanVisionSetup."Maintenance Mode" then
                            Error(ReverseErr);
                    end;
                    Progress.Open(ProgressMsg);
                    if FindSet() then
                        repeat
                            RecordsCount := RecordsCount + 1;
                            Progress.Update(1, "No.");
                            if "Document Type" = "Document Type"::"Credit Memo" then begin
                                Clear(CopyDocumentMgt);
                                Clear(SalesHeader);
                                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                                SalesHeader.Insert(true);
                                CopyDocumentMgt.SetPropertiesForInvoiceCorrection(false);
                                CopyDocumentMgt.CopySalesDoc(9, "No.", SalesHeader);
                                SalesCrMemoHeader.Get("No.");
                                LoanNoLength := StrLen(SalesCrMemoHeader.lvngLoanNo);
                                LastSymbolOfLoanNo := CopyStr(SalesCrMemoHeader.lvngLoanNo, LoanNoLength, 1);
                                if LastSymbolOfLoanNo = 'X' then
                                    if not Confirm(ReverseConfirmMsg, false, "No.") then
                                        Error(CancelledErr);
                                SalesCrMemoHeader.lvngLoanNo := SalesCrMemoHeader.lvngLoanNo + 'X';
                                SalesCrMemoHeader.Modify();
                                SalesCrMemoLine.Reset();
                                SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
                                if SalesCrMemoLine.FindSet(true) then
                                    repeat
                                        if SalesCrMemoLine.lvngLoanNo <> '' then begin
                                            SalesCrMemoLine.lvngLoanNo := SalesCrMemoLine.lvngLoanNo + 'X';
                                            SalesCrMemoLine.Modify();
                                        end;
                                    until SalesCrMemoLine.Next() = 0;
                                GLEntry.Reset();
                                GLEntry.SetCurrentKey("Document No.", "Posting Date");
                                GLEntry.SetRange("Posting Date", "Posting Date");
                                GLEntry.SetFilter("Document Type", '%1|%2', GLEntry."Document Type"::"Credit Memo", GLEntry."Document Type"::Refund);
                                GLEntry.SetRange("Document No.", SalesCrMemoHeader."No.");
                                GLEntry.SetRange("Reason Code", "Reason Code");
                                if GLEntry.FindSet(true) then
                                    repeat
                                        if GLEntry.lvngLoanNo <> '' then begin
                                            GLEntry.lvngLoanNo := GLEntry.lvngLoanNo + 'X';
                                            GLEntry.Modify();
                                        end;
                                    until GLEntry.Next() = 0;
                                CustLedgEntry.Reset();
                                CustLedgEntry.SetRange("Document No.", SalesCrMemoHeader."No.");
                                CustLedgEntry.SetRange("Posting Date", "Posting Date");
                                CustLedgEntry.SetRange("Reason Code", "Reason Code");
                                if CustLedgEntry.FindSet(true) then
                                    repeat
                                        CustLedgEntry.lvngLoanNo := lvngLoanNo + 'X';
                                        CustLedgEntry.Modify();
                                    until CustLedgEntry.Next() = 0;
                            end;
                            if "Document Type" = "Document Type"::Invoice then begin
                                Clear(CopyDocumentMgt);
                                Clear(SalesHeader);
                                SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
                                SalesHeader.Insert(true);
                                CopyDocumentMgt.SetPropertiesForCreditMemoCorrection;
                                CopyDocumentMgt.CopySalesDoc(7, "No.", SalesHeader);
                                SalesInvHeader.Get("No.");
                                LoanNoLength := StrLen(SalesInvHeader.lvngLoanNo);
                                LastSymbolOfLoanNo := CopyStr(SalesInvHeader.lvngLoanNo, LoanNoLength, 1);
                                if LastSymbolOfLoanNo = 'X' then
                                    if not Confirm(ReverseConfirmMsg, false, "No.") then
                                        Error(CancelledErr);
                                SalesInvHeader.lvngLoanNo := SalesInvHeader.lvngLoanNo + 'X';
                                SalesInvHeader.Modify();
                                SalesInvLine.Reset();
                                SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
                                if SalesInvLine.FindSet(true) then
                                    repeat
                                        if SalesInvLine.lvngLoanNo <> '' then begin
                                            SalesInvLine.lvngLoanNo := SalesInvLine.lvngLoanNo + 'X';
                                            SalesInvLine.Modify();
                                        end;
                                    until SalesInvLine.Next() = 0;
                                GLEntry.Reset();
                                GLEntry.SetCurrentKey("Document No.", "Posting Date");
                                GLEntry.SetRange("Posting Date", "Posting Date");
                                GLEntry.SetFilter("Document Type", '%1|%2', GLEntry."Document Type"::Invoice, GLEntry."Document Type"::Payment);
                                GLEntry.SetRange("Document No.", SalesInvHeader."No.");
                                GLEntry.SetRange("Reason Code", "Reason Code");
                                if GLEntry.FindSet(true) then
                                    repeat
                                        if GLEntry.lvngLoanNo <> '' then begin
                                            GLEntry.lvngLoanNo := GLEntry.lvngLoanNo + 'X';
                                            GLEntry.Modify();
                                        end;
                                    until GLEntry.Next() = 0;
                                CustLedgEntry.Reset();
                                CustLedgEntry.SetRange("Document No.", SalesInvHeader."No.");
                                CustLedgEntry.SetRange("Posting Date", "Posting Date");
                                CustLedgEntry.SetRange("Reason Code", "Reason Code");
                                if CustLedgEntry.FindSet(true) then
                                    repeat
                                        CustLedgEntry.lvngLoanNo := lvngLoanNo + 'X';
                                        CustLedgEntry.Modify();
                                    until CustLedgEntry.Next() = 0;
                            end;
                            SalesHeader.lvngLoanNo := SalesHeader.lvngLoanNo + 'X';
                            SalesHeader.Modify();
                            SalesLine.Reset();
                            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                            SalesLine.SetRange("Document No.", SalesHeader."No.");
                            if SalesLine.FindSet(true) then
                                repeat
                                    if SalesLine.lvngLoanNo <> '' then begin
                                        SalesLine.lvngLoanNo := SalesLine.lvngLoanNo + 'X';
                                        SalesLine.Modify();
                                    end;
                                until SalesLine.Next() = 0;
                            SalesHeader.Invoice := true;
                            if "Posting Date" <> "Shipment Date" then begin
                                SalesHeader."Posting Date" := "Shipment Date";
                                SalesHeader.Modify();
                                SalesLine.Reset();
                                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                                SalesLine.SetRange("Document No.", SalesHeader."No.");
                                SalesLine.ModifyAll("Shipment Date", "Shipment Date");
                            end;
                            Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
                        until Next() = 0;
                    Progress.Close();
                    DeleteAll();
                    Reset();
                    CurrPage.Update(false);
                    Message(CompleteMsg, RecordsCount);
                end;
            }

            action(SetNewPostingDate)
            {
                Caption = 'Set New Posting Date';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ChangeDate;

                trigger OnAction()
                var
                    DateTimeDialog: page "Date-Time Dialog";
                    NewDate: Date;
                begin
                    Clear(DateTimeDialog);
                    DateTimeDialog.LookupMode(true);
                    if DateTimeDialog.RunModal() = Action::LookupOK then begin
                        NewDate := DT2Date(DateTimeDialog.GetDateTime());
                        if NewDate <> 0D then begin
                            Reset();
                            SetRange(Correction, true);
                            ModifyAll("Shipment Date", NewDate);
                            Reset();
                        end;
                    end;
                end;
            }
        }
    }

    var
        InvoiceDocTxt: Label 'Invoice Documents';
        CrMemoDocTxt: Label 'Credit Memo Documents';
        ProgressMsg: Label 'Document #1#############';
        CompleteMsg: Label '%1 Documents were reversed';
        ReverseConfirmMsg: Label '"%1" Document was already reversed. Do you want to reverse it once more ?';
        ReverseErr: Label 'You can''t reverse more than 10 documents at a time. Please contact System Administrator for Assistance.';
        CancelledErr: Label 'Cancelled by User!';
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        LoanVisionSetup: Record lvngLoanVisionSetup;
        LVSetupRetrieved: Boolean;

    local procedure GetLoanVisionSetup()
    begin
        if not LVSetupRetrieved then begin
            LVSetupRetrieved := true;
            LoanVisionSetup.Get();
        end;
    end;
}