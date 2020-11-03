report 14135106 "Form1098MagneticMedia"
{
    Caption = 'Form 1098 Magnetic Media';
    ProcessingOnly = true;

    dataset
    {
        dataitem("T Record"; Integer)
        {
            DataItemTableView = sorting(Number);
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                WriteTRec();
            end;
        }
        dataitem("A Record"; Integer)
        {
            DataItemTableView = sorting(Number);
            MaxIteration = 1;

            dataitem(FormEntry; lvnForm1098Entry)
            {
                DataItemTableView = sorting("Loan No.") where("Not Eligible" = const(false));
                RequestFilterFields = "Loan No.";

                trigger OnPreDataItem()
                begin
                    MagMediaManagement.ClearTotals();
                end;

                trigger OnAfterGetRecord()
                begin
                    MagMediaManagement.ClearAmts();
                    BorrowerName := CopyStr("Borrower Name", 1, MaxStrLen(BorrowerName));
                    BorrowerAddress := CopyStr("Borrower Mailing Address", 1, MaxStrLen(BorrowerAddress));
                    WriteBRec();
                end;
            }
            dataitem("C Record"; Integer)
            {
                DataItemTableView = sorting(Number);
                MaxIteration = 1;

                trigger OnAfterGetRecord()
                begin
                    WriteCRec();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CodeNos := '123456';
                PayeeNum := 0;
                if PayeeTotal > 0 then
                    WriteARec();
            end;
        }
        dataitem("F Record"; Integer)
        {
            DataItemTableView = sorting(Number);
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                WriteFRec();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(Year; Year)
                    {
                        Caption = 'Calendar Year';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if (Year < 1980) or (Year > 2080) then
                                Error(InvalidYearErr);
                        end;
                    }
                    field(TransCode; TransCode)
                    {
                        Caption = 'Transmitter Control Code';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TransCode = '' then
                                Error(InvalidTransCodeErr);
                        end;
                    }
                }
                group(Transmitter)
                {
                    Caption = 'Transmitter Information';

                    field(TransmitterInfo1; TransmitterInfo.Name) { Caption = 'Name'; ApplicationArea = All; }
                    field(TransmitterInfo2; TransmitterInfo.Address) { Caption = 'Street Address'; ApplicationArea = All; }
                    field(TransmitterInfo3; TransmitterInfo.City) { Caption = 'City'; ApplicationArea = All; }
                    field(TransmitterInfo4; TransmitterInfo.County) { Caption = 'State'; ApplicationArea = All; }
                    field(TransmitterInfo5; TransmitterInfo."Post Code") { Caption = 'ZIP Code'; ApplicationArea = All; }
                    field(TransmitterInfo6; TransmitterInfo."Federal ID No.") { Caption = 'Employer ID'; ApplicationArea = All; }
                    field(TransContactName; TransContactName)
                    {
                        Caption = 'Contact Name';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TransContactName = '' then
                                Error(InvalidTransContactNameErr);
                        end;
                    }
                    field(TransContactPhoneNo; TransContactPhoneNo)
                    {
                        Caption = 'Contact Phone No.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TransContactPhoneNo = '' then
                                Error(InvalidTransContactPhoneErr);
                        end;
                    }
                    field(TransContactEMail; TransContactEMail) { Caption = 'Contact E-Mail'; ApplicationArea = All; }
                }
                group(Vendor)
                {
                    Caption = 'Vendor Information';

                    field(VendIndicator; VendIndicator) { Caption = 'Vendor Indicator'; ApplicationArea = All; }
                    field(VendorInfo1; VendorInfo.Name)
                    {
                        Caption = 'Name';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if VendorInfo.Name = '' then
                                Error(MissingVendorInfoErr);
                        end;
                    }
                    field(VendorInfo2; VendorInfo.Address)
                    {
                        Caption = 'Street Address';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if VendorInfo.Address = '' then
                                Error(MissingVendorInfoErr);
                        end;
                    }
                    field(VendorInfo3; VendorInfo.City)
                    {
                        Caption = 'City';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if VendorInfo.City = '' then
                                Error(MissingVendorInfoErr);
                        end;
                    }
                    field(VendorInfo4; VendorInfo.County)
                    {
                        Caption = 'State';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if VendorInfo.County = '' then
                                Error(MissingVendorInfoErr);
                        end;
                    }
                    field(VendorInfo5; VendorInfo."Post Code")
                    {
                        Caption = 'ZIP Code';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if VendorInfo."Post Code" = '' then
                                Error(MissingVendorInfoErr);
                        end;
                    }
                    field(VendContactName; VendContactName)
                    {
                        Caption = 'Contact Name';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if VendContactName = '' then
                                Error(InvalidVendorContactNameErr);
                        end;
                    }
                    field(VendContactPhoneNo; VendContactPhoneNo)
                    {
                        Caption = 'Contact Phone No.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if VendContactPhoneNo = '' then
                                Error(InvalidVendorContactPhoneErr);
                        end;
                    }
                    field(VendContactEMail; VendContactEMail)
                    {
                        Caption = 'Contact E-Mail';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if VendorInfo.City = '' then
                                Error(MissingVendorInfoErr);
                        end;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            CompanyInfo.Get();
            TransmitterInfo := CompanyInfo;
            MagMediaManagement.EditCompanyInfo(CompanyInfo);
            MagMediaManagement.EditCompanyInfo(TransmitterInfo);
        end;
    }

    var
        ExportLbl: Label 'Export';
        AllFileFilterTxt: Label 'All Files (*.*)|*.*';
        DefaultFileNameTxt: Label '1098IRSTAX.txt';
        ProgressMsg: Label 'Exporting...\\Table    #1####################';
        InitialProgressTxt: Label 'IRSTAX';
        InvalidYearErr: Label 'You must enter a valid year, eg 2013.';
        InvalidTransCodeErr: Label 'You must enter the Transmitter Control Code assigned to you by the IRS.';
        InvalidTransContactNameErr: Label 'You must enter the name of the person to be contacted if IRS/MCC encounters problems with the file or transmission.';
        InvalidTransContactPhoneErr: Label 'You must enter the phone number of the person to be contacted if IRS/MCC encounters problems with the file or transmission.';
        MissingVendorInfoErr: Label 'You must enter all software vendor address information.';
        InvalidVendorContactNameErr: Label 'You must enter the name of the person to be contacted if IRS/MCC has any software questions.';
        InvalidVendorContactPhoneErr: Label 'You must enter the phone number of the person to be contacted if IRS/MCC has any software questions.';
        CompanyInfo: Record "Company Information";
        TransmitterInfo: Record "Company Information" temporary;
        VendorInfo: Record "Company Information" temporary;
        IRSBlob: Codeunit "Temp Blob";
        MagMediaManagement: Codeunit "A/P Magnetic Media Management";
        IRSData: OutStream;
        Progress: Dialog;
        TestFile: Text[1];
        PriorYear: Text[1];
        Year: Integer;
        TransCode: Code[5];
        TransContactName: Text;
        TransContactPhoneNo: Text;
        TransContactEMail: Text;
        VendIndicator: Enum lvnForm1098VendorIndicator;
        VendContactName: Text;
        VendContactPhoneNo: Text;
        VendContactEMail: Text;
        BorrowerName: Code[40];
        BorrowerAddress: Code[40];
        PayeeTotal: Integer;
        PayeeNum: Integer;
        ReturnType: Text[2];
        PayerNameControl: Text[4];
        CodeNos: Text[12];
        SequenceNo: Integer;
        Box1: Decimal;
        Box2: Decimal;
        Box4: Decimal;
        Box5: Decimal;
        Box6: Decimal;

    trigger OnInitReport()
    begin
        TestFile := ' ';
        PriorYear := ' ';
        SequenceNo := 0;
        ReturnType := '3 '; //TODO: Check this field, seems the value 3 was only for NOVA
        PayerNameControl := '    '; //TODO: Check this field, in version 140 it is fixed to 'NOVA' which is not appropriate
    end;

    trigger OnPreReport()
    begin
        if TransCode = '' then
            Error(InvalidTransCodeErr);
        if TransContactPhoneNo = '' then
            Error(InvalidTransContactPhoneErr);
        if TransContactName = '' then
            Error(InvalidTransContactNameErr);
        if VendContactName = '' then
            Error(InvalidVendorContactNameErr);
        if VendContactPhoneNo = '' then
            Error(InvalidVendorContactPhoneErr);
        if VendorInfo.Name = '' then
            Error(MissingVendorInfoErr);
        if VendorInfo.Address = '' then
            Error(MissingVendorInfoErr);
        if VendorInfo.City = '' then
            Error(MissingVendorInfoErr);
        if VendorInfo.County = '' then
            Error(MissingVendorInfoErr);
        if VendorInfo."Post Code" = '' then
            Error(MissingVendorInfoErr);
        if VendorInfo."E-Mail" = '' then
            Error(MissingVendorInfoErr);
        PayeeNum := 0;
        PayeeTotal := FormEntry.Count();
        MagMediaManagement.Run();
        IRSBlob.CreateOutStream(IRSData);
        Progress.Open(ProgressMsg);
        Progress.Update(1, InitialProgressTxt);
    end;

    trigger OnPostReport()
    var
        IStream: InStream;
        FileName: Text;
    begin
        Progress.Close();
        IRSBlob.CreateInStream(IStream);
        FileName := DefaultFileNameTxt;
        DownloadFromStream(IStream, ExportLbl, '', AllFileFilterTxt, FileName);
    end;

    local procedure WriteTRec()
    begin
        // T Record - 1 per transmission, 750 length
        SequenceNo += 1;
        IRSData.WriteText(
            StrSubstNo('T') +
            StrSubstNo('#1##', CopyStr(Format(Year), 1, 4)) +
            StrSubstNo(PriorYear) +   // Prior Year Indicator
            StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(TransmitterInfo."Federal ID No.")) +
            StrSubstNo('#1###', TransCode) + // Transmitter Control Code
            StrSubstNo('  ') +              // replacement character
            StrSubstNo('     ') +  // blank 5
            StrSubstNo(TestFile) +
            StrSubstNo(' ') +   // Foreign Entity Code
            StrSubstNo('#1##############################################################################', UpperCase(TransmitterInfo.Name)) +
            StrSubstNo('#1################################################', UpperCase(CompanyInfo.Name)) +
            StrSubstNo('                              ') +  // 2nd Payer Name
            StrSubstNo('#1######################################', UpperCase(CompanyInfo.Address)) +
            StrSubstNo('#1######################################', UpperCase(CompanyInfo.City)) +
            StrSubstNo('#1', CopyStr(CompanyInfo.County, 1, 2)) +
            StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(CompanyInfo."Post Code")) +
            StrSubstNo('               ') +  // blank 15
            StrSubstNo('#1######', MagMediaManagement.FormatAmount(PayeeTotal, 8)) +   // Payee total
            StrSubstNo('#1######################################', UpperCase(TransContactName)) +
            StrSubstNo('#1#############', MagMediaManagement.StripNonNumerics(TransContactPhoneNo)) +
            StrSubstNo('#1################################################', TransContactEmail) +   // 359-408
            StrSubstNo('                                                  ') +           //First 50 of 91
            StrSubstNo('                                         ') +                  //last 41 0f 91 blank spaces 409-499
            StrSubstNo('#1######', MagMediaManagement.FormatAmount(SequenceNo, 8)) +   // sequence number for all rec types
            StrSubstNo('          ') +
            StrSubstNo('%1', CopyStr(Format(VendIndicator), 1, 1)) +
            StrSubstNo('#1######################################', UpperCase(VendorInfo.Name)) +
            StrSubstNo('#1######################################', UpperCase(VendorInfo.Address)) +
            StrSubstNo('#1######################################', UpperCase(VendorInfo.City)) +
            StrSubstNo('#1', CopyStr(VendorInfo.County, 1, 2)) +
            StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(VendorInfo."Post Code")) +
            StrSubstNo('#1######################################', UpperCase(VendContactName)) +
            StrSubstNo('#1#############', MagMediaManagement.StripNonNumerics(VendContactPhoneNo)) +
            StrSubstNo('                                              '));      // 46 chars
    end;

    local procedure WriteARec()
    begin
        SequenceNo += 1;
        IRSData.WriteText(
            StrSubstNo('A') +
            StrSubstNo('#1##', CopyStr(Format(Year), 1, 4)) +
            StrSubstNo('      ') +        // 6 blanks
            StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(CompanyInfo."Federal ID No.")) +   // TIN
            StrSubstNo('#1##', PayerNameControl) +  // Payer Name Control
            StrSubstNo(' ') +
            StrSubstNo(ReturnType) +
            StrSubstNo('#1############', CodeNos) +  // Amount Codes  14
            StrSubstNo('         ') +            // 9 blanks
            StrSubstNo(' ') +   // blank 1
            StrSubstNo(' ') +   // Foreign Entity Code - changed
            StrSubstNo('#1######################################', UpperCase(CompanyInfo.Name)) +
            StrSubstNo('                                        ') +  // 2nd Payer Name
            StrSubstNo('0') +  // Transfer Agent Indicator
            StrSubstNo('#1######################################', UpperCase(CompanyInfo.Address)) +
            StrSubstNo('#1######################################', UpperCase(CompanyInfo.City)) +
            StrSubstNo('#1', CopyStr(CompanyInfo.County, 1, 2)) +
            StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(CompanyInfo."Post Code")) +
            StrSubstNo('#1#############', MagMediaManagement.StripNonNumerics(CompanyInfo."Phone No.")) +
            StrSubstNo('                                                  ') +   // blank 50
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('          ') +
            StrSubstNo('#1######', MagMediaManagement.FormatAmount(SequenceNo, 8)) +   // sequence number for all rec types
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                           '));
    end;

    local procedure WriteBRec()
    var
        SSN: Text;
        SecuringMortIndicator: Text[1];
        Box8: Code[39];
        Box9: Code[39];
    begin
        SequenceNo += 1;
        if FormEntry."Box 7" then
            SecuringMortIndicator := '1'
        else
            SecuringMortIndicator := ' ';
        Box1 += FormEntry."Box 1";
        Box2 += FormEntry."Box 2";
        Box4 += FormEntry."Box 4";
        Box5 += FormEntry."Box 5";
        Box6 += FormEntry."Box 6";
        Box8 := CopyStr(FormEntry."Box 8", 1, MaxStrLen(Box8));
        Box9 := CopyStr(FormEntry."Box 9", 1, MaxStrLen(Box9));
        IRSData.WriteText(
            StrSubstNo('B') +
            StrSubstNo('#1##', CopyStr(Format(Year), 1, 4)) +
            StrSubstNo(' ') +       // correction indicator
            StrSubstNo('    ') +   // name control
            StrSubstNo('2') +   // Type of TIN
            StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(SSN)) +   // TIN
            StrSubstNo('#1##################', FormEntry."Loan No.") +  // Payer's Payee Account #
            StrSubstNo('              ') +  // Blank 14
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(FormEntry."Box 1", 12)) +    // Interest code 1
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(FormEntry."Box 6", 12)) +    // Points code 2
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(FormEntry."Box 4", 12)) +    // Points code 2
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(FormEntry."Box 5", 12)) +     // Insurance code 4
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(FormEntry."Box 2", 12)) +     // Insurance code 4
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
            StrSubstNo(' ') +  // Foreign Country Indicator
            StrSubstNo('#1######################################', BorrowerName) +
            StrSubstNo('#1######################################', '') +
            StrSubstNo('                                        ') +  // blank 40
            StrSubstNo('#1######################################', BorrowerAddress) +
            StrSubstNo('                                        ') +  // blank 40
            StrSubstNo('#1######################################', UpperCase(FormEntry."Borrower Mailing City")) +
            StrSubstNo('#1', FormEntry."Borrower State") +
            StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(FormEntry."Borrower ZIP Code")) +
            StrSubstNo(' ') +
            StrSubstNo('#1######', MagMediaManagement.FormatAmount(SequenceNo, 8)) +   // sequence number for all rec types
            StrSubstNo('                                    ') +   //Position 543
            StrSubstNo('#1######', Format(FormEntry."Box 3", 0, '<Year4><Month,2><Day,2>')) + //Origination date
            StrSubstNo(SecuringMortIndicator) +  //Property Securing Mortgage Indicator
            StrSubstNo('#1#####################################', Box8) + //Property Address Securing Mortgage
            StrSubstNo('#1#####################################', Box9) + //Description of Property
            StrSubstNo('                                       ') + //Other
            StrSubstNo('                                                     ') +   //Special Data Entries
            StrSubstNo('                            '));  // blank 28
    end;

    local procedure WriteCRec()
    begin
        SequenceNo += 1;
        IRSData.WriteText(
            StrSubstNo('C') +
            StrSubstNo('#1######', MagMediaManagement.FormatAmount(PayeeTotal, 8)) +
            StrSubstNo('      ') +   // Blank 6
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(Box1, 18)) +    // Payment 1
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(Box6, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(Box4, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(Box5, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(Box2, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
            StrSubstNo('              ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                ') +
            StrSubstNo('#1######', MagMediaManagement.FormatAmount(SequenceNo, 8)) +   // sequence number for all rec types
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                           '));
    end;

    local procedure WriteFRec()
    begin
        SequenceNo += 1;
        IRSData.WriteText(
            StrSubstNo('F') +
            StrSubstNo('#1######', MagMediaManagement.FormatAmount(1, 8)) +  // number of A recs.
            StrSubstNo('#1########', MagMediaManagement.FormatAmount(0, 10)) +  // 21 zeros
            StrSubstNo('#1#########', MagMediaManagement.FormatAmount(0, 11)) +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                   ') +
            StrSubstNo('#1######', MagMediaManagement.FormatAmount(SequenceNo, 8)) +   // sequence number for all rec types
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                                  ') +
            StrSubstNo('                                           '));
    end;
}