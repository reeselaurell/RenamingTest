report 14135153 "lvnForm1098Print"
{
    Caption = 'Form 1098 Print';
    DefaultLayout = RDLC;
    RDLCLayout = 'Modules\1098\Reports\Layouts\Rep14135153.rdl';

    dataset
    {
        dataitem(RequestEntry; lvnForm1098Entry)
        {
            UseTemporary = true;
            RequestFilterFields = "Loan No.";

            trigger OnPreDataItem()
            begin
                CurrReport.Skip();
            end;
        }
        dataitem(Loop; Integer)
        {
            DataItemTableView = sorting(Number);

            column(LenderNameBox; LenderNameBox) { }
            column(LenderEIN; LenderEIN) { }
            column(LoanNo1; Form1098Entry1."Loan No.") { }
            column(BorrowerSSN1; BorrowerSSN1) { }
            column(BorrowerAddr11; BorrowerAddr1[1]) { }
            column(BorrowerAddr12; BorrowerAddr1[2]) { }
            column(BorrowerAddr13; BorrowerAddr1[3]) { }
            column(BorrowerAddr14; BorrowerAddr1[4]) { }
            column(BorrowerAddr15; BorrowerAddr1[5]) { }
            column(Box11; Form1098Entry1."Box 1") { }
            column(Box12; Form1098Entry1."Box 2") { }
            column(Box13; Form1098Entry1."Box 3") { }
            column(Box14; Form1098Entry1."Box 4") { }
            column(Box15; Form1098Entry1."Box 5") { }
            column(Box16; Form1098Entry1."Box 6") { }
            column(Box17; Form1098Entry1."Box 7") { }
            column(Box18; Form1098Entry1."Box 8") { }
            column(Box19; Form1098Entry1."Box 9") { }
            column(Box110; Form1098Entry1."Box 10") { }
            column(LoanNo2; Form1098Entry1."Loan No.") { }
            column(BorrowerSSN2; BorrowerSSN2) { }
            column(BorrowerAddr21; BorrowerAddr2[1]) { }
            column(BorrowerAddr22; BorrowerAddr2[2]) { }
            column(BorrowerAddr23; BorrowerAddr2[3]) { }
            column(BorrowerAddr24; BorrowerAddr2[4]) { }
            column(BorrowerAddr25; BorrowerAddr2[5]) { }
            column(Box21; Form1098Entry2."Box 1") { }
            column(Box22; Form1098Entry2."Box 2") { }
            column(Box23; Form1098Entry2."Box 3") { }
            column(Box24; Form1098Entry2."Box 4") { }
            column(Box25; Form1098Entry2."Box 5") { }
            column(Box26; Form1098Entry2."Box 6") { }
            column(Box27; Form1098Entry2."Box 7") { }
            column(Box28; Form1098Entry2."Box 8") { }
            column(Box29; Form1098Entry2."Box 9") { }
            column(Box210; Form1098Entry2."Box 10") { }

            trigger OnPreDataItem()
            begin
                BaseForm1098Entry.SetView(RequestEntry.GetView());
                BaseForm1098Entry.SetRange("Not Eligible", false);
                Loop.Reset();
                Loop.SetRange(Number, 1, (BaseForm1098Entry.Count() div 2) + 1);
            end;

            trigger OnAfterGetRecord()
            var
                FormatAddress: Codeunit "Format Address";
                Addr1: Text[50];
                Addr2: Text[50];
                MaxLen: Integer;
            begin
                if Number = 1 then
                    BaseForm1098Entry.FindSet()
                else
                    BaseForm1098Entry.Next();
                MaxLen := MaxStrLen(Addr1);
                Form1098Entry1 := BaseForm1098Entry;
                if EncryptSSN then
                    BorrowerSSN1 := StrSubstNo(SSNMaskTxt, CopyStr(Form1098Entry1."Borrower SSN", StrLen(Form1098Entry1."Borrower SSN") - 3))
                else
                    BorrowerSSN1 := Form1098Entry1."Borrower SSN";
                if StrLen(Form1098Entry1."Borrower Mailing Address") > MaxLen then begin
                    Addr1 := CopyStr(Form1098Entry1."Borrower Mailing Address", 1, MaxLen);
                    Addr2 := CopyStr(Form1098Entry1."Borrower Mailing Address", MaxLen + 1, MaxStrLen(Addr2));
                end else begin
                    Addr1 := Form1098Entry1."Borrower Mailing Address";
                    Addr2 := '';
                end;
                FormatAddress.FormatAddr(BorrowerAddr1, Form1098Entry1."Borrower Name", '', '', Addr1, Addr2, Form1098Entry1."Borrower Mailing City", Form1098Entry1."Borrower ZIP Code", Form1098Entry1."Borrower State", '');
                CompressArray(BorrowerAddr1);
                if BaseForm1098Entry.Next() <> 0 then begin
                    Form1098Entry2 := BaseForm1098Entry;
                    if EncryptSSN then
                        BorrowerSSN2 := StrSubstNo(SSNMaskTxt, CopyStr(Form1098Entry2."Borrower SSN", StrLen(Form1098Entry2."Borrower SSN") - 3))
                    else
                        BorrowerSSN2 := Form1098Entry2."Borrower SSN";
                    if StrLen(Form1098Entry2."Borrower Mailing Address") > MaxLen then begin
                        Addr1 := CopyStr(Form1098Entry2."Borrower Mailing Address", 1, MaxLen);
                        Addr2 := CopyStr(Form1098Entry2."Borrower Mailing Address", MaxLen + 1, MaxStrLen(Addr2));
                    end else begin
                        Addr1 := Form1098Entry2."Borrower Mailing Address";
                        Addr2 := '';
                    end;
                    FormatAddress.FormatAddr(BorrowerAddr2, Form1098Entry2."Borrower Name", '', '', Addr1, Addr2, Form1098Entry2."Borrower Mailing City", Form1098Entry2."Borrower ZIP Code", Form1098Entry2."Borrower State", '');
                    CompressArray(BorrowerAddr2);
                end else begin
                    Clear(Form1098Entry2);
                    BorrowerSSN2 := '';
                    Clear(BorrowerAddr2);
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(EncryptSSN; EncryptSSN) { ApplicationArea = All; Caption = 'Mask SSN Numbers'; }
                }
            }
        }
    }

    var
        LenderBoxTxt: Label '%1, %2 %3%4%5, %6, US%7%8, %9';
        SSNMaskTxt: Label '***-**-%1';
        CompanyInformation: Record "Company Information";
        BaseForm1098Entry: Record lvnForm1098Entry;
        Form1098Entry1: Record lvnForm1098Entry temporary;
        Form1098Entry2: Record lvnForm1098Entry temporary;
        EncryptSSN: Boolean;
        LenderNameBox: Text;
        LenderEIN: Text;
        BorrowerSSN1: Text;
        BorrowerSSN2: Text;
        BorrowerAddr1: array[8] of Text;
        BorrowerAddr2: array[8] of Text;

    trigger OnPreReport()
    var
        NewLine: Text[2];
    begin
        CompanyInformation.Get();
        NewLine := '  ';
        NewLine[1] := 13;
        NewLine[2] := 10;

        LenderNameBox := StrSubstNo(LenderBoxTxt, CompanyInformation.Name, CompanyInformation.Address, CompanyInformation."Address 2", NewLine, CompanyInformation.City, CompanyInformation.County, NewLine, CompanyInformation."Post Code", CompanyInformation."Phone No.");
        LenderEIN := CompanyInformation."Federal ID No.";
    end;
}