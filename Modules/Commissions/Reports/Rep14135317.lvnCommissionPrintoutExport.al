report 14135317 lvnCommissionPrintoutExport
{
    Caption = 'Commission Printout Export';
    ProcessingOnly = true;

    dataset
    {
        dataitem(CommissionSchedule; lvnCommissionSchedule)
        {
            RequestFilterFields = "No.";

            dataitem(Profiles; Integer)
            {
                DataItemTableView = sorting(Number);

                dataitem(LoanCommissionLines; Integer)
                {
                    DataItemTableView = sorting(Number);

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, TempLoanCommissionBuffer.Count());
                        //Loan Level Column Headers 
                        ExcelExport.NewRow(0);
                        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                        WriteToExcel(ExcelExport, LoanNoColLbl, true, 0, false, ColorLbl);
                        WriteToExcel(ExcelExport, DateFundedColLbl, true, 0, false, ColorLbl);
                        WriteToExcel(ExcelExport, OriginatorColLbl, true, 0, false, ColorLbl);
                        WriteToExcel(ExcelExport, BorrowerNameColLbl, true, 0, false, ColorLbl);
                        WriteToExcel(ExcelExport, LoanAmountColLbl, true, 0, false, ColorLbl);
                        WriteToExcel(ExcelExport, GrossCommissionColLbl, true, 0, false, ColorLbl);
                        WriteToExcel(ExcelExport, BpsColLbl, true, 0, false, ColorLbl);
                        if PrintDetails then
                            WriteToExcel(ExcelExport, IdentiferNameColLbl, true, 0, false, ColorLbl);
                        WriteToExcel(ExcelExport, IdentifierAmountColLbl, true, 0, false, ColorLbl);
                        WriteToExcel(ExcelExport, NetCommissionColLbl, true, 0, false, ColorLbl);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        Loan: Record lvnLoan;
                        CommissionProfile: Record lvnCommissionProfile;
                        IdentifierName: Text;
                        IdentifierAmount: Decimal;
                        IdentifierAmountTtl: Decimal;
                    begin
                        if Number = 1 then
                            TempLoanCommissionBuffer.FindSet()
                        else
                            TempLoanCommissionBuffer.Next();
                        //Loan Level Line Info
                        IdentifierAmountTtl := 0;
                        ExcelExport.NewRow(0);
                        ExcelExport.StyleRow(DefaultBoolean::No, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                        WriteToExcel(ExcelExport, TempLoanCommissionBuffer."Loan No.", true, 0, false, '');
                        Loan.Get(TempLoanCommissionBuffer."Loan No.");
                        WriteToExcel(ExcelExport, Loan."Date Funded", true, 0, false, '');
                        CommissionProfile.Get(TempLoanCommissionBuffer."Profile Code");
                        WriteToExcel(ExcelExport, CommissionProfile.Name, true, 0, false, '');
                        WriteToExcel(ExcelExport, Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name", true, 0, false, '');
                        ExcelExport.FormatCell(NumberFormat);
                        WriteToExcel(ExcelExport, Loan."Loan Amount", true, 0, false, '');
                        ExcelExport.FormatCell(NumberFormat);
                        WriteToExcel(ExcelExport, TempLoanCommissionBuffer."Commission Amount", true, 0, false, '');
                        WriteToExcel(ExcelExport, TempLoanCommissionBuffer.Bps, true, 0, false, '');
                        //Identifiers 
                        TempAdditionalLinesBuffer.Reset();
                        TempAdditionalLinesBuffer.SetRange("Loan No.", TempLoanCommissionBuffer."Loan No.");
                        if TempAdditionalLinesBuffer.FindSet() then
                            repeat
                                if PrintDetails then begin
                                    ExcelExport.NewRow(0);
                                    ExcelExport.StyleRow(DefaultBoolean::No, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                                    ExcelExport.SkipCells(14);
                                    AdditionalCommissions.Get(AdditionalCommissionsCodes.Get(TempAdditionalLinesBuffer."Calculation Line No."), IdentifierName);
                                    WriteToExcel(ExcelExport, IdentifierName, true, 0, false, '');
                                    ExcelExport.FormatCell(NumberFormat);
                                    WriteToExcel(ExcelExport, TempAdditionalLinesBuffer."Commission Amount", true, 0, false, '');
                                end;
                                IdentifierAmountTtl += TempAdditionalLinesBuffer."Commission Amount";
                            until TempAdditionalLinesBuffer.Next() = 0;
                        if PrintDetails then begin
                            ExcelExport.NewRow(0);
                            ExcelExport.SkipCells(14);
                            ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                            AdditionalCommissionTotals.Get(TempLoanCommissionBuffer."Loan No.", IdentifierAmount);
                            ExcelExport.SkipCells(4);
                            ExcelExport.FormatCell(NumberFormat);
                            WriteToExcel(ExcelExport, IdentifierAmount + TempLoanCommissionBuffer."Commission Amount", true, 0, false, '');
                        end else begin
                            ExcelExport.FormatCell(NumberFormat);
                            WriteToExcel(ExcelExport, IdentifierAmountTtl, true, 0, false, '');
                            ExcelExport.FormatCell(NumberFormat);
                            WriteToExcel(ExcelExport, IdentifierAmountTtl + TempLoanCommissionBuffer."Commission Amount", true, 0, false, '');
                        end;
                        GlobalIdentifierAmountTtl += IdentifierAmountTtl;
                        //Totals
                        LoanAmountTtl += Loan."Loan Amount";
                        CommissionAmountTtl += TempLoanCommissionBuffer."Commission Amount";
                    end;

                    trigger OnPostDataItem()
                    begin
                        //Totals 
                        ExcelExport.NewRow(0);
                        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                        ExcelExport.SkipCells(7);
                        WriteToExcel(ExcelExport, TotalColLbl, false, 0, false, '');
                        ExcelExport.FormatCell(NumberFormat);
                        WriteToExcel(ExcelExport, LoanAmountTtl, true, 0, false, '');
                        ExcelExport.FormatCell(NumberFormat);
                        WriteToExcel(ExcelExport, CommissionAmountTtl, true, 0, false, '');
                        if PrintDetails then
                            ExcelExport.SkipCells(4)
                        else
                            ExcelExport.SkipCells(2);
                        ExcelExport.FormatCell(NumberFormat);
                        WriteToExcel(ExcelExport, GlobalIdentifierAmountTtl, true, 0, false, '');
                        ExcelExport.FormatCell(NumberFormat);
                        WriteToExcel(ExcelExport, CommissionAmountTtl + GlobalIdentifierAmountTtl, true, 0, false, '');
                    end;
                }
                dataitem(PeriodLevel; Integer)
                {
                    DataItemTableView = sorting(Number);

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, TempPeriodLevelBuffer.Count());
                        if PeriodLevel.Count() > 0 then begin
                            ExcelExport.NewRow(0);
                            ExcelExport.NewRow(0);
                            ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 10, '', '', '');
                            WriteToExcel(ExcelExport, OverrideColLbl, true, 14, false, '');
                            ExcelExport.NewRow(0);
                            ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                            WriteToExcel(ExcelExport, DescriptionColLbl, true, 0, false, ColorLbl);
                            WriteToExcel(ExcelExport, LoanNoColLbl, true, 0, false, ColorLbl);
                            WriteToExcel(ExcelExport, DateFundedColLbl, true, 0, false, ColorLbl);
                            WriteToExcel(ExcelExport, OriginatorColLbl, true, 0, false, ColorLbl);
                            WriteToExcel(ExcelExport, BorrowerNameColLbl, true, 0, false, ColorLbl);
                            WriteToExcel(ExcelExport, BaseAmountColLbl, true, 0, false, ColorLbl);
                            WriteToExcel(ExcelExport, BpsColLbl, true, 0, false, ColorLbl);
                            WriteToExcel(ExcelExport, AmountColLbl, true, 0, false, ColorLbl);
                        end;
                    end;

                    trigger OnAfterGetRecord()
                    var
                        Loan: Record lvnLoan;
                        LoanNo: Code[20];
                        DateFunded: Text;
                        BorrowerName: Text;
                    begin
                        if Number = 1 then
                            TempPeriodLevelBuffer.FindSet()
                        else
                            TempPeriodLevelBuffer.Next();
                        if Loan.Get(TempPeriodLevelBuffer."Loan No.") then begin
                            LoanNo := TempPeriodLevelBuffer."Loan No.";
                            DateFunded := Format(Loan."Date Funded");
                            BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name";
                        end;
                        ExcelExport.NewRow(0);
                        ExcelExport.StyleRow(DefaultBoolean::No, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                        WriteToExcel(ExcelExport, TempPeriodLevelBuffer.Description, true, 0, false, '');
                        WriteToExcel(ExcelExport, LoanNo, true, 0, false, '');
                        WriteToExcel(ExcelExport, DateFunded, true, 0, false, '');
                        WriteToExcel(ExcelExport, TempProfileBuffer.Name, true, 0, false, '');
                        WriteToExcel(ExcelExport, BorrowerName, true, 0, false, '');
                        ExcelExport.FormatCell(NumberFormat);
                        WriteToExcel(ExcelExport, TempPeriodLevelBuffer."Base Amount", true, 0, false, '');
                        WriteToExcel(ExcelExport, TempPeriodLevelBuffer.Bps, true, 0, false, '');
                        ExcelExport.FormatCell(NumberFormat);
                        WriteToExcel(ExcelExport, TempPeriodLevelBuffer."Commission Amount", true, 0, false, '');
                        //Period Totals
                        PeriodAmountTtl += TempPeriodLevelBuffer."Commission Amount";
                        PeriodBaseAmountTtl += TempPeriodLevelBuffer."Base Amount";
                        LoanNo := '';
                        DateFunded := '';
                        BorrowerName := '';
                    end;

                    trigger OnPostDataItem()
                    begin
                        if PeriodLevel.Count > 0 then begin
                            //Period Totals
                            ExcelExport.NewRow(0);
                            ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                            ExcelExport.SkipCells(9);
                            WriteToExcel(ExcelExport, TotalColLbl, false, 0, false, '');
                            ExcelExport.FormatCell(NumberFormat);
                            WriteToExcel(ExcelExport, PeriodBaseAmountTtl, true, 0, false, '');
                            ExcelExport.SkipCells(2);
                            ExcelExport.FormatCell(NumberFormat);
                            WriteToExcel(ExcelExport, PeriodAmountTtl, true, 0, false, '');
                        end;
                    end;
                }
                dataitem(Adjustments; Integer)
                {
                    DataItemTableView = sorting(Number);

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, TempAdjustemntsBuffer.Count());
                        if Adjustments.Count() > 0 then begin
                            ExcelExport.NewRow(0);
                            ExcelExport.NewRow(0);
                            ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 10, '', '', '');
                            WriteToExcel(ExcelExport, AdjustmentsColLbl, true, 5, false, '');
                            ExcelExport.NewRow(0);
                            ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                            WriteToExcel(ExcelExport, DescriptionColLbl, true, 2, false, ColorLbl);
                            WriteToExcel(ExcelExport, AmountColLbl, true, 1, false, ColorLbl);
                        end;
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            TempAdjustemntsBuffer.FindSet()
                        else
                            TempAdjustemntsBuffer.Next();
                        ExcelExport.NewRow(0);
                        ExcelExport.StyleRow(DefaultBoolean::No, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                        WriteToExcel(ExcelExport, TempAdjustemntsBuffer.Description, true, 2, false, '');
                        ExcelExport.FormatCell(NumberFormat);
                        WriteToExcel(ExcelExport, TempAdjustemntsBuffer."Commission Amount", true, 1, false, '');
                        AdjustmentsTtl += TempAdjustemntsBuffer."Commission Amount";
                    end;

                    trigger OnPostDataItem()
                    begin
                        if Adjustments.Count > 0 then begin
                            ExcelExport.NewRow(0);
                            ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
                            WriteToExcel(ExcelExport, TotalColLbl, true, 2, false, '');
                            ExcelExport.FormatCell(NumberFormat);
                            WriteToExcel(ExcelExport, AdjustmentsTtl, true, 1, false, '');
                        end;
                    end;
                }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, TempProfileBuffer.Count());
                end;

                trigger OnAfterGetRecord()
                var
                    CommissionJournalLine: Record lvnCommissionJournalLine;
                    CommissionValueEntry: Record lvnCommissionValueEntry;
                    Idx: Integer;
                    TtlAmount: Decimal;
                    PeriodText: Text;
                begin
                    if Number = 1 then
                        TempProfileBuffer.FindSet()
                    else begin
                        TempProfileBuffer.Next();
                        ExcelExport.NewSheet();
                    end;
                    ExcelExport.RenameSheet(TempProfileBuffer.Name);
                    ExcelExport.NewRow(0);
                    //Schedule Header
                    ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 10, '', '', '');
                    PeriodText := CommissionSchedule."Period Name" + ' (' + Format(CommissionSchedule."Period Start Date") + ' - ' + Format(CommissionSchedule."Period End Date") + ')';
                    WriteToExcel(ExcelExport, PeriodText, true, 18, true, '');
                    //Profile Header
                    ExcelExport.NewRow(-20);
                    ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 10, '', '', '');
                    WriteToExcel(ExcelExport, TempProfileBuffer.Name, true, 18, true, '');
                    Clear(AdditionalCommissions);
                    CalculateData();
                    AdditionalCommissionsCodes := AdditionalCommissions.Keys();
                    TempLoanCommissionBuffer.Reset();
                    TempLoanCommissionBuffer.DeleteAll();
                    if not CommissionSchedule."Period Posted" then begin
                        CommissionJournalLine.Reset();
                        CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
                        CommissionJournalLine.SetRange("Profile Code", TempProfileBuffer.Code);
                        CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Loan Level");
                        CommissionJournalLine.SetRange("Identifier Code", CommissionSetup."Commission Identifier Code");
                        CommissionJournalLine.SetRange("Manual Adjustment", false);
                        if CommissionJournalLine.FindSet() then
                            repeat
                                if not TempLoanCommissionBuffer.Get(CommissionJournalLine."Loan No.") then begin
                                    Clear(TempLoanCommissionBuffer);
                                    TempLoanCommissionBuffer."Entry No." := EntryNo;
                                    TempLoanCommissionBuffer."Loan No." := CommissionJournalLine."Loan No.";
                                    TempLoanCommissionBuffer."Commission Amount" := CommissionJournalLine."Commission Amount";
                                    TempLoanCommissionBuffer."Profile Code" := CommissionJournalLine."Profile Code";
                                    if TempLoanCommissionBuffer.Insert() then;
                                    EntryNo += 1;
                                end else
                                    if CommissionJournalLine."Commission Amount" <> 0 then begin
                                        TempLoanCommissionBuffer."Loan No." := CommissionJournalLine."Loan No.";
                                        TempLoanCommissionBuffer."Commission Amount" += CommissionJournalLine."Commission Amount";
                                        TempLoanCommissionBuffer.Modify();
                                    end;
                            until CommissionJournalLine.Next() = 0;
                        //Period Level
                        CommissionJournalLine.Reset();
                        CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
                        CommissionJournalLine.SetRange("Profile Code", TempProfileBuffer.Code);
                        CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Period Level");
                        CommissionJournalLine.SetRange("Manual Adjustment", false);
                        if CommissionJournalLine.FindSet() then
                            repeat
                                TempPeriodLevelBuffer := CommissionJournalLine;
                                TempPeriodLevelBuffer.Insert();
                            until CommissionJournalLine.Next() = 0;
                        //Adjustments
                        CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
                        CommissionJournalLine.SetRange("Profile Code", TempProfileBuffer.Code);
                        CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Period Level");
                        CommissionJournalLine.SetRange("Manual Adjustment", true);
                        if CommissionJournalLine.FindSet() then
                            repeat
                                TempAdjustemntsBuffer := CommissionJournalLine;
                                TempAdjustemntsBuffer.Insert();
                            until CommissionJournalLine.Next() = 0;
                        if AdditionalCommissionsCodes.Count() > 0 then
                            for Idx := 1 to AdditionalCommissionsCodes.Count() do begin
                                CommissionJournalLine.Reset();
                                TempLoanCommissionBuffer.Reset();
                                TempLoanCommissionBuffer.FindSet();
                                repeat
                                    TtlAmount := 0;
                                    CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
                                    CommissionJournalLine.SetRange("Profile Code", TempProfileBuffer.Code);
                                    CommissionJournalLine.SetRange("Loan No.", TempLoanCommissionBuffer."Loan No.");
                                    CommissionJournalLine.SetRange("Identifier Code", AdditionalCommissionsCodes.Get(Idx));
                                    CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Loan Level");
                                    if CommissionJournalLine.FindSet() then
                                        repeat
                                            TempAdditionalLinesBuffer := CommissionJournalLine;
                                            TempAdditionalLinesBuffer."Calculation Line No." := Idx;
                                            if not AdditionalCommissionTotals.ContainsKey(TempAdditionalLinesBuffer."Loan No.") then
                                                AdditionalCommissionTotals.Add(TempAdditionalLinesBuffer."Loan No.", TempAdditionalLinesBuffer."Commission Amount")
                                            else
                                                AdditionalCommissionTotals.Set(TempAdditionalLinesBuffer."Loan No.", AdditionalCommissionTotals.Get(TempAdditionalLinesBuffer."Loan No.") + TempAdditionalLinesBuffer."Commission Amount");
                                            if TempAdditionalLinesBuffer.Insert() then;
                                        until CommissionJournalLine.Next() = 0;
                                until TempLoanCommissionBuffer.Next() = 0;
                            end;
                    end else begin
                        CommissionValueEntry.Reset();
                        CommissionValueEntry.SetRange("Schedule No.", CommissionSchedule."No.");
                        CommissionValueEntry.SetRange("Profile Code", TempProfileBuffer.Code);
                        CommissionValueEntry.SetRange("Profile Line Type", CommissionValueEntry."Profile Line Type"::"Loan Level");
                        CommissionValueEntry.SetRange("Identifier Code", CommissionSetup."Commission Identifier Code");
                        CommissionValueEntry.SetRange("Manual Adjustment", false);
                        if CommissionValueEntry.FindSet() then
                            repeat
                                if not TempLoanCommissionBuffer.Get(CommissionValueEntry."Loan No.") then begin
                                    Clear(TempLoanCommissionBuffer);
                                    TempLoanCommissionBuffer."Loan No." := CommissionValueEntry."Loan No.";
                                    TempLoanCommissionBuffer."Commission Amount" := CommissionValueEntry."Commission Amount";
                                    TempLoanCommissionBuffer."Profile Code" := CommissionValueEntry."Profile Code";
                                    TempLoanCommissionBuffer.Insert();
                                end else
                                    if CommissionValueEntry."Commission Amount" <> 0 then begin
                                        TempLoanCommissionBuffer."Loan No." := CommissionValueEntry."Loan No.";
                                        TempLoanCommissionBuffer."Commission Amount" += CommissionJournalLine."Commission Amount";
                                        TempLoanCommissionBuffer.Modify();
                                    end;
                            until CommissionValueEntry.Next() = 0;
                        //Period Level
                        CommissionValueEntry.Reset();
                        CommissionValueEntry.SetRange("Schedule No.", CommissionSchedule."No.");
                        CommissionValueEntry.SetRange("Profile Code", TempProfileBuffer.Code);
                        CommissionValueEntry.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Period Level");
                        CommissionValueEntry.SetRange("Manual Adjustment", false);
                        if CommissionValueEntry.FindSet() then
                            repeat
                                TempPeriodLevelBuffer."Line No." := CommissionValueEntry."Entry No.";
                                TempPeriodLevelBuffer."Commission Amount" := CommissionValueEntry."Commission Amount";
                                TempPeriodLevelBuffer."Loan No." := CommissionValueEntry."Loan No.";
                                TempPeriodLevelBuffer."Base Amount" := CommissionValueEntry."Base Amount";
                                TempPeriodLevelBuffer.Description := CommissionValueEntry.Description;
                                TempPeriodLevelBuffer."Profile Code" := CommissionValueEntry."Profile Code";
                                TempPeriodLevelBuffer.Bps := CommissionValueEntry.Bps;
                                TempPeriodLevelBuffer.Insert();
                            until CommissionValueEntry.Next() = 0;
                        //Adjustments
                        CommissionValueEntry.Reset();
                        CommissionValueEntry.SetRange("Schedule No.", CommissionSchedule."No.");
                        CommissionValueEntry.SetRange("Profile Code", TempProfileBuffer.Code);
                        CommissionValueEntry.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Period Level");
                        CommissionValueEntry.SetRange("Manual Adjustment", true);
                        if CommissionValueEntry.FindSet() then
                            repeat
                                CommissionValueEntry.Description := CommissionValueEntry.Description;
                                CommissionValueEntry."Commission Amount" := CommissionValueEntry."Base Amount";
                            until CommissionValueEntry.Next() = 0;
                        if AdditionalCommissions.Count() > 0 then
                            for Idx := 1 to AdditionalCommissions.Count() do begin
                                CommissionValueEntry.Reset();
                                TempLoanCommissionBuffer.Reset();
                                TempLoanCommissionBuffer.FindSet();
                                repeat
                                    CommissionValueEntry.SetRange("Schedule No.", CommissionSchedule."No.");
                                    CommissionValueEntry.SetRange("Profile Code", TempProfileBuffer.Code);
                                    CommissionValueEntry.SetRange("Loan No.", TempLoanCommissionBuffer."Loan No.");
                                    CommissionValueEntry.SetRange("Identifier Code", AdditionalCommissionsCodes.Get(Idx));
                                    CommissionValueEntry.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Loan Level");
                                    if CommissionValueEntry.FindSet() then
                                        repeat
                                            TempAdditionalLinesBuffer."Loan No." := CommissionValueEntry."Loan No.";
                                            TempAdditionalLinesBuffer."Calculation Line No." := Idx;
                                            TempAdditionalLinesBuffer."Line No." := CommissionValueEntry."Entry No.";
                                            TempAdditionalLinesBuffer."Commission Amount" := CommissionValueEntry."Commission Amount";
                                            if TempAdditionalLinesBuffer.Insert() then;
                                        until CommissionValueEntry.Next() = 0;
                                until TempLoanCommissionBuffer.Next() = 0;
                            end;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                CommissionJournalLine: Record lvnCommissionJournalLine;
                CommissionValueEntry: Record lvnCommissionValueEntry;
                CommissionProfile: Record lvnCommissionProfile;
            begin
                if not CommissionSchedule."Period Posted" then begin
                    CommissionJournalLine.Reset();
                    CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
                    if CommissionJournalLine.FindSet() then
                        repeat
                            CommissionProfile.Reset();
                            CommissionProfile.SetRange(Code, CommissionJournalLine."Profile Code");
                            if CommissionProfile.FindFirst() then begin
                                Clear(TempProfileBuffer);
                                TempProfileBuffer.Code := CommissionProfile.Code;
                                TempProfileBuffer.Name := CommissionProfile.Name;
                                if TempProfileBuffer.Insert() then;
                            end;
                        until CommissionJournalLine.Next() = 0;
                end else begin
                    CommissionValueEntry.Reset();
                    CommissionValueEntry.SetRange("Schedule No.", CommissionSchedule."No.");
                    if CommissionValueEntry.FindSet() then
                        repeat
                            CommissionProfile.Reset();
                            CommissionProfile.SetRange(Code, CommissionValueEntry."Profile Code");
                            if CommissionProfile.FindFirst() then begin
                                Clear(TempProfileBuffer);
                                TempProfileBuffer.Code := CommissionProfile.Code;
                                TempProfileBuffer.Name := CommissionProfile.Name;
                                if TempProfileBuffer.Insert() then;
                            end;
                        until CommissionValueEntry.Next() = 0;
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
                    field(PrintDetailsField; PrintDetails) { Caption = 'Print Details'; ApplicationArea = All; }
                    field(ExportFormatField; ExportFormat) { Caption = 'Output Format'; ApplicationArea = All; }
                    field(NumberFormatField; NumberFormat) { Caption = 'Currency Format'; ApplicationArea = All; TableRelation = lvnNumberFormat.Code; }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CommissionSetup.Get();
        ExcelExport.Init(ExportCallLbl, ExportFormat);
        TempAdditionalLinesBuffer.Reset();
        TempAdditionalLinesBuffer.DeleteAll();
        TempLoanCommissionBuffer.Reset();
        TempLoanCommissionBuffer.DeleteAll();
        TempProfileBuffer.Reset();
        TempProfileBuffer.DeleteAll();
        TempProfileBuffer.Reset();
        TempProfileBuffer.DeleteAll();
    end;

    trigger OnPostReport()
    begin
        ExcelExport.NewRow(0);
        ExcelExport.NewRow(0);
        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
        WriteToExcel(ExcelExport, TotalColLbl, true, 2, true, ColorLbl);
        ExcelExport.NewRow(0);
        ExcelExport.StyleRow(DefaultBoolean::No, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
        WriteToExcel(ExcelExport, NetCommissionColLbl, true, 1, false, '');
        ExcelExport.FormatCell(NumberFormat);
        WriteToExcel(ExcelExport, CommissionAmountTtl + GlobalIdentifierAmountTtl, false, 0, false, '');
        ExcelExport.NewRow(0);
        ExcelExport.StyleRow(DefaultBoolean::No, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
        WriteToExcel(ExcelExport, OverrideColLbl, true, 1, false, '');
        ExcelExport.FormatCell(NumberFormat);
        WriteToExcel(ExcelExport, PeriodAmountTtl, false, 0, false, '');
        ExcelExport.NewRow(0);
        ExcelExport.StyleRow(DefaultBoolean::No, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
        WriteToExcel(ExcelExport, AdjustmentsColLbl, true, 1, false, '');
        ExcelExport.FormatCell(NumberFormat);
        WriteToExcel(ExcelExport, AdjustmentsTtl, false, 0, false, '');
        ExcelExport.NewRow(0);
        ExcelExport.StyleRow(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', '');
        WriteToExcel(ExcelExport, TotalColLbl, true, 1, false, '');
        ExcelExport.FormatCell(NumberFormat);
        WriteToExcel(ExcelExport, PeriodAmountTtl + CommissionAmountTtl + GlobalIdentifierAmountTtl + AdjustmentsTtl, false, 0, false, '');
        ExcelExport.Download(GetFileName());
    end;

    var
        TempLoanCommissionBuffer: Record lvnLoanCommissionBuffer temporary;
        TempProfileBuffer: Record lvnCommissionProfile temporary;
        TempAdditionalLinesBuffer: Record lvnCommissionJournalLine temporary;
        TempPeriodLevelBuffer: Record lvnCommissionJournalLine temporary;
        TempAdjustemntsBuffer: Record lvnCommissionJournalLine temporary;
        CommissionSetup: Record lvnCommissionSetup;
        ExcelExport: Codeunit lvnExcelExport;
        NumberFormat: Code[20];
        AdditionalCommissions: Dictionary of [Code[20], Text];
        AdditionalCommissionTotals: Dictionary of [Code[20], Decimal];
        ExportFormat: Enum lvnGridExportMode;
        PrintDetails: Boolean;
        LoanAmountTtl: Decimal;
        GlobalIdentifierAmountTtl: Decimal;
        CommissionAmountTtl: Decimal;
        EntryNo: Integer;
        DefaultBoolean: Enum lvnDefaultBoolean;
        PeriodBaseAmountTtl: Decimal;
        PeriodAmountTtl: Decimal;
        AdjustmentsTtl: Decimal;
        ExportCallLbl: Label 'CommissionPrintoutExport';
        FileNameLbl: Label 'CommissionPrintout';
        TotalColLbl: Label 'Total';
        LoanNoColLbl: Label 'Loan No.';
        DescriptionColLbl: Label 'Description';
        DateFundedColLbl: Label 'Date Funded';
        OriginatorColLbl: Label 'Originator';
        LoanAmountColLbl: Label 'Loan Amount';
        GrossCommissionColLbl: Label 'Gross Commission';
        BpsColLbl: Label 'Bps';
        IdentiferNameColLbl: Label 'Add. Identifier Name';
        IdentifierAmountColLbl: Label 'Add. Identifier Amount';
        AmountColLbl: Label 'Amount';
        BorrowerNameColLbl: Label 'Borrower Name';
        OverrideColLbl: Label 'Override/Referrals';
        AdjustmentsColLbl: Label 'Adjustments';
        NetCommissionColLbl: Label 'Net Commission';
        BaseAmountColLbl: Label 'Base Amount';
        ColorLbl: Label '#E1E1E1';
        AdditionalCommissionsCodes: List of [Code[20]];

    local procedure HasCommissions(IdentifierCode: Code[20]): Boolean
    var
        CommissionValueEntry: Record lvnCommissionValueEntry;
        CommissionJournalLine: Record lvnCommissionJournalLine;
    begin
        if CommissionSchedule."Period Posted" then begin
            CommissionValueEntry.Reset();
            CommissionValueEntry.SetRange("Schedule No.", CommissionSchedule."No.");
            CommissionValueEntry.SetRange("Profile Code", TempProfileBuffer.Code);
            CommissionValueEntry.SetRange("Profile Line Type", CommissionValueEntry."Profile Line Type"::"Loan Level");
            CommissionValueEntry.SetRange("Identifier Code", IdentifierCode);
            exit(not CommissionValueEntry.IsEmpty());
        end else begin
            CommissionJournalLine.Reset();
            CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
            CommissionJournalLine.SetRange("Profile Code", TempProfileBuffer.Code);
            CommissionJournalLine.SetRange("Profile Line Type", CommissionValueEntry."Profile Line Type"::"Loan Level");
            CommissionJournalLine.SetRange("Identifier Code", IdentifierCode);
            exit(not CommissionJournalLine.IsEmpty());
        end;
    end;

    local procedure CalculateData()
    var
        CommissionIdentifier: Record lvnCommissionIdentifier;
    begin
        CommissionIdentifier.Reset();
        CommissionIdentifier.SetRange("Additional Identifier", true);
        if CommissionIdentifier.FindSet() then
            repeat
                if HasCommissions(CommissionIdentifier.Code) then
                    AdditionalCommissions.Add(CommissionIdentifier.Code, CommissionIdentifier.Name);
            until CommissionIdentifier.Next() = 0;
    end;

    local procedure GetFileName(): Text
    begin
        case ExportFormat of
            ExportFormat::Html:
                exit(FileNameLbl + '.html');
            ExportFormat::Pdf:
                exit(FileNameLbl + '.pdf');
            else
                exit(FileNameLbl + '.xlsx');
        end;
    end;

    local procedure WriteToExcel(
        ExcelExport: Codeunit lvnExcelExport;
        Output: Variant;
        CreateRange: Boolean;
        SkipCells: Integer;
        CenterText: Boolean;
        CellColor: Text)
    begin
        if CreateRange then
            ExcelExport.BeginRange();
        if CellColor <> '' then
            ExcelExport.StyleCell(DefaultBoolean::Yes, DefaultBoolean::Default, DefaultBoolean::Default, 9, '', '', CellColor);
        if Output.IsCode() or Output.IsText() or Output.IsTextConstant() then
            ExcelExport.WriteString(Output);
        if Output.IsDecimal() or Output.IsInteger() then
            ExcelExport.WriteNumber(Output);
        if Output.IsDate() then
            ExcelExport.WriteDate(Output);
        if CreateRange then begin
            ExcelExport.SkipCells(SkipCells);
            ExcelExport.MergeRange(CenterText);
        end;
    end;
}