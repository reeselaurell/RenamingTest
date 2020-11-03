report 14135114 "lvnForm1099CalcVendPayments"
{
    Caption = 'Form 1099 Calculate Vendor Payments/Refunds';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Form1099VendorLine; lvn1099VendorLine)
        {
            DataItemTableView = sorting("No.");

            dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");

                trigger OnPreDataItem()
                begin
                    VendorLedgerEntry.SetRange("Posting Date", FromDate, ToDate);
                    VendorLedgerEntry.SetFilter("Document Type", '%1|%2', VendorLedgerEntry."Document Type"::Payment, VendorLedgerEntry."Document Type"::Refund);
                    if FedID.ContainsKey(Form1099VendorLine."Federal ID No.") then
                        VendorLedgerEntry.SetFilter("Vendor No.", FedID.Get(Form1099VendorLine."Federal ID No."))
                    else
                        VendorLedgerEntry.SetFilter("Vendor No.", Form1099VendorLine."No.");
                    PaymentTotal := 0;
                    DefaultTotal := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    if (VendorLedgerEntry."IRS 1099 Code" <> '') and (VendorLedgerEntry."IRS 1099 Amount" <> 0) then begin
                        case VendorLedgerEntry."IRS 1099 Code" of
                            Form1099VendorLine.FieldName("MISC-01"):
                                Form1099VendorLine."MISC-01" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-02"):
                                Form1099VendorLine."MISC-02" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-03"):
                                Form1099VendorLine."MISC-03" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-04"):
                                Form1099VendorLine."MISC-04" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-05"):
                                Form1099VendorLine."MISC-05" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-06"):
                                Form1099VendorLine."MISC-06" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-07"):
                                Form1099VendorLine."MISC-07" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-08"):
                                Form1099VendorLine."MISC-08" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-09"):
                                Form1099VendorLine."MISC-09" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-10"):
                                Form1099VendorLine."MISC-10" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-13"):
                                Form1099VendorLine."MISC-13" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-14"):
                                Form1099VendorLine."MISC-14" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-15-A"):
                                Form1099VendorLine."MISC-15-A" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-15-B"):
                                Form1099VendorLine."MISC-15-B" += VendorLedgerEntry."IRS 1099 Amount";
                            Form1099VendorLine.FieldName("MISC-16"):
                                Form1099VendorLine."MISC-16" += VendorLedgerEntry."IRS 1099 Amount";
                            else
                                DefaultTotal += VendorLedgerEntry."IRS 1099 Amount";
                        end;
                        PaymentTotal += VendorLedgerEntry."IRS 1099 Amount";
                        VendorLedgerEntry.Modify();
                    end else begin
                        PaymentTotal += VendorLedgerEntry."Closed by Amount";
                        DefaultTotal += VendorLedgerEntry."Closed by Amount";
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    Form1099VendorLine."Total Payments Amount" := PaymentTotal;
                    if Form1099VendorLine.FieldName("MISC-01") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-01" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-02") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-02" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-03") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-03" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-04") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-04" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-05") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-05" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-06") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-06" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-07") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-07" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-08") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-08" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-09") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-09" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-10") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-10" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-13") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-13" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-14") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-14" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-15-A") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-15-A" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-15-B") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-15-B" := DefaultTotal;
                    if Form1099VendorLine.FieldName("MISC-16") = Form1099VendorLine."Default MISC" then
                        Form1099VendorLine."MISC-16" := DefaultTotal;
                    Form1099VendorLine.Modify();
                end;
            }
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
                    field(Year; Year)
                    {
                        Caption = 'Year';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if (Year < 1980) or (Year > 2060) then
                                Error(YearErr);
                        end;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            Year := Date2DMY(Today, 3);
        end;
    }

    var
        YearErr: Label 'You must enter a valid year, e.g. 2019.';
        FedID: Dictionary of [Text[30], Text];
        FromDate: Date;
        ToDate: Date;
        Year: Integer;
        PaymentTotal: Decimal;
        DefaultTotal: Decimal;

    procedure SetParams(pFedID: Dictionary of [Text[30], Text])
    begin
        FedID := pFedID;
    end;

    trigger OnPreReport()
    begin
        Form1099VendorLine.ModifyAll(Year, Year);
        FromDate := DMY2Date(1, 1, Year);
        ToDate := DMY2Date(31, 12, Year);
    end;
}