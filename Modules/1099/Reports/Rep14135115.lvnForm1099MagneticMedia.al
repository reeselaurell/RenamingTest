report 14135115 "lvnForm1099MagneticMedia"
{
    Caption = 'Form 1099 Magnetic Media Export';
    ProcessingOnly = true;

    dataset
    {
        dataitem(TRecord; Integer)
        {
            DataItemTableView = sorting(Number);
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                WriteTRec();
            end;
        }

        dataitem(ARecord; Integer)
        {
            DataItemTableView = sorting(Number);
            MaxIteration = 1;

            dataitem(VendorLine; lvn1099VendorLine)
            {
                trigger OnPreDataItem()
                begin
                    MagMediaManagement.ClearTotals();
                end;

                trigger OnAfterGetRecord()
                var
                    FormBox: Record "IRS 1099 Form-Box";
                begin
                    if VendorLine."Total Payments Amount" = 0 then
                        CurrReport.Skip();
                    PayeeNum += 1;
                    PayeeTotal += 1;
                    if FormBox.Get("MISC-09") then
                        if "MISC-09" > FormBox."Minimum Reportable" then
                            DirectSales := '1'
                        else
                            DirectSales := ' ';
                    IncrementMISCTotals();
                    WriteMiscBRec();
                end;
            }

            dataitem(CRecord; Integer)
            {
                DataItemTableView = sorting(Number);
                MaxIteration = 1;

                trigger OnAfterGetRecord()
                begin
                    WriteMISCCRec();
                end;
            }

            trigger OnAfterGetRecord()
            var
                InvoiceEntry: Record "Vendor Ledger Entry";
            begin
                PayeeNum := 0;
                if DirectSales = '1' then
                    CodeNos := '1';
                WriteARec();
                ARecNum += 1;
            end;
        }

        dataitem(FRecord; Integer)
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
        layout
        {
            area(Content)
            {
                field(Year; Year) { Caption = 'Year'; ApplicationArea = All; Editable = false; }

                group(TransmitterInfo)
                {
                    Caption = 'Transmitter Information';

                    field(TransCode; TransCode)
                    {
                        Caption = 'Transmitter Control Code';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TransCode = '' then
                                Error(TransCodeErr);
                        end;
                    }
                    field(TransInfoName; TempTransmitterInfo.Name) { Caption = 'Transmitter Name'; ApplicationArea = All; }
                    field(TransInfoAddress; TempTransmitterInfo.Address) { Caption = 'Street Address'; ApplicationArea = All; }
                    field(TransInfoCity; TempTransmitterInfo.City) { Caption = 'City'; ApplicationArea = All; }
                    field(TransInfoState; TempTransmitterInfo.County) { Caption = 'State'; ApplicationArea = All; }
                    field(TransInfoZIP; TempTransmitterInfo."Post Code") { Caption = 'ZIP Code'; ApplicationArea = All; }
                    field(TransInfoEmployerID; TempTransmitterInfo."Federal ID No.") { Caption = 'Employer ID'; ApplicationArea = All; }
                    field(ContactName; ContactName)
                    {
                        Caption = 'Contact Name';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if ContactName = '' then
                                Error(ContactNameErr);
                        end;
                    }
                    field(ContactPhoneNo; ContactPhoneNo)
                    {
                        Caption = 'Contact Phone No.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if ContactPhoneNo = '' then
                                Error(ContactPhoneNoErr);
                        end;
                    }
                    field(ContactEmail; ContactEmail) { Caption = 'Contact E-Mail'; ApplicationArea = All; }
                }

                group(VendorInfo)
                {
                    Caption = 'Vendor Information';

                    field(VendIndicator; VendIndicator) { Caption = 'Vendor Indicator'; ApplicationArea = All; }
                    field(VendorInfoName; TempVendorInfo.Name)
                    {
                        Caption = 'Vendor Name';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TempVendorInfo.Name = '' then
                                Error(VendInfoErr);
                        end;
                    }
                    field(VendorInfoAddress; TempVendorInfo.Address)
                    {
                        Caption = 'Vendor Street Address';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TempVendorInfo.Address = '' then
                                Error(VendInfoErr);
                        end;
                    }
                    field(VendorInfoCity; TempVendorInfo.City)
                    {
                        Caption = 'Vendor City';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TempVendorInfo.City = '' then
                                Error(VendInfoErr);
                        end;
                    }
                    field(VendorInfoState; TempVendorInfo.County)
                    {
                        Caption = 'Vendor State';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TempVendorInfo.County = '' then
                                Error(VendInfoErr);
                        end;
                    }
                    field(VendorInfoZIP; TempVendorInfo."Post Code")
                    {
                        Caption = 'Vendor ZIP Code';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TempVendorInfo."Post Code" = '' then
                                Error(VendInfoErr);
                        end;
                    }
                    field(VendContactName; VendContactName)
                    {
                        Caption = 'Vendor Contact Name';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if VendContactName = '' then
                                Error(VendNameErr);
                        end;
                    }
                    field(VendContactPhoneNo; VendContactPhoneNo)
                    {
                        Caption = 'Vendor Contact Phone No.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TempVendorInfo.City = '' then
                                Error(VendPhoneNoErr);
                        end;
                    }
                    field(VendorInfoEmail; TempVendorInfo."E-Mail")
                    {
                        Caption = 'Vendor E-Mail';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if TempVendorInfo."E-Mail" = '' then
                                Error(VendInfoErr);
                        end;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            CompanyInfo.Get();
            TempTransmitterInfo := CompanyInfo;
        end;
    }

    var
        TransCodeErr: Label 'You must enter the Transmitter Control Code assigned to you by the IRS.';
        ContactNameErr: Label 'You must enter the name of the person to be contacted if IRS/MCC encounters problems with the file or transmission.';
        VendNameErr: Label 'You must enter the name of the person to be contacted if IRS/MCC has any software questions.';
        VendPhoneNoErr: Label 'You must enter the phone number of the person to be contacted if IRS/MCC has any software questions.';
        ContactPhoneNoErr: Label 'You must enter the phone number of the person to be contacted if IRS/MCC encounters problems with the file or transmission.';
        VendInfoErr: Label 'You must enter all software vendor address information.';
        ProgressMsg: Label 'Exporting...\\Table    #1####################';
        InitialProgressTxt: Label 'IRSTAX';
        ExportLbl: Label 'Export';
        AllFileFilterTxt: Label 'All Files (*.*)|*.*';
        DefaultFileNameTxt: Label '1099IRSTAX.txt';
        CompanyInfo: Record "Company Information";
        TempTransmitterInfo: Record "Company Information" temporary;
        TempVendorInfo: Record "Company Information" temporary;
        IRSBlob: Codeunit "Temp Blob";
        MagMediaManagement: Codeunit "A/P Magnetic Media Management";
        VendIndicator: Enum lvnForm1098VendorIndicator;
        IRSData: OutStream;
        Year: Integer;
        SequenceNo: Integer;
        TestFile: Text[1];
        PriorYear: Text[1];
        TransCode: Code[5];
        ContactPhoneNo: Text[30];
        ContactName: Text[40];
        VendContactName: Text[40];
        VendContactPhoneNo: Text[30];
        ContactEmail: Text[35];
        DirectSales: Text[1];
        IsDirectSale: Boolean;
        PayeeNum: Integer;
        PayeeTotal: Integer;
        Progress: Dialog;
        ARecNum: Integer;
        CodeNos: Text[12];
        MISCTotals: array[15] of Decimal;

    trigger OnInitReport()
    begin
        TestFile := ' ';
        PriorYear := ' ';
        SequenceNo := 0;
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        if TransCode = '' then
            Error(TransCodeErr);
        if ContactPhoneNo = '' then
            Error(ContactPhoneNo);
        if ContactName = '' then
            Error(ContactNameErr);
        if VendContactName = '' then
            Error(VendNameErr);
        if VendContactPhoneNo = '' then
            Error(VendPhoneNoErr);
        if TempVendorInfo.Name = '' then
            Error(VendInfoErr);
        if TempVendorInfo.Address = '' then
            Error(VendPhoneNoErr);
        if TempVendorInfo.City = '' then
            Error(VendPhoneNoErr);
        if TempVendorInfo.County = '' then
            Error(VendPhoneNoErr);
        if TempVendorInfo."Post Code" = '' then
            Error(VendPhoneNoErr);
        if TempVendorInfo."E-Mail" = '' then
            Error(VendPhoneNoErr);
        PayeeNum := 0;
        PayeeTotal := VendorLine.Count();
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

    local procedure IncrementSequenceNo()
    begin
        SequenceNo += 1;
    end;

    local procedure WriteTRec()
    begin
        // T Record - 1 per transmission, 750 length
        IncrementSequenceNo;
        IRSData.WriteText(StrSubstNo('T') +
          StrSubstNo('#1##', CopyStr(Format(Year), 1, 4)) +
          StrSubstNo(PriorYear) + // Prior Year Indicator
          StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(TempTransmitterInfo."Federal ID No.")) +
          StrSubstNo('#1###', TransCode) + // Transmitter Control Code
          StrSubstNo('  ') + // replacement character
          StrSubstNo('     ') + // blank 5
          StrSubstNo(TestFile) +
          StrSubstNo(' ') + // Foreign Entity Code
          StrSubstNo('#1##############################################################################',
            TempTransmitterInfo.Name) +
          StrSubstNo('#1################################################', CompanyInfo.Name) +
          StrSubstNo('                              ') + // 2nd Payer Name
          StrSubstNo('#1######################################', CompanyInfo.Address) +
          StrSubstNo('#1######################################', CompanyInfo.City) +
          StrSubstNo('#1', CopyStr(CompanyInfo.County, 1, 2)) +
          StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(CompanyInfo."Post Code")) +
          StrSubstNo('               ') + // blank 15
          StrSubstNo('#1######', MagMediaManagement.FormatAmount(PayeeTotal, 8)) + // Payee total
          StrSubstNo('#1######################################', ContactName) +
          StrSubstNo('#1#############', ContactPhoneNo) +
          StrSubstNo('#1################################################', ContactEmail) + // 359-408
          StrSubstNo('  ') + // Tape file indicator
          StrSubstNo('#1####', '      ') + // place for media number (not required)
          StrSubstNo('                                                  ') +
          StrSubstNo('                                 ') +
          StrSubstNo('#1######', MagMediaManagement.FormatAmount(SequenceNo, 8)) + // sequence number for all rec types
          StrSubstNo('          ') +
          StrSubstNo('%1', CopyStr(Format(VendIndicator), 1, 1)) +
          StrSubstNo('#1######################################', TempVendorInfo.Name) +
          StrSubstNo('#1######################################', TempVendorInfo.Address) +
          StrSubstNo('#1######################################', TempVendorInfo.City) +
          StrSubstNo('#1', CopyStr(TempVendorInfo.County, 1, 2)) +
          StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(TempVendorInfo."Post Code")) +
          StrSubstNo('#1######################################', VendContactName) +
          StrSubstNo('#1#############', VendContactPhoneNo) +
          StrSubstNo('#1##################', TempVendorInfo."E-Mail") + // 20 chars
          StrSubstNo('                          '));
    end;

    local procedure WriteARec()
    begin
        // A Record - 1 per Payer per 1099 type, 750 length
        IncrementSequenceNo;
        IRSData.WriteText();
        IRSData.WriteText(StrSubstNo('A') +
          StrSubstNo('#1##', CopyStr(Format(Year), 1, 4)) +
          StrSubstNo('      ') + // 6 blanks
          StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(CompanyInfo."Federal ID No.")) + // TIN
          StrSubstNo('#1##', '    ') + // Payer Name Control
          StrSubstNo(' ') +
          StrSubstNo('A ') +
          StrSubstNo('#1##############', CodeNos) + // Amount Codes  16
          StrSubstNo('        ') + // 8 blanks
          StrSubstNo(' ') + // Foreign Entity Code
          StrSubstNo('#1######################################', CompanyInfo.Name) +
          StrSubstNo('                                        ') + // 2nd Payer Name
          StrSubstNo(' ') + // Transfer Agent Indicator
          StrSubstNo('#1######################################', CompanyInfo.Address) +
          StrSubstNo('#1######################################', CompanyInfo.City) +
          StrSubstNo('#1', CompanyInfo.County) +
          StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(CompanyInfo."Post Code")) +
          StrSubstNo('#1#############', CompanyInfo."Phone No.") +
          StrSubstNo('                                                  ') + // blank 50
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('          ') +
          StrSubstNo('#1######', MagMediaManagement.FormatAmount(SequenceNo, 8)) + // sequence number for all rec types
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                           '));
    end;

    local procedure WriteMiscBRec()
    begin
        IncrementSequenceNo;
        IRSData.WriteText();
        IRSData.WriteText(StrSubstNo('B') +
          StrSubstNo('#1##', CopyStr(Format(Year), 1, 4)) +
          StrSubstNo(' ') + // correction indicator
          StrSubstNo('    ') + // name control
          StrSubstNo(' ') + // Type of TIN
          StrSubstNo('#1#######', MagMediaManagement.StripNonNumerics(VendorLine."Federal ID No.")) + // TIN
          StrSubstNo('#1##################', VendorLine."No.") + // Payer's Payee Account #
          StrSubstNo('              ') + // Blank 14
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-01", 12)) + // Payment 1
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-02", 12)) +
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-03", 12)) +
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-04", 12)) +
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-05", 12)) +
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-06", 12)) +
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-07", 12)) +
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-08", 12)) +
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-10", 12)) + // crop insurance  Payment A
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-13", 12)) + // golden parachute  Payment B
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-14", 12)) + // gross legal services Payment C
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-15-A", 12)) + // 409A deferral
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-15-B", 12)) + // 409A Income
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) +
          StrSubstNo(' ') + // Foreign Country Indicator
          StrSubstNo('#1######################################', VendorLine.Name) +
          StrSubstNo('#1######################################', '') +
          StrSubstNo('                                        ') + // blank 40
          StrSubstNo('#1######################################', VendorLine."Legal Address") +
          StrSubstNo('                                        ') + // blank 40
          StrSubstNo('#1######################################', VendorLine."Legal Address City") +
          StrSubstNo('#1', VendorLine."Legal Address State") +
          StrSubstNo('#1#######', VendorLine."Legal Address ZIP Code") +
          StrSubstNo(' ') +
          StrSubstNo('#1######', MagMediaManagement.FormatAmount(SequenceNo, 8)) + // sequence number for all rec types
          StrSubstNo('                                    ') +
          StrSubstNo(' ') + // Second TIN Notice (Optional) (544)
          StrSubstNo('  ') + // Blank (545-546)
          StrSubstNo(DirectSales) + // Direct Sales Indicator (547)
          StrSubstNo(Format(VendorLine."FATCA Filing Requirement", 0, 2)) + // FATCA Filing Requirement Indicator (548)
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('              ') + // Blank (549-662)
          StrSubstNo('                                                  ') +
          StrSubstNo('          ') + // Special Data Entries (663-722)
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(VendorLine."MISC-16", 12)) + // State Income Tax Withheld (723-734)
          StrSubstNo('#1##########', MagMediaManagement.FormatMoneyAmount(0, 12)) + // Local Income Tax Withheld (735-746)
          StrSubstNo('  ') + // Combined Federal/State Code (747-748)
          StrSubstNo('  '));  // Blank (749-750)
    end;

    local procedure WriteMISCCRec()
    begin
        // C Record - 1 per Payer per 1099 type
        IncrementSequenceNo;
        IRSData.WriteText();
        IRSData.WriteText(StrSubstNo('C') +
          StrSubstNo('#1######', MagMediaManagement.FormatAmount(PayeeNum, 8)) +
          StrSubstNo('      ') + // Blank 6
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[1], 18)) + // Payment 1
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[2], 18)) +
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[3], 18)) +
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[4], 18)) +
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[5], 18)) +
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[6], 18)) +
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[7], 18)) +
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[8], 18)) +
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[10], 18)) + // crop insurance  Payment A
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[11], 18)) + // golden parachute  Payment B
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[12], 18)) + // gross legal services Payment C
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[13], 18)) + // 409A deferral
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(MISCTotals[14], 18)) + // 409A Income
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
          StrSubstNo('#1################', MagMediaManagement.FormatMoneyAmount(0, 18)) +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                              ') +
          StrSubstNo('#1######', MagMediaManagement.FormatAmount(SequenceNo, 8)) + // sequence number for all rec types
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                           '));
    end;

    local procedure WriteFRec()
    begin
        // F Record - 1
        IncrementSequenceNo;
        IRSData.WriteText();
        IRSData.WriteText(StrSubstNo('F') +
          StrSubstNo('#1######', MagMediaManagement.FormatAmount(ARecNum, 8)) + // number of A recs.
          StrSubstNo('#1########', MagMediaManagement.FormatAmount(0, 10)) + // 21 zeros
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
          StrSubstNo('#1######', MagMediaManagement.FormatAmount(SequenceNo, 8)) + // sequence number for all rec types
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                                  ') +
          StrSubstNo('                                           '));
    end;

    procedure SetParams(pYear: Integer)
    begin
        Year := pYear;
    end;

    local procedure IncrementMISCTotals()
    begin
        MISCTotals[1] += VendorLine."MISC-01";
        MISCTotals[2] += VendorLine."MISC-02";
        MISCTotals[3] += VendorLine."MISC-03";
        MISCTotals[4] += VendorLine."MISC-04";
        MISCTotals[5] += VendorLine."MISC-05";
        MISCTotals[6] += VendorLine."MISC-06";
        MISCTotals[7] += VendorLine."MISC-07";
        MISCTotals[8] += VendorLine."MISC-08";
        MISCTotals[9] += VendorLine."MISC-09";
        MISCTotals[10] += VendorLine."MISC-10";
        MISCTotals[11] += VendorLine."MISC-13";
        MISCTotals[12] += VendorLine."MISC-14";
        MISCTotals[13] += VendorLine."MISC-15-A";
        MISCTotals[14] += VendorLine."MISC-15-B";
        MISCTotals[15] += VendorLine."MISC-16";
    end;
}