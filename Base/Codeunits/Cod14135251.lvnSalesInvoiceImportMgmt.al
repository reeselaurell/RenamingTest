codeunit 14135251 "lvnSalesInvoiceImportMgmt"
{
    var
        SalesInvImportLine2: Record lvnSalesInvLineBuffer;
        SalesInvImportLine3: Record lvnSalesInvLineBuffer;
        InvCreatedMsg: Label 'Invoice(s) Created';

    procedure ValidateDocuments(): Boolean
    var
        InvoiceErrorDetail: Record lvnInvoiceErrorDetail;
    begin
        InvoiceErrorDetail.Reset();
        exit(not InvoiceErrorDetail.FindSet());
    end;

    procedure CreateInvoices(
        var SalesHeaderBuffer: Record lvnSalesInvHdrBuffer;
        var SalesLineBuffer: Record lvnSalesInvLineBuffer;
        Post: Boolean)
    var
        SalesHeader: Record "Sales Header";
        TempSalesHeader: Record "Sales Header" temporary;
        SalesLine: Record "Sales Line";
        DocNo: Code[20];
        EmptyJnlErr: Label 'Sales Invoice Import Journal is empty';
    begin
        SalesHeaderBuffer.Reset();
        if SalesHeaderBuffer.FindSet() then begin
            repeat
                Clear(SalesHeader);
                SalesHeader.Init();
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader.Insert(true);
                SalesHeader.Validate("Posting Date", SalesHeaderBuffer."Posting Date");
                SalesHeader.Validate("Document Date", SalesHeaderBuffer."Document Date");
                SalesHeader.Validate("Due Date", SalesHeaderBuffer."Due Date");
                SalesHeader.Validate("Sell-to Customer No.", SalesHeaderBuffer."Bill-to Customer No.");
                SalesHeader.Validate("Payment Method Code", SalesHeaderBuffer."Payment Method Code");
                SalesHeader."Posting Description" := SalesHeaderBuffer."Posting Description";
                SalesHeader.Modify();
                Clear(TempSalesHeader);
                TempSalesHeader := SalesHeader;
                TempSalesHeader.Insert();
                SalesLineBuffer.Reset();
                SalesLineBuffer.SetRange("Document No.", SalesHeaderBuffer."No.");
                if SalesLineBuffer.FindSet() then
                    repeat
                        Clear(SalesLine);
                        SalesLine.Init();
                        SalesLine.Validate("Line No.", SalesLineBuffer."Line No.");
                        SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                        SalesLine.Validate("Document No.", SalesHeader."No.");
                        SalesLine.Insert();
                        SalesLine.Validate(Type, SalesLineBuffer.Type);
                        SalesLine.Validate("No.", SalesLineBuffer."No.");
                        SalesLine.Validate(Quantity, 1);
                        SalesLine."Unit Price" := SalesLineBuffer."Unit Price";
                        SalesLine.Description := SalesLineBuffer.Description;
                        SalesLine."Description 2" := SalesLineBuffer."Description 2";
                        SalesLine.Validate(lvnLoanNo, SalesLineBuffer."Loan No.");
                        SalesLine.Validate("Shortcut Dimension 1 Code", SalesLineBuffer."Shortcut Dimension 1 Code");
                        SalesLine.Validate("Shortcut Dimension 2 Code", SalesLineBuffer."Shortcut Dimension 2 Code");
                        SalesLine.ValidateShortcutDimCode(3, SalesLineBuffer."Shortcut Dimension 3 Code");
                        SalesLine.ValidateShortcutDimCode(4, SalesLineBuffer."Shortcut Dimension 4 Code");
                        SalesLine.ValidateShortcutDimCode(5, SalesLineBuffer."Shortcut Dimension 5 Code");
                        SalesLine.ValidateShortcutDimCode(6, SalesLineBuffer."Shortcut Dimension 6 Code");
                        SalesLine.ValidateShortcutDimCode(7, SalesLineBuffer."Shortcut Dimension 7 Code");
                        SalesLine.ValidateShortcutDimCode(8, SalesLineBuffer."Shortcut Dimension 8 Code");
                        //Business Unit Code
                        SalesLine.Modify();
                    until SalesLineBuffer.Next() = 0;
            until SalesHeaderBuffer.Next() = 0;
            if Post then begin
                TempSalesHeader.Reset();
                if TempSalesHeader.FindSet() then
                    repeat
                        SalesHeader.Get(TempSalesHeader."Document Type", TempSalesHeader."No.");
                        SalesHeader.SetRecFilter();
                        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
                    until TempSalesHeader.Next() = 0;
            end else
                Message(InvCreatedMsg);
            SalesHeaderBuffer.Reset();
            SalesLineBuffer.Reset();
            SalesHeaderBuffer.DeleteAll();
            SalesLineBuffer.DeleteAll();
        end else
            Error(EmptyJnlErr);
    end;

    procedure ValidateHeaderEntries(
        var SalesInvJnlError: Record lvnInvoiceErrorDetail;
        var SalesInvHdrBuffer: Record lvnSalesInvHdrBuffer)
    var
        Vendor: Record Vendor;
        PaymentMethod: Record "Payment Method";
        UserSetupMgmt: Codeunit "User Setup Management";
        PostingDateIsBlankErr: Label 'Posting Date is Blank';
        PostingDateIsNotValidErr: Label '%1 Posting Date is not within allowed date ranges';
        VendorNotFoundErr: Label 'Vendor with No.: %1 was not found in Vendor List';
        PaymentMethodNotFoundErr: Label 'Payment Method Code: %1 was not found in Payment Method Table';
    begin
        SalesInvHdrBuffer.Reset();
        if SalesInvHdrBuffer.FindSet() then
            repeat
                if SalesInvHdrBuffer."Posting Date" = 0D then
                    AddErrorLine(SalesInvJnlError, SalesInvHdrBuffer."No.", true, 0, PostingDateIsBlankErr)
                else
                    if not UserSetupMgmt.IsPostingDateValid(SalesInvHdrBuffer."Posting Date") then
                        AddErrorLine(SalesInvJnlError, SalesInvHdrBuffer."No.", true, 0, StrSubstNo(PostingDateIsNotValidErr, SalesInvHdrBuffer."Posting Date"));
                if not Vendor.Get(SalesInvHdrBuffer."Bill-to Customer No.") then
                    AddErrorLine(SalesInvJnlError, SalesInvHdrBuffer."No.", true, 0, StrSubstNo(VendorNotFoundErr, SalesInvHdrBuffer."Bill-to Customer No."));
                if SalesInvHdrBuffer."Payment Method Code" <> '' then
                    if not PaymentMethod.Get(SalesInvHdrBuffer."Payment Method Code") then
                        AddErrorLine(SalesInvJnlError, SalesInvHdrBuffer."No.", true, 0, StrSubstNo(PaymentMethodNotFoundErr, SalesInvHdrBuffer."Payment Method Code"));
            until SalesInvHdrBuffer.Next() = 0;
    end;

    procedure ValidateLineEntries(
        var SalesInvJnlError: Record lvnInvoiceErrorDetail;
        var SalesInvLineBuffer: Record lvnSalesInvLineBuffer)
    var
        Loan: Record lvnLoan;
        DimensionValue: Record "Dimension Value";
        AccountNoBlankOrMissingErr: Label 'Line %1: G/L Account is missing or blank';
        LoanNoMissingErr: Label 'Line %1: Loan No. is Missing';
        InvalidDimensionErr: Label 'Line %1: Dimension Value %2 does not exist for Dimension %3';
    begin
        SalesInvLineBuffer.Reset();
        if SalesInvLineBuffer.FindSet() then
            repeat
                if SalesInvLineBuffer."No." = '' then
                    AddErrorLine(SalesInvJnlError, SalesInvLineBuffer."Document No.", false, SalesInvLineBuffer."Line No.", StrSubstNo(AccountNoBlankOrMissingErr, SalesInvLineBuffer."Line No."));
                case SalesInvLineBuffer."Loan No. Validation" of
                    SalesInvLineBuffer."Loan No. Validation"::"Blank If Not Found":
                        if not Loan.Get(SalesInvLineBuffer."Loan No.") then begin
                            SalesInvLineBuffer."Loan No." := '';
                            SalesInvLineBuffer.Modify();
                        end;
                    SalesInvLineBuffer."Loan No. Validation"::Validate:
                        if not Loan.Get(SalesInvLineBuffer."Loan No.") then
                            AddErrorLine(SalesInvJnlError, SalesInvLineBuffer."Document No.", false, SalesInvLineBuffer."Line No.", StrSubstNo(LoanNoMissingErr, SalesInvLineBuffer."Line No."));
                end;
                if SalesInvLineBuffer."Shortcut Dimension 1 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 1);
                    DimensionValue.SetRange(Code, SalesInvLineBuffer."Shortcut Dimension 1 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(SalesInvJnlError, SalesInvLineBuffer."Document No.", false, SalesInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, SalesInvLineBuffer."Line No.", SalesInvLineBuffer."Shortcut Dimension 1 Code", Format(1)));
                end;
                if SalesInvLineBuffer."Shortcut Dimension 2 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 2);
                    DimensionValue.SetRange(Code, SalesInvLineBuffer."Shortcut Dimension 2 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(SalesInvJnlError, SalesInvLineBuffer."Document No.", false, SalesInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, SalesInvLineBuffer."Line No.", SalesInvLineBuffer."Shortcut Dimension 2 Code", Format(2)));
                end;
                if SalesInvLineBuffer."Shortcut Dimension 3 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 3);
                    DimensionValue.SetRange(Code, SalesInvLineBuffer."Shortcut Dimension 3 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(SalesInvJnlError, SalesInvLineBuffer."Document No.", false, SalesInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, SalesInvLineBuffer."Line No.", SalesInvLineBuffer."Shortcut Dimension 3 Code", Format(3)));
                end;
                if SalesInvLineBuffer."Shortcut Dimension 4 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 4);
                    DimensionValue.SetRange(Code, SalesInvLineBuffer."Shortcut Dimension 4 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(SalesInvJnlError, SalesInvLineBuffer."Document No.", false, SalesInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, SalesInvLineBuffer."Line No.", SalesInvLineBuffer."Shortcut Dimension 4 Code", Format(4)));
                end;
                if SalesInvLineBuffer."Shortcut Dimension 5 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 5);
                    DimensionValue.SetRange(Code, SalesInvLineBuffer."Shortcut Dimension 5 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(SalesInvJnlError, SalesInvLineBuffer."Document No.", false, SalesInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, SalesInvLineBuffer."Line No.", SalesInvLineBuffer."Shortcut Dimension 5 Code", Format(5)));
                end;
                if SalesInvLineBuffer."Shortcut Dimension 6 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 6);
                    DimensionValue.SetRange(Code, SalesInvLineBuffer."Shortcut Dimension 6 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(SalesInvJnlError, SalesInvLineBuffer."Document No.", false, SalesInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, SalesInvLineBuffer."Line No.", SalesInvLineBuffer."Shortcut Dimension 6 Code", Format(6)));
                end;
                if SalesInvLineBuffer."Shortcut Dimension 7 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 7);
                    DimensionValue.SetRange(Code, SalesInvLineBuffer."Shortcut Dimension 7 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(SalesInvJnlError, SalesInvLineBuffer."Document No.", false, SalesInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, SalesInvLineBuffer."Line No.", SalesInvLineBuffer."Shortcut Dimension 7 Code", Format(7)));
                end;
                if SalesInvLineBuffer."Shortcut Dimension 8 Code" <> '' then begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", 8);
                    DimensionValue.SetRange(Code, SalesInvLineBuffer."Shortcut Dimension 8 Code");
                    if not DimensionValue.FindFirst() then
                        AddErrorLine(SalesInvJnlError, SalesInvLineBuffer."Document No.", false, SalesInvLineBuffer."Line No.", StrSubstNo(InvalidDimensionErr, SalesInvLineBuffer."Line No.", SalesInvLineBuffer."Shortcut Dimension 8 Code", Format(8)));
                end;
            until SalesInvLineBuffer.Next() = 0;
        SalesInvLineBuffer.Reset();
        SalesInvLineBuffer.Reset();
    end;

    procedure GroupLines(
        var pSalesInvImportHdr: Record lvnSalesInvHdrBuffer;
        var pSalesInvImportLine: Record lvnSalesInvLineBuffer)
    var
        TotalAmount: Decimal;
        LineDescription: Text[250];
        FirstLine: Boolean;
        FirstLineNo: Integer;
        DocNo: Code[20];
        LineNo: Integer;
    begin
        pSalesInvImportLine.Reset();
        if pSalesInvImportLine.FindSet() then
            repeat
                SalesInvImportLine2 := pSalesInvImportLine;
                SalesInvImportLine3 := pSalesInvImportLine;
                SalesInvImportLine2.Insert();
                SalesInvImportLine3.Insert();
            until pSalesInvImportLine.Next() = 0;
        SalesInvImportLine2.Reset();
        if SalesInvImportLine2.FindSet() then
            repeat
                SalesInvImportLine3.Reset();
                SalesInvImportLine3.SetRange("Document No.", SalesInvImportLine2."Document No.");
                SalesInvImportLine3.SetRange("No.", SalesInvImportLine2."No.");
                SalesInvImportLine3.SetRange("Loan No.", SalesInvImportLine2."Loan No.");
                SalesInvImportLine3.SetRange("Shortcut Dimension 1 Code", SalesInvImportLine2."Shortcut Dimension 1 Code");
                SalesInvImportLine3.SetRange("Shortcut Dimension 2 Code", SalesInvImportLine2."Shortcut Dimension 2 Code");
                SalesInvImportLine3.SetRange("Shortcut Dimension 3 Code", SalesInvImportLine2."Shortcut Dimension 3 Code");
                SalesInvImportLine3.SetRange("Shortcut Dimension 4 Code", SalesInvImportLine2."Shortcut Dimension 4 Code");
                SalesInvImportLine3.SetRange("Shortcut Dimension 5 Code", SalesInvImportLine2."Shortcut Dimension 5 Code");
                SalesInvImportLine3.SetRange("Shortcut Dimension 6 Code", SalesInvImportLine2."Shortcut Dimension 6 Code");
                SalesInvImportLine3.SetRange("Shortcut Dimension 7 Code", SalesInvImportLine2."Shortcut Dimension 7 Code");
                SalesInvImportLine3.SetRange("Shortcut Dimension 8 Code", SalesInvImportLine2."Shortcut Dimension 8 Code");
                FirstLine := true;
                if SalesInvImportLine3.FindSet() then
                    if SalesInvImportLine3.Count > 1 then begin
                        DocNo := SalesInvImportLine3."Document No.";
                        repeat
                            TotalAmount += SalesInvImportLine3."Unit Price";
                            if FirstLine then begin
                                LineDescription := SalesInvImportLine3.Description + SalesInvImportLine3."Description 2";
                                FirstLine := false;
                                FirstLineNo := SalesInvImportLine3."Line No.";
                            end else begin
                                pSalesInvImportLine.Get(SalesInvImportLine3."Document No.", SalesInvImportLine3."Line No.");
                                pSalesInvImportLine.Delete();
                                SalesInvImportLine2.Get(SalesInvImportLine3."Document No.", SalesInvImportLine3."Line No.");
                                SalesInvImportLine2.Delete();
                            end;
                        until SalesInvImportLine3.Next() = 0;
                        pSalesInvImportLine.Reset();
                        pSalesInvImportLine.FindSet();
                        pSalesInvImportLine.Get(DocNo, FirstLineNo);
                        pSalesInvImportLine."Unit Price" := TotalAmount;
                        pSalesInvImportLine.Validate(Description, CopyStr(LineDescription, 1, MaxStrLen(pSalesInvImportLine.Description)));
                        pSalesInvImportLine.Validate("Description 2", CopyStr(LineDescription, 51, MaxStrLen(pSalesInvImportLine.Description)));
                        pSalesInvImportLine.Modify();
                        TotalAmount := 0;
                        DocNo := '';
                        LineDescription := '';
                    end;
            until SalesInvImportLine2.Next() = 0;
        pSalesInvImportHdr.Reset();
        if pSalesInvImportHdr.FindSet() then
            repeat
                pSalesInvImportLine.Reset();
                pSalesInvImportLine.SetRange("Document No.", pSalesInvImportHdr."No.");
                LineNo := 10000;
                if pSalesInvImportLine.FindSet() then
                    repeat
                        pSalesInvImportLine.Rename(pSalesInvImportHdr."No.", LineNo);
                        LineNo += 10000;
                    until pSalesInvImportLine.Next() = 0;
            until pSalesInvImportHdr.Next() = 0;
        pSalesInvImportLine.Reset();
    end;

    local procedure AddErrorLine(
        var SalesInvJnlError: Record lvnInvoiceErrorDetail;
        DocumentNo: Code[20];
        isHeader: Boolean;
        LineNo: Integer;
        ErrorTxt: Text)
    var
        ErrorNo: Integer;
    begin
        SalesInvJnlError.Reset();
        SalesInvJnlError.SetRange("Document No.", DocumentNo);
        SalesInvJnlError.SetRange("Header Error", isHeader);
        SalesInvJnlError.SetRange("Line No.", LineNo);
        ErrorNo := SalesInvJnlError.Count + 1;
        SalesInvJnlError.SetRange("Error Text", ErrorTxt);
        if not SalesInvJnlError.IsEmpty() then
            exit;
        Clear(SalesInvJnlError);
        SalesInvJnlError."Document No." := DocumentNo;
        SalesInvJnlError."Header Error" := isHeader;
        SalesInvJnlError."Line No." := LineNo;
        SalesInvJnlError."Error No." := ErrorNo;
        SalesInvJnlError."Error Text" := ErrorTxt;
        if SalesInvJnlError.Insert() then;
    end;
}