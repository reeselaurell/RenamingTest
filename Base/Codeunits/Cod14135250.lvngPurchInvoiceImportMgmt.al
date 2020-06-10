codeunit 14135250 lvngPurchInvoiceImportMgmt
{
    var
        InvCreatedMsg: Label 'Invoice(s) Created';

    procedure ValidateDocuments(): Boolean
    var
        InvoiceErrorDetail: Record lvngInvoiceErrorDetail;
    begin
        InvoiceErrorDetail.Reset();
        exit(not InvoiceErrorDetail.FindSet());
    end;

    procedure CreateInvoices(Post: Boolean)
    var
        EmptyJnlErr: Label 'Purchase Invoice Import Journal is empty';
        PurchHeaderBuffer: Record lvngPurchInvHdrBuffer;
        PurchLineBuffer: Record lvngPurchInvLineBuffer;
        PurchaseHeader: Record "Purchase Header";
        TempPurchHeader: Record "Purchase Header" temporary;
        PurchaseLine: Record "Purchase Line";
        DocNo: Code[20];
    begin
        PurchHeaderBuffer.Reset();
        if PurchHeaderBuffer.FindSet() then begin
            repeat
                Clear(PurchaseHeader);
                PurchaseHeader.Init();
                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
                PurchaseHeader.Insert(true);
                PurchaseHeader.Validate("Posting Date", PurchHeaderBuffer."Posting Date");
                PurchaseHeader.Validate("Document Date", PurchHeaderBuffer."Document Date");
                PurchaseHeader.Validate("Due Date", PurchHeaderBuffer."Due Date");
                PurchaseHeader.Validate("Buy-from Vendor No.", PurchHeaderBuffer."Buy From Vendor No.");
                PurchaseHeader.Validate("Payment Method Code", PurchHeaderBuffer."Payment Method Code");
                PurchaseHeader."Posting Description" := PurchHeaderBuffer."Posting Description";
                PurchaseHeader."Vendor Invoice No." := PurchHeaderBuffer."No.";
                PurchaseHeader.Modify();
                Clear(TempPurchHeader);
                TempPurchHeader := PurchaseHeader;
                TempPurchHeader.Insert();
                PurchLineBuffer.Reset();
                PurchLineBuffer.SetRange("Document No.", PurchHeaderBuffer."No.");
                if PurchLineBuffer.FindSet() then
                    repeat
                        Clear(PurchaseLine);
                        PurchaseLine.Init();
                        PurchaseLine.Validate("Line No.", PurchLineBuffer."Line No.");
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Invoice;
                        PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
                        PurchaseLine.Insert();
                        PurchaseLine.Validate(Type, PurchLineBuffer.Type);
                        PurchaseLine.Validate("No.", PurchLineBuffer."No.");
                        PurchaseLine.Validate(Quantity, 1);
                        PurchaseLine."Direct Unit Cost" := PurchLineBuffer."Direct Unit Cost";
                        PurchaseLine.Description := PurchLineBuffer.Description;
                        PurchaseLine."Description 2" := PurchLineBuffer."Description 2";
                        PurchaseLine.Validate(lvngLoanNo, PurchLineBuffer."Loan No.");
                        PurchaseLine.Validate("Shortcut Dimension 1 Code", PurchLineBuffer."Shortcut Dimension 1 Code");
                        PurchaseLine.Validate("Shortcut Dimension 2 Code", PurchLineBuffer."Shortcut Dimension 2 Code");
                        PurchaseLine.ValidateShortcutDimCode(3, PurchLineBuffer."Shortcut Dimension 3 Code");
                        PurchaseLine.ValidateShortcutDimCode(4, PurchLineBuffer."Shortcut Dimension 4 Code");
                        PurchaseLine.ValidateShortcutDimCode(5, PurchLineBuffer."Shortcut Dimension 5 Code");
                        PurchaseLine.ValidateShortcutDimCode(6, PurchLineBuffer."Shortcut Dimension 6 Code");
                        PurchaseLine.ValidateShortcutDimCode(7, PurchLineBuffer."Shortcut Dimension 7 Code");
                        PurchaseLine.ValidateShortcutDimCode(8, PurchLineBuffer."Shortcut Dimension 8 Code");
                        //Business Unit Code
                        PurchaseLine.Modify();
                    until PurchLineBuffer.Next() = 0;
            until PurchHeaderBuffer.Next() = 0;
            if Post then begin
                TempPurchHeader.Reset();
                if TempPurchHeader.FindSet() then
                    repeat
                        PurchaseHeader.Get(TempPurchHeader."Document Type", TempPurchHeader."No.");
                        PurchaseHeader.SetRecFilter();
                        Codeunit.Run(Codeunit::"Purch.-Post", PurchaseHeader);
                    until TempPurchHeader.Next() = 0;
            end else
                Message(InvCreatedMsg);
            PurchHeaderBuffer.Reset();
            PurchLineBuffer.Reset();
            PurchHeaderBuffer.DeleteAll();
            PurchLineBuffer.DeleteAll();
        end else
            Error(EmptyJnlErr);
    end;

    procedure ValidateHeaderEntries()
    var
        PostingDateIsBlankErr: Label 'Posting Date is Blank';
        PostingDateIsNotValidErr: Label '%1 Posting Date is not within allowed date ranges';
        VendorNotFoundErr: Label 'Vendor with No.: %1 was not found in Vendor List';
        PaymentMethodNotFoundErr: Label 'Payment Method Code: %1 was not found in Payment Method Table';
        Vendor: Record Vendor;
        PaymentMethod: Record "Payment Method";
        PurchInvHdrBuffer: Record lvngPurchInvHdrBuffer;
        UserSetupMgmt: Codeunit "User Setup Management";
    begin
        PurchInvHdrBuffer.Reset();
        if PurchInvHdrBuffer.FindSet() then
            repeat
                if PurchInvHdrBuffer."Posting Date" = 0D then
                    AddErrorLine(PurchInvHdrBuffer."No.", true, 0, PostingDateIsBlankErr)
                else
                    if not UserSetupMgmt.IsPostingDateValid(PurchInvHdrBuffer."Posting Date") then
                        AddErrorLine(PurchInvHdrBuffer."No.", true, 0, StrSubstNo(PostingDateIsNotValidErr, PurchInvHdrBuffer."Posting Date"));
                if not Vendor.Get(PurchInvHdrBuffer."Buy From Vendor No.") then
                    AddErrorLine(PurchInvHdrBuffer."No.", true, 0, StrSubstNo(VendorNotFoundErr, PurchInvHdrBuffer."Buy From Vendor No."));
                if PurchInvHdrBuffer."Payment Method Code" <> '' then
                    if not PaymentMethod.Get(PurchInvHdrBuffer."Payment Method Code") then
                        AddErrorLine(PurchInvHdrBuffer."No.", true, 0, StrSubstNo(PaymentMethodNotFoundErr, PurchInvHdrBuffer."Payment Method Code"));
            until PurchInvHdrBuffer.Next() = 0;
    end;

    procedure ValidateLineEntries()
    var
        AccountNoBlankOrMissingErr: Label 'Line %1: G/L Account is missing or blank';
        LoanNoMissingErr: Label 'Line %1: Loan No. is Missing';
        InvalidDimensionErr: Label 'Line %1: Dimension Value %2 does not exist for Dimension %3';
        Loan: Record lvngLoan;
        PurchInvLineBuffer: Record lvngPurchInvLineBuffer;
        DimensionValue: Record "Dimension Value";
    begin
        PurchInvLineBuffer.Reset();
        if PurchInvLineBuffer.FindSet() then
            repeat
                if PurchInvLineBuffer."No." = '' then
                    AddErrorLine(PurchInvLineBuffer."Document No.", false, PurchInvLineBuffer."Line No.", StrSubstNo(AccountNoBlankOrMissingErr, PurchInvLineBuffer."Line No."));
                case PurchInvLineBuffer."Loan No. Validation" of
                    PurchInvLineBuffer."Loan No. Validation"::"Blank If Not Found":
                        if not Loan.Get(PurchInvLineBuffer."Loan No.") then begin
                            PurchInvLineBuffer."Loan No." := '';
                            PurchInvLineBuffer.Modify();
                        end;
                    PurchInvLineBuffer."Loan No. Validation"::Validate:
                        if not Loan.Get(PurchInvLineBuffer."Loan No.") then
                            AddErrorLine(PurchInvLineBuffer."Document No.", false, PurchInvLineBuffer."Line No.", StrSubstNo(LoanNoMissingErr, PurchInvLineBuffer."Line No."));
                end;
                if PurchInvLineBuffer."Shortcut Dimension 1 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 1);
                    DimensionValue.SetRange(Code, PurchInvLineBuffer."Shortcut Dimension 1 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(PurchInvLineBuffer."Document No.", false, PurchInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, PurchInvLineBuffer."Line No.", PurchInvLineBuffer."Shortcut Dimension 1 Code", Format(1)));
                end;
                if PurchInvLineBuffer."Shortcut Dimension 2 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 2);
                    DimensionValue.SetRange(Code, PurchInvLineBuffer."Shortcut Dimension 2 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(PurchInvLineBuffer."Document No.", false, PurchInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, PurchInvLineBuffer."Line No.", PurchInvLineBuffer."Shortcut Dimension 2 Code", Format(2)));
                end;
                if PurchInvLineBuffer."Shortcut Dimension 3 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 3);
                    DimensionValue.SetRange(Code, PurchInvLineBuffer."Shortcut Dimension 3 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(PurchInvLineBuffer."Document No.", false, PurchInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, PurchInvLineBuffer."Line No.", PurchInvLineBuffer."Shortcut Dimension 3 Code", Format(3)));
                end;
                if PurchInvLineBuffer."Shortcut Dimension 4 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 4);
                    DimensionValue.SetRange(Code, PurchInvLineBuffer."Shortcut Dimension 4 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(PurchInvLineBuffer."Document No.", false, PurchInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, PurchInvLineBuffer."Line No.", PurchInvLineBuffer."Shortcut Dimension 4 Code", Format(4)));
                end;
                if PurchInvLineBuffer."Shortcut Dimension 5 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 5);
                    DimensionValue.SetRange(Code, PurchInvLineBuffer."Shortcut Dimension 5 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(PurchInvLineBuffer."Document No.", false, PurchInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, PurchInvLineBuffer."Line No.", PurchInvLineBuffer."Shortcut Dimension 5 Code", Format(5)));
                end;
                if PurchInvLineBuffer."Shortcut Dimension 6 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 6);
                    DimensionValue.SetRange(Code, PurchInvLineBuffer."Shortcut Dimension 6 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(PurchInvLineBuffer."Document No.", false, PurchInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, PurchInvLineBuffer."Line No.", PurchInvLineBuffer."Shortcut Dimension 6 Code", Format(6)));
                end;
                if PurchInvLineBuffer."Shortcut Dimension 7 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 7);
                    DimensionValue.SetRange(Code, PurchInvLineBuffer."Shortcut Dimension 7 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(PurchInvLineBuffer."Document No.", false, PurchInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, PurchInvLineBuffer."Line No.", PurchInvLineBuffer."Shortcut Dimension 7 Code", Format(7)));
                end;
                if PurchInvLineBuffer."Shortcut Dimension 8 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 8);
                    DimensionValue.SetRange(Code, PurchInvLineBuffer."Shortcut Dimension 8 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(PurchInvLineBuffer."Document No.", false, PurchInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, PurchInvLineBuffer."Line No.", PurchInvLineBuffer."Shortcut Dimension 8 Code", Format(8)));
                end;
            until PurchInvLineBuffer.Next() = 0;
    end;

    local procedure AddErrorLine(DocumentNo: Code[20]; isHeader: Boolean; LineNo: Integer; ErrorTxt: Text)
    var
        PurchInvJnlError: Record lvngInvoiceErrorDetail;
        ErrorNo: Integer;
    begin
        PurchInvJnlError.Reset();
        PurchInvJnlError.SetRange("Document No.", DocumentNo);
        PurchInvJnlError.SetRange("Header Error", isHeader);
        PurchInvJnlError.SetRange("Line No.", LineNo);
        if PurchInvJnlError.FindSet() then;
        ErrorNo := PurchInvJnlError.Count + 1;
        PurchInvJnlError.SetRange("Error Text", ErrorTxt);
        if PurchInvJnlError.FindSet() then
            exit;
        Clear(PurchInvJnlError);
        PurchInvJnlError."Document No." := DocumentNo;
        PurchInvJnlError."Header Error" := isHeader;
        PurchInvJnlError."Line No." := LineNo;
        PurchInvJnlError."Error No." := ErrorNo;
        PurchInvJnlError."Error Text" := ErrorTxt;
        if PurchInvJnlError.Insert() then;
    end;

    procedure GroupLines()
    var
        PurchInvImportHdr: Record lvngPurchInvHdrBuffer;
        PurchInvImportLine: Record lvngPurchInvLineBuffer;
        PurchInvImportLine2: Record lvngPurchInvLineBuffer;
        PurchInvImportLine3: Record lvngPurchInvLineBuffer;
        TtlAmount: Decimal;
        LineDescription: Text[250];
        FirstLine: Boolean;
        FirstLineNo: Integer;
        DocNo: Code[20];
        LineNo: Integer;
    begin
        PurchInvImportLine2.Reset();
        if PurchInvImportLine2.FindSet() then
            repeat
                PurchInvImportLine3.Reset();
                PurchInvImportLine3.SetRange("Document No.", PurchInvImportLine2."Document No.");
                PurchInvImportLine3.SetRange("No.", PurchInvImportLine2."No.");
                PurchInvImportLine3.SetRange("Loan No.", PurchInvImportLine2."Loan No.");
                PurchInvImportLine3.SetRange("Shortcut Dimension 1 Code", PurchInvImportLine2."Shortcut Dimension 1 Code");
                PurchInvImportLine3.SetRange("Shortcut Dimension 2 Code", PurchInvImportLine2."Shortcut Dimension 2 Code");
                PurchInvImportLine3.SetRange("Shortcut Dimension 3 Code", PurchInvImportLine2."Shortcut Dimension 3 Code");
                PurchInvImportLine3.SetRange("Shortcut Dimension 4 Code", PurchInvImportLine2."Shortcut Dimension 4 Code");
                PurchInvImportLine3.SetRange("Shortcut Dimension 5 Code", PurchInvImportLine2."Shortcut Dimension 5 Code");
                PurchInvImportLine3.SetRange("Shortcut Dimension 6 Code", PurchInvImportLine2."Shortcut Dimension 6 Code");
                PurchInvImportLine3.SetRange("Shortcut Dimension 7 Code", PurchInvImportLine2."Shortcut Dimension 7 Code");
                PurchInvImportLine3.SetRange("Shortcut Dimension 8 Code", PurchInvImportLine2."Shortcut Dimension 8 Code");
                FirstLine := true;
                if PurchInvImportLine3.FindSet() then
                    if PurchInvImportLine3.Count > 1 then begin
                        DocNo := PurchInvImportLine3."Document No.";
                        repeat
                            TtlAmount += PurchInvImportLine3."Direct Unit Cost";
                            if FirstLine then begin
                                LineDescription := PurchInvImportLine3.Description + PurchInvImportLine3."Description 2";
                                FirstLine := false;
                                FirstLineNo := PurchInvImportLine3."Line No.";
                            end else begin
                                PurchInvImportLine.Get(PurchInvImportLine3."Document No.", PurchInvImportLine3."Line No.");
                                PurchInvImportLine.Delete();
                            end;
                        until PurchInvImportLine3.Next() = 0;
                        PurchInvImportLine.Get(DocNo, FirstLineNo);
                        PurchInvImportLine."Direct Unit Cost" := TtlAmount;
                        PurchInvImportLine.Validate(Description, CopyStr(LineDescription, 1, MaxStrLen(PurchInvImportLine.Description)));
                        PurchInvImportLine.Validate("Description 2", CopyStr(LineDescription, 51, MaxStrLen(PurchInvImportLine.Description)));
                        PurchInvImportLine.Modify();
                        TtlAmount := 0;
                        DocNo := '';
                        LineDescription := '';
                    end;
            until PurchInvImportLine2.Next() = 0;
        PurchInvImportHdr.Reset();
        if PurchInvImportHdr.FindSet() then
            repeat
                PurchInvImportLine.Reset();
                PurchInvImportLine.SetRange("Document No.", PurchInvImportHdr."No.");
                LineNo := 10000;
                if PurchInvImportLine.FindSet() then
                    repeat
                        PurchInvImportLine.Rename(PurchInvImportHdr."No.", LineNo);
                        LineNo += 10000;
                    until PurchInvImportLine.Next() = 0;
            until PurchInvImportHdr.Next() = 0;
    end;
}