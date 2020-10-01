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
                field("Federal ID No."; Rec."Federal ID No.") { ApplicationArea = All; }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
                field("Legal Name"; Rec."Legal Name") { ApplicationArea = All; }
                field("Legal Address"; Rec."Legal Address") { ApplicationArea = All; }
                field("Legal Address City"; Rec."Legal Address City") { ApplicationArea = All; }
                field("Legal Address State"; Rec."Legal Address State") { ApplicationArea = All; }
                field("Legal Address ZIP Code"; Rec."Legal Address ZIP Code") { ApplicationArea = All; }
                field("Total Payments Amount"; Rec."Total Payments Amount") { ApplicationArea = All; }
                field("Not Assigned Amount"; Rec."Not Assigned Amount") { ApplicationArea = All; }
                field("Default MISC"; Rec."Default MISC") { ApplicationArea = All; }
                field("MISC-01"; Rec."MISC-01") { ApplicationArea = All; }
                field("MISC-02"; Rec."MISC-02") { ApplicationArea = All; }
                field("MISC-03"; Rec."MISC-03") { ApplicationArea = All; }
                field("MISC-04"; Rec."MISC-04") { ApplicationArea = All; }
                field("MISC-05"; Rec."MISC-05") { ApplicationArea = All; }
                field("MISC-06"; Rec."MISC-06") { ApplicationArea = All; }
                field("MISC-07"; Rec."MISC-07") { ApplicationArea = All; }
                field("MISC-08"; Rec."MISC-08") { ApplicationArea = All; }
                field("MISC-09"; Rec."MISC-09") { ApplicationArea = All; }
                field("MISC-10"; Rec."MISC-10") { ApplicationArea = All; }
                field("MISC-13"; Rec."MISC-13") { ApplicationArea = All; }
                field("MISC-14"; Rec."MISC-14") { ApplicationArea = All; }
                field("MISC-15-A"; Rec."MISC-15-A") { ApplicationArea = All; }
                field("MISC-15-B"; Rec."MISC-15-B") { ApplicationArea = All; }
                field("MISC-16"; Rec."MISC-16") { ApplicationArea = All; }
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
                    Rec.Reset();
                    if Rec.FindSet() then
                        if Confirm(ConfirmMsg) then begin
                            Rec.ModifyAll("Total Payments Amount", 0);
                            Rec.DeleteAll();
                        end else
                            Error('');
                    Vendor.Reset();
                    Vendor.SetFilter("Federal ID No.", '<>%1', '');
                    if Vendor.FindSet() then
                        repeat
                            Rec."No." := Vendor."No.";
                            Rec.Name := Vendor.Name;
                            Rec."Federal ID No." := Vendor."Federal ID No.";
                            Rec."Legal Address" := Vendor.lvngLegalAddress;
                            Rec."Legal Address City" := Vendor.lvngLegalCity;
                            Rec."Legal Address State" := Vendor.lvngLegalState;
                            Rec."Legal Address ZIP Code" := Vendor.lvngLegalZIPCode;
                            Rec."Default MISC" := Vendor."IRS 1099 Code";
                            Rec."FATCA Filing Requirement" := Vendor."FATCA filing requirement";
                            Rec."Total Payments Amount" := 0;
                            if Rec.Insert() then;
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
                    Rec.Reset();
                    if Rec.FindSet() then
                        if Confirm(ConfirmMsg) then
                            Rec.DeleteAll()
                        else
                            Error('');
                    Vendor.Reset();
                    Vendor.SetFilter("Federal ID No.", '<>%1', '');
                    if Vendor.FindSet() then
                        repeat
                            if not FedID.ContainsKey(Vendor."Federal ID No.") then begin
                                Rec."No." := Vendor."No.";
                                Rec.Name := Vendor.Name;
                                Rec."Federal ID No." := Vendor."Federal ID No.";
                                Rec."Legal Address" := Vendor.lvngLegalAddress;
                                Rec."Legal Address City" := Vendor.lvngLegalCity;
                                Rec."Legal Address State" := Vendor.lvngLegalState;
                                Rec."Legal Address ZIP Code" := Vendor.lvngLegalZIPCode;
                                Rec."Default MISC" := Vendor."IRS 1099 Code";
                                Rec."FATCA Filing Requirement" := Vendor."FATCA filing requirement";
                                if Rec.Insert() then;
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
                    Rec.Year := Rec.Year;
                    if Rec.Year = 0 then
                        Error(CalcErr);
                    Commit();
                    MagMedia1099.SetParams(Rec.Year);
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
                    Rec.Year := Rec.Year;
                    if Rec.Year = 0 then
                        Error(CalcErr);
                    Commit();
                    Printout.SetYear(Rec.Year);
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
                    if Rec.Year = 0 then
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