report 14135156 lvngForm1099Printout
{
    Caption = 'Form 1099 Printout';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Layouts/Rep14135156.rdl';

    dataset
    {
        dataitem(VendorLine; lvng1099VendorLine)
        {
            column(CompanyAddress1; CompanyAddress[1]) { }
            column(CompanyAddress2; CompanyAddress[2]) { }
            column(CompanyAddress3; CompanyAddress[3]) { }
            column(CompanyAddress4; CompanyAddress[4]) { }
            column(CompanyAddress5; CompanyAddress[5]) { }
            column(CompanyFedID; CompanyInformation."Federal ID No.") { }
            column(MISC1Amt; "MISC-01") { }
            column(MISC2Amt; "MISC-02") { }
            column(MISC3Amt; "MISC-03") { }
            column(MISC4Amt; "MISC-04") { }
            column(MISC5Amt; "MISC-05") { }
            column(MISC6Amt; "MISC-06") { }
            column(MISC7AmtMISC15BAmt; "MISC-07" + "MISC-15-B") { }
            column(MISC8Amt; "MISC-08") { }
            column(MISC9Amt; "MISC-09") { }
            column(MISC10Amt; "MISC-10") { }
            column(MISC13Amt; "MISC-13") { }
            column(MISC14Amt; "MISC-14") { }
            column(MISC15AAmt; "MISC-15-A") { }
            column(MISC15BAmt; "MISC-15-B") { }
            column(MISC16Amt; "MISC-16") { }
            column(VendorName; "Legal Name") { }
            column(VendorAddress; "Legal Address") { }
            column(VendorCity; "Legal Address City") { }
            column(VendorState; "Legal Address State") { }
            column(VendorZip; "Legal Address ZIP Code") { }
            column(VendorFedID; "Federal ID No.") { }
            column(VendorNo; "No.") { }
            column(AddressLine2; AddressLine2) { }
            column(FATCA; FATCA) { }
            column(Box9; Box9) { }
            column(VoidBox; VoidBox) { }
            column(PageGroupNo; PageGroupNo) { }
            column(FormCounter; FormCounter) { }

            dataitem(Counter; Integer)
            {
                DataItemTableView = sorting(Number);
                MaxIteration = 1;

                trigger OnAfterGetRecord()
                begin
                    FormCounter += 1;
                end;
            }

            trigger OnPreDataItem()
            begin
                FirstVendor := true;
            end;

            trigger OnAfterGetRecord()
            var
                Vendor: Record Vendor;
                FormBox: Record "IRS 1099 Form-Box";
            begin
                Box9 := '';
                if TestPrint then begin
                    if FirstVendor then begin
                        Name := PadStr('x', MaxStrLen(Name), 'X');
                        "Legal Address" := PadStr('x', MaxStrLen("Legal Address"), 'X');
                        AddressLine2 := PadStr('x', MaxStrLen(AddressLine2), 'X');
                        VoidBox := 'X';
                        FATCA := 'X';
                        "No." := PadStr('x', MaxStrLen("No."), 'X');
                        "Federal ID No." := PadStr('x', MaxStrLen("Federal ID No."), 'X');
                        SetTestMISCValues();
                    end else
                        CurrReport.Break();
                end else begin
                    if "Total Payments Amount" = 0 then
                        CurrReport.Skip();
                    FATCA := '';
                    if Vendor.Get("No.") then
                        if Vendor."FATCA filing requirement" then
                            FATCA := 'X';
                    if FormBox.Get("MISC-09") then
                        if "MISC-09" > FormBox."Minimum Reportable" then
                            Box9 := 'X';
                    if StrLen("Legal Address City" + ',' + "Legal Address State" + ' ' + "Legal Address ZIP Code") > MaxStrLen(AddressLine2) then
                        AddressLine2 := "Legal Address City"
                    else
                        if ("Legal Address City" <> '') and ("Legal Address State" <> '') then
                            AddressLine2 := "Legal Address City" + ',' + "Legal Address State" + "Legal Address ZIP Code"
                        else
                            AddressLine2 := DelChr("Legal Address City" + ' ' + "Legal Address State" + ' ' + "Legal Address ZIP Code", '<>');
                    if VendorNoCount = 2 then begin
                        PageGroupNo += 1;
                        VendorNoCount := 0;
                    end;
                    VendorNoCount += 1;
                    FirstVendor := false;
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
                group(Group)
                {
                    field(Year; Year) { Caption = 'Year'; ApplicationArea = All; Editable = false; }
                    field(TestPrint; TestPrint) { Caption = 'Test Print'; ApplicationArea = All; }
                }
            }
        }

        trigger OnOpenPage()
        begin
            TestPrint := false;
        end;
    }

    var
        CompanyInformation: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        CompanyAddress: array[8] of Text[100];
        FATCA: Code[1];
        Box9: Code[1];
        VoidBox: Code[1];
        PageGroupNo: Integer;
        VendorNoCount: Integer;
        Year: Integer;
        AddressLine2: Text[30];
        FormCounter: Integer;
        TestPrint: Boolean;
        FirstVendor: Boolean;

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        FormatAddress.Company(CompanyAddress, CompanyInformation);
    end;

    procedure SetYear(pYear: Integer)
    begin
        Year := pYear;
    end;

    local procedure SetTestMISCValues()
    begin
        VendorLine."MISC-01" := 9999999.99;
        VendorLine."MISC-02" := 9999999.99;
        VendorLine."MISC-03" := 9999999.99;
        VendorLine."MISC-04" := 9999999.99;
        VendorLine."MISC-05" := 9999999.99;
        VendorLine."MISC-06" := 9999999.99;
        VendorLine."MISC-07" := 9999999.99;
        VendorLine."MISC-08" := 9999999.99;
        VendorLine."MISC-09" := 9999999.99;
        VendorLine."MISC-10" := 9999999.99;
        VendorLine."MISC-13" := 9999999.99;
        VendorLine."MISC-14" := 9999999.99;
        VendorLine."MISC-15-A" := 9999999.99;
        VendorLine."MISC-15-B" := 9999999.99;
        VendorLine."MISC-16" := 9999999.99;
    end;
}