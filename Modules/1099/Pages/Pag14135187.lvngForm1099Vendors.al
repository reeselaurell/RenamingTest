page 14135187 lvngForm1099Vendors
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvng1099VendorLine;
    Caption = 'Form 1099 Vendors List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Federal ID No."; "Federal ID No.") { ApplicationArea = All; }
                field("No."; "No.") { ApplicationArea = All; }
                field(Name; Name) { ApplicationArea = All; }
                field("Legal Name"; "Legal Name") { ApplicationArea = All; }
                field("Legal Address"; "Legal Address") { ApplicationArea = All; }
                field("Legal Address City"; "Legal Address City") { ApplicationArea = All; }
                field("Legal Address State"; "Legal Address State") { ApplicationArea = All; }
                field("Legal Address ZIP Code"; "Legal Address ZIP Code") { ApplicationArea = All; }
                field("Total Payments Amount"; "Total Payments Amount") { ApplicationArea = All; }
                field("Not Assigned Amount"; "Not Assigned Amount") { ApplicationArea = All; }
                field("Default MISC"; "Default MISC") { ApplicationArea = All; }
                field("MISC-01"; "MISC-01") { ApplicationArea = All; }
                field("MISC-02"; "MISC-02") { ApplicationArea = All; }
                field("MISC-03"; "MISC-03") { ApplicationArea = All; }
                field("MISC-04"; "MISC-04") { ApplicationArea = All; }
                field("MISC-05"; "MISC-05") { ApplicationArea = All; }
                field("MISC-06"; "MISC-06") { ApplicationArea = All; }
                field("MISC-07"; "MISC-07") { ApplicationArea = All; }
                field("MISC-08"; "MISC-08") { ApplicationArea = All; }
                field("MISC-09"; "MISC-09") { ApplicationArea = All; }
                field("MISC-10"; "MISC-10") { ApplicationArea = All; }
                field("MISC-13"; "MISC-13") { ApplicationArea = All; }
                field("MISC-14"; "MISC-14") { ApplicationArea = All; }
                field("MISC-15-A"; "MISC-15-A") { ApplicationArea = All; }
                field("MISC-15-B"; "MISC-15-B") { ApplicationArea = All; }
                field("MISC-16"; "MISC-16") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RetrieveVendors)
            {
                Caption = 'Retrieve Vendors';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Vendor;

                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    Clear(FedID);
                    Reset();
                    if FindSet() then
                        if Confirm(ConfirmMsg) then begin
                            ModifyAll("Total Payments Amount", 0);
                            DeleteAll();
                        end else
                            Error('');
                    Vendor.Reset();
                    Vendor.SetFilter("Federal ID No.", '<>%1', '');
                    if Vendor.FindSet() then
                        repeat
                            "No." := Vendor."No.";
                            Name := Vendor.Name;
                            "Federal ID No." := Vendor."Federal ID No.";
                            "Legal Address" := Vendor.lvngLegalAddress;
                            "Legal Address City" := Vendor.lvngLegalCity;
                            "Legal Address State" := Vendor.lvngLegalState;
                            "Legal Address ZIP Code" := Vendor.lvngLegalZIPCode;
                            "Default MISC" := Vendor."IRS 1099 Code";
                            "FATCA Filing Requirement" := Vendor."FATCA filing requirement";
                            "Total Payments Amount" := 0;
                            if Insert() then;
                        until Vendor.Next() = 0;
                end;
            }

            action(RetrieveGroupVendors)
            {
                Caption = 'Retrieve Grouped Vendors';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = VendorCode;

                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    Clear(FedID);
                    Reset();
                    if FindSet() then
                        if Confirm(ConfirmMsg) then
                            DeleteAll()
                        else
                            Error('');
                    Vendor.Reset();
                    Vendor.SetFilter("Federal ID No.", '<>%1', '');
                    if Vendor.FindSet() then
                        repeat
                            if not FedID.ContainsKey(Vendor."Federal ID No.") then begin
                                "No." := Vendor."No.";
                                Name := Vendor.Name;
                                "Federal ID No." := Vendor."Federal ID No.";
                                "Legal Address" := Vendor.lvngLegalAddress;
                                "Legal Address City" := Vendor.lvngLegalCity;
                                "Legal Address State" := Vendor.lvngLegalState;
                                "Legal Address ZIP Code" := Vendor.lvngLegalZIPCode;
                                "Default MISC" := Vendor."IRS 1099 Code";
                                "FATCA Filing Requirement" := Vendor."FATCA filing requirement";
                                if Insert() then;
                                // if "Federal ID No." <> '' then
                                FedID.Add(Vendor."Federal ID No.", Format(Vendor."No."));
                            end else
                                FedID.Set(Vendor."Federal ID No.", FedID.Get(Vendor."Federal ID No.") + '|' + Vendor."No.");
                        until Vendor.Next() = 0;
                end;
            }

            action(CalcPayments)
            {
                Caption = 'Calculate Total Payments';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Calculate;

                trigger OnAction()
                var
                    Calc1099Payments: Report lvngForm1099CalcVendPayments;
                begin
                    Rec.Reset();
                    if Rec.IsEmpty then
                        Error(NoVendorsErr);
                    Calc1099Payments.SetParams(FedID);
                    Calc1099Payments.Run();
                    CurrPage.Update();
                end;
            }

            action(IRSData)
            {
                Caption = 'Magnetic Media Export';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = Export1099;

                trigger OnAction()
                var
                    MagMedia1099: Report lvngForm1099MagneticMedia;
                begin
                    Rec.FindFirst();
                    Year := Rec.Year;
                    if Year = 0 then
                        Error(CalcErr);
                    Commit();
                    MagMedia1099.SetParams(Year);
                    MagMedia1099.Run();
                end;
            }

            action(Printout)
            {
                Caption = 'Form 1099 Printout';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = PrintForm;

                trigger OnAction()
                var
                    Printout: Report lvngForm1099Printout;
                begin
                    Rec.FindFirst();
                    Year := Rec.Year;
                    if Year = 0 then
                        Error(CalcErr);
                    Commit();
                    Printout.SetYear(Year);
                    Printout.Run();
                end;
            }

            action(Export)
            {
                Caption = 'Export Form 1099';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Export;

                trigger OnAction()
                var
                    Export1099: Report lvngForm1099ExcelExport;
                begin
                    if Year = 0 then
                        Error(CalcErr);
                    Commit();
                    Export1099.Run();
                end;
            }
        }
    }

    var
        ConfirmMsg: Label 'This process will erase current calculations, Do you wish to continue?';
        NoVendorsErr: Label 'Vendors List is empty';
        CalcErr: Label 'Payments not calculated';
        FedID: Dictionary of [Text[30], Text];
        Year: Integer;

    trigger OnOpenPage()
    begin
        Rec.Reset();
        Rec.DeleteAll();
    end;
}